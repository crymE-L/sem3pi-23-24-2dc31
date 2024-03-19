package controllers;

import models.*;
import models.graph.Algorithms;
import models.graph.map.*;

import java.util.*;

import org.apache.commons.lang3.tuple.ImmutablePair;
import org.apache.commons.lang3.tuple.MutablePair;
import org.apache.commons.lang3.tuple.Pair;
import utils.Utils;

public class MaximiseHubsController {
    MapGraph<Locality, Double> hubMapGraph;
    MapGraph<Locality, Double> hubMapGraphClone;
    MapGraph<Locality, Double> trueHubMapGraph;
    HashMap<Pair<Integer,Integer>, Path> trueHubMapGraphEdgesDetails = new HashMap<>();
    Locality startingLocation;
    MutablePair<Integer, Integer> currentTime = new MutablePair<>();
    int autonomy;
    double velocity;
    int chargingTime;
    int unloadingTime;
    Set<Locality> trueHubs = new HashSet<>();
    double currentAutonomy;

    public MaximiseHubsController() throws Exception {
        DistributionDataToModel dataToModel = new DistributionDataToModel("locais_small.csv", "distancias_small.csv", "schedules_small.csv");
        hubMapGraph = dataToModel.getDistances();
    }

    public List<HubTrip> getPathWithMostHubs() {
        currentAutonomy = autonomy;
        hubMapGraphClone = hubMapGraph.clone();
        if (trueHubs.contains(startingLocation))
            System.out.printf("Delivery denied on %s due to being the starting point.\n ", startingLocation.getName());
        return nearestNeighbour();
    }

        public void generateTrueMapGraph(MapGraph<Locality, Double> trueHubMapGraph, int numberOfHubs) {
            List<Locality> hubs = HubOptimization.orderByAllCriteria(trueHubMapGraph, numberOfHubs);

            for (Locality hub : hubs) {
                trueHubMapGraph.addVertex(hub);
            }

            Locality start = trueHubMapGraph.vertices().iterator().next();
            trueHubMapGraph.addVertex(start);

            for (Locality hubI : trueHubMapGraph.vertices()) {
                for (Locality hubJ : trueHubMapGraph.vertices()) {
                    if (hubI != hubJ) {
                        if (trueHubMapGraph.edge(hubI, hubJ) == null) {
                            while(true) {
                                Path hubPath = new Path();
                                Double path = Algorithms.shortestPath(trueHubMapGraph, hubI, hubJ, Comparator.naturalOrder(), Double::sum, 0.0, hubPath.getShortestPath());
                                if (path == null) {
                                    if (getId(hubI.getName()) < getId(hubJ.getName()))
                                        System.out.printf("There is no path available between %s and %s.\n", hubI.getName(), hubJ.getName());
                                    break;
                                }
                                Optional<Pair<Locality, Locality>> problemEdge = hubPath.updateValues(trueHubMapGraph, autonomy);
                                if (problemEdge.isEmpty()) {
                                    trueHubMapGraphEdgesDetails.put(new ImmutablePair<>(getId(hubI.getName()), getId(hubJ.getName())), hubPath);
                                    trueHubMapGraph.addEdge(hubI, hubJ, hubPath.getWeight());
                                    break;
                                } else {
                                    trueHubMapGraph.removeEdge(problemEdge.get().getLeft(), problemEdge.get().getRight());
                                }
                            }
                        }
                    }
                }
            }
        }

    private List<HubTrip> nearestNeighbour(){
        int numVert = trueHubMapGraph.numVertices();
        boolean missedHubs = false;
        boolean wouldArriveEarly = false;

        Set<Locality> visitedVerts = new HashSet<>();
        Set<Locality> tooEarlyVerts = new HashSet<>();

        Locality currentVert = startingLocation;
        visitedVerts.add(currentVert);
        List<HubTrip> tour = new ArrayList<>();

        for (int i = 0; i < numVert - 1; i++) {
            Locality nearestNeighbour = findNearestNeighbor(currentVert, visitedVerts, tooEarlyVerts);
            if (nearestNeighbour != null) {
                HubTrip newTrip = new HubTrip(currentAutonomy, getDesiredPath(currentVert, nearestNeighbour));
                newTrip.calculateCharges(autonomy);
                currentAutonomy = newTrip.getFinishingAutonomy();
                if (newTrip.calculateTime(currentTime, velocity, chargingTime)) {
                    System.out.println("It is not possible to reach a new hub after midnight. The trip was canceled.");
                    return tour;
                }
                Pair<Integer, Integer> arrivalTime = newTrip.getFinishingTime();

                String openingHours = new String(nearestNeighbour.getOpeningHours());
                String closingHours = new String(nearestNeighbour.getClosingHours());

                Pair<Integer, Integer> hubOpeningTime = Utils.timeStringToIntPair(openingHours);
                if (Utils.timeDifference(arrivalTime, hubOpeningTime) < 0) {
                    tooEarlyVerts.add(nearestNeighbour);
                    i--;
                    wouldArriveEarly = true;
                } else {
                    visitedVerts.add(nearestNeighbour);
                    Pair<Integer, Integer> hubClosingTime = Utils.timeStringToIntPair(closingHours);
                    if (Utils.timeDifference(arrivalTime, hubClosingTime) > 0) {
                        missedHubs = true;
                    } else {
                        tooEarlyVerts = new HashSet<>();
                        setCurrentTime(arrivalTime);
                        Utils.addTime(currentTime, unloadingTime);
                        tour.add(newTrip);
                    }
                    currentVert = nearestNeighbour;
                }
            }
        }
        if (wouldArriveEarly) {
            if (visitedVerts.size() > 1)
                System.out.println("The route has changed due to different schedules in the hubs.");
        }
        if (missedHubs)
            System.out.println("It was not possible to reach every hub before closing.");
        if (!tooEarlyVerts.isEmpty())
            System.out.println("The trip ended before one or more hubs opened up.");
        return tour;
    }



    private Locality findNearestNeighbor(Locality currentVert, Set<Locality> visitedVerts, Set<Locality> tooEarlyVerts) {
        double minDistance = Double.MAX_VALUE;
        Locality nearestNeighbour = null;

        for (Locality hub : trueHubMapGraph.vertices()) {
            if (hub != currentVert) {
                if (trueHubMapGraph.edge(currentVert, hub) != null) {
                    double edgeWeight = trueHubMapGraph.edge(currentVert, hub).getWeight();
                    if (!visitedVerts.contains(hub) && !tooEarlyVerts.contains(hub) && edgeWeight < minDistance) {
                        minDistance = edgeWeight;
                        nearestNeighbour = hub;
                    }
                }
            }
        }
        return nearestNeighbour;
    }

    public Path getDesiredPath(Locality startingLocation, Locality finishingLocation) {
        return trueHubMapGraphEdgesDetails.get(new ImmutablePair<>(getId(startingLocation.getName()), getId(finishingLocation.getName())));
    }

    public void setStartingLocation(Locality startingLocation) {
        this.startingLocation = startingLocation;
    }

    public Locality getStartingLocation() {
        return startingLocation;
    }

    public void setCurrentTime(String time) {
        try {
            this.currentTime = Utils.timeStringToIntPair(time);
        } catch (Exception e) {
            throw new IllegalArgumentException("The time format is: hh:mm!");
        }
    }

    public void setCurrentTime(Pair<Integer,Integer> time) {
        this.currentTime.setLeft(time.getLeft());
        this.currentTime.setRight(time.getRight());
    }

    public void setAutonomy(int autonomy) {
        this.autonomy = autonomy;
    }

    public void setVelocity(double velocity) {
        this.velocity = velocity;
    }

    public double getVelocity() {
        return velocity;
    }

    public void setChargingTime(int chargingTime) {
        this.chargingTime = chargingTime;
    }

    public int getChargingTime() {
        return chargingTime;
    }

    public void setUnloadingTime(int unloadingTime) {
        this.unloadingTime = unloadingTime;
    }

    public int getUnloadingTime() {
        return unloadingTime;
    }

    public void setTrueHubs(Set<Locality> trueHubs) {
        this.trueHubs = trueHubs;
    }

    public Set<Locality> getTrueHubs() {
        return trueHubs;
    }

    public List<Locality> getAllLocations() {
        return hubMapGraph.vertices();
    }

    public int getId(String name) {
        return Integer.parseInt(name.substring(2));
    }

    public static void main(String[] args) throws Exception {
        DistributionDataToModel dataToModel = new DistributionDataToModel("locais_small.csv", "distancias_small.csv", "schedules_small.csv");
        MapGraph<Locality, Double> mapGraph = dataToModel.getDistances();
        int numberOfHubs = 3;

        MaximiseHubsController maximizeHubsController = new MaximiseHubsController();

        maximizeHubsController.generateTrueMapGraph(mapGraph, numberOfHubs);
    }
}