package controllers;

import models.Locality;
import models.graph.Algorithms;
import models.graph.map.*;

import java.util.*;

import org.apache.commons.lang3.tuple.ImmutablePair;
import org.apache.commons.lang3.tuple.MutablePair;
import org.apache.commons.lang3.tuple.Pair;
import utils.Utils;

public class MaximumHubsController {
    MapGraph<Locality, Double> hubMapGraph;
    MapGraph<Locality, Double> hubMapGraphClone;
    MapGraph<Locality, Double> trueHubMapGraph = new MapGraph<>(true);
    HashMap<ImmutablePair<Integer, Integer>, Path> trueHubMapGraphEdgesDetails = new HashMap<>();
    MutablePair<Integer, Integer> currentTime = new MutablePair<>();
    Locality startingLocation;
    int autonomy;
    double velocity;
    int chargingTime;
    int unloadingTime;
    double currentAutonomy;
    List<Locality> trueHubs;

    /**
     * Constructor for the maximum hubs controller
     * @param mapGraph
     * @param numberOfHubs
     */
    public MaximumHubsController(MapGraph<Locality, Double> mapGraph, int numberOfHubs) {
        this.hubMapGraph = mapGraph;
        this.trueHubs = HubOptimization.orderByAllCriteria(mapGraph, numberOfHubs);
    }

    /**
     * This method calculates the path with the most hubs
     * @return
     */
    public List<HubTrip> getPathWithMostHubs() {
        currentAutonomy = autonomy;
        hubMapGraphClone = hubMapGraph.clone();
        generateTrueMapGraph();
        if (trueHubs.contains(startingLocation))
            System.out.printf("Delivery denied on %s due to being the starting point.\n ", startingLocation.getName());
        return nearestNeighbour();
    }

    /**
     * This method generates the true map graph
     */
    private void generateTrueMapGraph() {
        // trueHubMapGraph = new MapGraph<>(true);

        for (Locality hub : trueHubs) {
            trueHubMapGraph.addVertex(hub);
        }

        // trueHubMapGraph.addVertex(startingLocation);

        for (Locality hubI : hubMapGraph.vertices()) {
            for (Locality hubJ : hubMapGraph.vertices()) {
                if (hubI != hubJ) {
                    if (hubMapGraph.edge(hubI, hubJ) == null) {
                        while(true) {
                            Path hubPath = new Path();
                            Double path = Algorithms.shortestPath(hubMapGraphClone, hubI, hubJ, Comparator.naturalOrder(), Double::sum, 0.0, hubPath.getShortestPath());
                            if (path == null) {
                                if (getId(hubI.getName()) < getId(hubJ.getName()))
                                    System.out.printf("There is no path available between %s and %s.\n", hubI.getName(), hubJ.getName());
                                break;
                            }
                            Optional<Pair<Locality, Locality>> problemEdge = hubPath.updateValues(hubMapGraphClone, autonomy);
                            if (problemEdge.isEmpty()) {
                                trueHubMapGraphEdgesDetails.put(new ImmutablePair<>(getId(hubI.getName()), getId(hubJ.getName())), hubPath);
                                hubMapGraph.addEdge(hubI, hubJ, hubPath.getWeight());
                                break;
                            } else {
                                hubMapGraphClone.removeEdge(problemEdge.get().getLeft(), problemEdge.get().getRight());
                            }
                        }
                    }
                }
            }
        }
    }

    /**
     * This method calculates the nearest neighbour path
     * @return
     */
    private List<HubTrip> nearestNeighbour(){
        int numVert = hubMapGraph.numVertices();
        Set<Locality> visitedVerts = new HashSet<>();
        List<HubTrip> tour = new ArrayList<>();
        Locality currentVert = startingLocation;
        visitedVerts.add(currentVert);
        Set<Locality> tooEarlyVerts = new HashSet<>();
        boolean wouldArriveEarly = false;
        boolean missedHubs = false;
        for (int i = 0; i < numVert - 1; i++) {
            Locality nearestNeighbour = findNearestNeighbor(currentVert, visitedVerts, tooEarlyVerts);
            if (nearestNeighbour != null) {
                HubTrip newTrip = new HubTrip(currentAutonomy, getDesiredHubPath(currentVert, nearestNeighbour));
                newTrip.calculateCharges(autonomy);
                currentAutonomy = newTrip.getFinishingAutonomy();
                if (newTrip.calculateTime(currentTime, velocity, chargingTime)) {
                    System.out.println("It is not possible to reach a new hub after midnight. The trip was canceled.");
                    return tour;
                }

                Pair<Integer, Integer> arrivalTime = newTrip.getFinishingTime();
                Pair<Integer, Integer> hubOpeningTime = Utils.timeStringToIntPair(nearestNeighbour.timeToString(nearestNeighbour.getOpeningHours()));
                if (Utils.timeDifference(arrivalTime, hubOpeningTime) < 0) {
                    tooEarlyVerts.add(nearestNeighbour);
                    i--;
                    wouldArriveEarly = true;
                } else {
                    visitedVerts.add(nearestNeighbour);
                    Pair<Integer, Integer> hubClosingTime = Utils.timeStringToIntPair(nearestNeighbour.timeToString(nearestNeighbour.getClosingHours()));
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

    /**
     * Getter for the desired path
     * @param currentVert
     * @param visitedVerts
     * @param tooEarlyVerts
     * @return
     */
    private Locality findNearestNeighbor(Locality currentVert, Set<Locality> visitedVerts, Set<Locality> tooEarlyVerts) {
        double minDistance = Double.MAX_VALUE;
        Locality nearestNeighbour = null;

        for (Locality hub : hubMapGraph.vertices()) {
            if (hub != currentVert) {
                if (hubMapGraph.edge(currentVert, hub) != null) {
                    double edgeWeight = hubMapGraph.edge(currentVert, hub).getWeight();
                    if (!visitedVerts.contains(hub) && !tooEarlyVerts.contains(hub) && edgeWeight < minDistance) {
                        minDistance = edgeWeight;
                        nearestNeighbour = hub;
                    }
                }
            }
        }
        return nearestNeighbour;
    }

    /**
     * Getter for the desired path
     * @param startingLocation
     * @param finishingLocation
     * @return
     */
    public Path getDesiredHubPath(Locality startingLocation, Locality finishingLocation) {
        return trueHubMapGraphEdgesDetails.get(new ImmutablePair<>(startingLocation.getName(), finishingLocation.getName()));
    }

    /**
     * Setter for the starting location
     * @param startingLocation
     */
    public void setStartingLocation(Locality startingLocation) {
        this.startingLocation = startingLocation;
    }

    /**
     * Getter for the starting location
     * @return
     */
    public Locality getStartingLocation() {
        return startingLocation;
    }

    /**
     * Setter for the current time
     * @param time
     */
    public void setCurrentTime(String time) {
        try {
            this.currentTime = Utils.timeStringToIntPair(time);
        } catch (Exception e) {
            throw new IllegalArgumentException("The time format is: hh:mm!");
        }
    }

    /**
     * Setter for the current time
     * @param time
     */
    public void setCurrentTime(Pair<Integer,Integer> time) {
        this.currentTime.setLeft(time.getLeft());
        this.currentTime.setRight(time.getRight());
    }

    /**
     * Setter for the autonomy
     * @param autonomy
     */
    public void setAutonomy(int autonomy) {
        this.autonomy = autonomy;
    }

    /**
     * Setter for the velocity
     * @param velocity
     */
    public void setVelocity(double velocity) {
        this.velocity = velocity;
    }

    /**
     * Setter for the velocity
     * @return
     */
    public double getVelocity() {
        return velocity;
    }

    /**
     * Setter for the charging time
     * @param chargingTime
     */
    public void setChargingTime(int chargingTime) {
        this.chargingTime = chargingTime;
    }

    /**
     * Setter for the charging time
     * @return
     */
    public int getChargingTime() {
        return chargingTime;
    }

    /**
     * Setter for the unloading time
     * @param unloadingTime
     */
    public void setUnloadingTime(int unloadingTime) {
        this.unloadingTime = unloadingTime;
    }

    /**
     * Getter for the unloading time
     * @return
     */
    public int getUnloadingTime() {
        return unloadingTime;
    }

    /**
     * Setter for the true hubs
     * @param trueHubs
     */
    public void setTrueHubs(List<Locality> trueHubs) {
        this.trueHubs = trueHubs;
    }

    /**
     * Getter for the true hubs
     * @return
     */
    public List<Locality> getTrueHubs() {
        return trueHubs;
    }

    /**
     * Getter for the map graph
     * @return
     */
    public List<Locality> getAllLocations() {
        return hubMapGraph.vertices();
    }

    /**
     * Getter for the id
     * @param name
     * @return
     */
    public int getId(String name) {
        return Integer.parseInt(name.substring(2));
    }

    /**
     * Testing purposes
     * @param args
     * @throws Exception
     */
    public static void main(String[] args) throws Exception {
        DistributionDataToModel dataToModel = new DistributionDataToModel("locais_small.csv", "distancias_small.csv", "schedules_small.csv");
        MapGraph<Locality, Double> mapGraph = dataToModel.getDistances();
        int numberOfHubs = 3;

        MaximumHubsController maximumHubsController = new MaximumHubsController(mapGraph, numberOfHubs);

        maximumHubsController.setUnloadingTime(20);
        maximumHubsController.setStartingLocation(dataToModel.getLocaties().get(0));
        maximumHubsController.setAutonomy(2000000);
        maximumHubsController.setCurrentTime("08:00");
        maximumHubsController.setChargingTime(20);
        maximumHubsController.setVelocity(20);

        maximumHubsController.getPathWithMostHubs();
    }
}