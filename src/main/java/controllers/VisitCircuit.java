package controllers;

import models.Locality;
import models.Vehicle;
import models.graph.Algorithms;
import models.graph.Edge;
import models.graph.map.MapGraph;
import utils.LowAutonomyException;

import java.util.*;

public class VisitCircuit {
    /**
     * Finds the optimal delivery circuit based on given parameters.
     *
     * @param graph
     * @param origin
     * @param numHubs
     * @param vehicle
     * @return List<Locality> List of localities representing the optimal delivery circuit.
     */
    public static List<Locality> findOptimalDeliveryCircuit(MapGraph<Locality, Double> graph, Locality origin, int numHubs, Vehicle vehicle) {
        HubOptimization hubOptimization = new HubOptimization();
        List<Locality> hubs = hubOptimization.orderByAllCriteria(graph, numHubs);

        hubs.remove(origin);
        List<Locality> goingPath = findShortestPathThroughVertices(graph, origin, hubs, vehicle.getAutonomy());

        if (goingPath.isEmpty())
            System.exit(1);

        // Coming path calculation
        Locality newOrgin = goingPath.get(goingPath.size()-1);
        LinkedList<Locality> comingPath = new LinkedList<>();
        Algorithms.shortestPath(graph, newOrgin, origin, Comparator.naturalOrder(), Double::sum, 0.0, comingPath);
        comingPath.remove(newOrgin);

        List<Locality> result = new ArrayList<>(goingPath);
        result.addAll(comingPath);

        List<Locality> finalResult = new ArrayList<>();
        Locality previousLocality = null;

        for (Locality currentLocality  : result) {
            if (previousLocality == null || !previousLocality.equals(currentLocality)) {
                finalResult.add(currentLocality);
            }
            previousLocality = currentLocality;
        }

        return finalResult;
    }

    /**
     * Finds the shortest path through specified vertices in the given map graph.
     *
     * @param graph
     * @param origin
     * @param targetVertices
     * @param autonomy
     * @return List<Locality>
     */
    public static List<Locality> findShortestPathThroughVertices(MapGraph<Locality, Double> graph, Locality origin, List<Locality> targetVertices, double autonomy) {
        try {
            List<Locality> optimalPath = new ArrayList<>();
            Set<Locality> remainingVertices = new HashSet<>(targetVertices);
            Locality currentVertex = origin;

            while (!remainingVertices.isEmpty()) {
                List<List<Locality>> paths = new ArrayList<>();

                for (Locality targetVertex : remainingVertices) {
                    List<List<Locality>> currentPaths = bfsShortestPath(graph, currentVertex, targetVertex, autonomy);

                    if (currentPaths != null && !currentPaths.isEmpty()) {
                        paths.addAll(currentPaths);
                    }
                }

                if (paths.isEmpty()) {
                    throw new LowAutonomyException("Error. Didn't find all the hubs. Low autonomy");
                }

                List<Locality> shortestPath = findShortestPath(paths, graph);
                optimalPath.addAll(shortestPath);
                remainingVertices.remove(optimalPath.get(optimalPath.size() - 1));
                currentVertex = optimalPath.get(optimalPath.size() - 1);
            }

            return optimalPath;
        } catch (LowAutonomyException e) {
            // Handle the exception (print a message, log, etc.)
            System.out.println("Low autonomy exception: " + e.getMessage());
            return Collections.emptyList(); // Return an empty list or handle it as needed
        }
    }

    /**
     * Finds the shortest path among a list of paths based on the given map graph.
     *
     * @param paths
     * @param graph
     * @return List<Locality>
     */
    public static List<Locality> findShortestPath(List<List<Locality>> paths, MapGraph<Locality, Double> graph) {
        List<Locality> shortestPath = null;
        double minCost = Double.MAX_VALUE;

        for (List<Locality> path : paths) {
            double totalCost = calculateCost(path, graph);
            if (shortestPath == null || totalCost < minCost) {
                minCost = totalCost;
                shortestPath = new ArrayList<>(path);
            }
        }

        return shortestPath;
    }

    /**
     * Performs a breadth-first search to find the shortest paths between two localities.
     *
     * @param graph
     * @param start
     * @param end
     * @return List<List<Locality>>
     */
    public static List<List<Locality>> bfsShortestPath(MapGraph<Locality, Double> graph, Locality start, Locality end, double autonomy) {
        List<List<Locality>> allPaths = new ArrayList<>();
        PriorityQueue<List<Locality>> queue = new PriorityQueue<>(Comparator.comparingDouble(path -> calculateCost(path, graph)));
        Set<Locality> visited = new HashSet<>();

        queue.add(Arrays.asList(start));
        visited.add(start);

        while (!queue.isEmpty()) {
            List<Locality> currentPath = queue.poll();
            Locality currentVertex = currentPath.get(currentPath.size() - 1);

            if (currentVertex.equals(end)) {
                allPaths.add(new ArrayList<>(currentPath));
            }

            for (Locality neighbor : graph.adjVertices(currentVertex)) {
                if (!visited.contains(neighbor)) {
                    double distance = calculateDistanceBetweenLocalitys(currentVertex, neighbor, graph);

                    if (autonomy >= distance) {
                        List<Locality> newPath = new ArrayList<>(currentPath);
                        newPath.add(neighbor);
                        queue.add(newPath);
                        visited.add(neighbor);
                    }
                }
            }
        }

        return allPaths.isEmpty() ? null : allPaths;
    }

    /**
     * Calculates the total cost of a path based on the given map graph.
     *
     * @param path
     * @param graph
     * @return double
     */
    private static double calculateCost(List<Locality> path, MapGraph<Locality, Double> graph) {
        double totalCost = 0.0;

        for (int i = 0; i < path.size() - 1; i++) {
            Locality currentVertex = path.get(i);
            Locality nextVertex = path.get(i + 1);
            Edge<Locality, Double> edge = graph.edge(currentVertex, nextVertex);
            if (edge != null) {
                totalCost += edge.getWeight();
            } else {
                return Double.MAX_VALUE;
            }
        }

        return totalCost;
    }

    /**
     * Calculates the time taken to travel a certain distance based on speed.
     *
     * @param speed
     * @param travelledDistance
     * @return double
     */
    public double calculateTravelledTime(double speed, double travelledDistance) {
        double speedMetersPerSecond = speed * (1000.0 / 3600.0);

        double tempoSegundos = travelledDistance / speedMetersPerSecond;

        double minutes = tempoSegundos / 60;

        return minutes;
    }

    /**
     * Calculates the discharged time based on the number of hubs and discharged time per hub.
     *
     * @param numHubs
     * @param dischargedTime
     * @return double
     */
    public double calculateDischargedTime(int numHubs, double dischargedTime) {
        return numHubs*dischargedTime;
    }

    /**
     * Calculates the charging time based on the number of charges and charging time per charge.
     *
     * @param numberOfCharges
     * @param chargingTime
     * @return double
     */
    public double calculateChargingTime(int numberOfCharges, double chargingTime) {
        return numberOfCharges * chargingTime;
    }

    /**
     * Calculates the total time spent, considering travel time, discharged time, and charging time.
     *
     * @param travelledTime
     * @param dischargedTime
     * @param chargingTime
     * @return double
     */
    public double calculateTotalTimeSpend(double travelledTime, double dischargedTime, double chargingTime) {
        return travelledTime + dischargedTime + chargingTime;
    }

    /**
     * Determines if the vehicle should charge based on current autonomy and distance to hubs.
     *
     * @param currentAutonomy
     * @param distanceHubs
     * @return boolean
     */
    public boolean shouldCharge(double currentAutonomy, double distanceHubs) {
        return currentAutonomy < distanceHubs;
    }

    /**
     * Calculates the distance between two localities in the given map graph.
     *
     * @param hub1
     * @param hub2
     * @param graph
     * @return double
     */
    public static double calculateDistanceBetweenLocalitys(Locality hub1, Locality hub2, MapGraph<Locality, Double> graph) {
        Edge<Locality, Double> edge = graph.edge(hub1, hub2);
        return (edge != null) ? edge.getWeight() : Double.MAX_VALUE;
    }

    public List<Locality> getHubs(MapGraph<Locality, Double> graph, int nHubs){
        HubOptimization hubOptimization = new HubOptimization();
        return hubOptimization.orderByAllCriteria(graph, nHubs);
    }
}

