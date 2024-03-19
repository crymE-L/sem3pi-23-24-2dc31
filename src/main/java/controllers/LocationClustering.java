package controllers;

import models.Locality;
import models.graph.Algorithms;
import models.graph.Edge;
import models.graph.map.MapGraph;

import java.io.IOException;
import java.util.*;
import java.util.function.BinaryOperator;

import static controllers.HubOptimization.orderByAllCriteria;
import static models.graph.Algorithms.*;

/**
 * This class serves the purpose of organizing the localities
 * into N clusters, each with one hub.
 *
 * @author Gustavo Lima, 1221349@isep.ipp.pt
 */
public class LocationClustering {
    /**
     * This method organizes the localities into N clusters, each with one hub.
     * @param mapGraph
     * @param numberOfClusters
     * @return
     */
    public static Map<Locality, Set<Locality>> organizeGraphIntoClusters(MapGraph<Locality, Double> mapGraph, int numberOfClusters) {
        Map<Locality, Set<Locality>> clusters = new HashMap<>();
        List<Locality> hubs = orderByAllCriteria(mapGraph, numberOfClusters);

        int totalVertices = mapGraph.numVertices();
        int maxVerticesPerCluster = totalVertices / numberOfClusters;
        int remainingVertices = totalVertices % numberOfClusters;

        if (remainingVertices > 0) {
            maxVerticesPerCluster++;
        }

        Set<Locality> assignedLocalities = new HashSet<>();

        for (Locality hub : hubs) {

            Set<Locality> cluster = new HashSet<>();
            cluster.add(hub);

            int verticesInCluster = 1;

            while (verticesInCluster < maxVerticesPerCluster && !hubs.isEmpty()) {
                Map<Edge, Double> shortestPathsMap = new HashMap<>();

                for (Edge edge : mapGraph.edges()) {
                    Locality startLocality = (Locality) edge.getVOrig();
                    Locality endLocality = (Locality) edge.getVDest();

                    if (!assignedLocalities.contains(startLocality) && !assignedLocalities.contains(endLocality)) {
                        boolean[] visitedLocality = new boolean[mapGraph.numVertices()];
                        Locality[] paths = new Locality[mapGraph.numVertices()];
                        Double[] numberOfDistances = new Double[mapGraph.numVertices()];
                        Map<Edge, Integer> edgeUsageCount = new HashMap<>();

                        shortestPathDijkstraWithEdgeCount(mapGraph, startLocality, Comparator.naturalOrder(),
                                Double::sum, 0.0, visitedLocality, paths, numberOfDistances, edgeUsageCount);

                        int targetIndex = mapGraph.key(endLocality);
                        if (numberOfDistances[targetIndex] != null) {
                            double currentShortestPaths = numberOfDistances[targetIndex];
                            shortestPathsMap.put(edge, currentShortestPaths);
                        }
                    }
                }

                if (shortestPathsMap.isEmpty()) {
                    break;
                }

                List<Map.Entry<Edge, Double>> sortedShortestPaths = new ArrayList<>(shortestPathsMap.entrySet());
                sortedShortestPaths.sort(Map.Entry.<Edge, Double>comparingByValue().reversed());

                Edge edgeToAdd = sortedShortestPaths.get(0).getKey();
                Locality startLocality = (Locality) edgeToAdd.getVOrig();
                Locality endLocality = (Locality) edgeToAdd.getVDest();

                cluster.add(startLocality);
                cluster.add(endLocality);

                assignedLocalities.add(startLocality);
                assignedLocalities.add(endLocality);

                verticesInCluster += 2;

                mapGraph.removeEdge((Locality) edgeToAdd.getVOrig(), (Locality) edgeToAdd.getVDest());
            }

            clusters.put(hub, cluster);
            assignedLocalities.addAll(cluster);
        }

        return clusters;
    }

    /**
     * Executes Dijkstra's algorithm to compute the shortest paths from a given origin locality (vertex)
     * while also counting the number of times each edge is traversed along these paths.
     *
     * @param g               The MapGraph representing the graph structure.
     * @param vOrig           The origin locality (vertex) for calculating shortest paths.
     * @param ce              The comparator defining the order for comparing Double values.
     * @param sum             The BinaryOperator for summing two Double values.
     * @param zero            The initial value for distance initialization.
     * @param visited         Boolean array to mark visited localities during computation.
     * @param pathKeys        Array to store the locality keys forming the shortest path.
     * @param dist            Array to store the cumulative distance of the shortest path.
     * @param edgeUsageCount  Map to track the count of traversals for each edge in the paths.
     */
    private static void shortestPathDijkstraWithEdgeCount(MapGraph<Locality, Double> g, Locality vOrig,
                                                          Comparator<Double> ce, BinaryOperator<Double> sum,
                                                          Double zero, boolean[] visited, Locality[] pathKeys,
                                                          Double[] dist, Map<Edge, Integer> edgeUsageCount) {

        int numVerts = g.numVertices();

        Arrays.fill(visited, false);
        Arrays.fill(dist, null);
        Arrays.fill(pathKeys, null);

        int vkey = g.key(vOrig);
        dist[vkey] = zero;
        pathKeys[vkey] = vOrig;

        while (true) {
            vOrig = null;
            Double minDist = null;  // Next vertex that has minimum distance

            for (int i = 0; i < numVerts; i++) {
                if (!visited[i] && dist[i] != null && (minDist == null || ce.compare(dist[i], minDist) < 0)) {
                    minDist = dist[i];
                    vOrig = g.vertex(i);
                }
            }

            if (vOrig == null) break;

            vkey = g.key(vOrig);
            visited[vkey] = true;

            for (Locality dest : g.adjVertices(vOrig)) {
                int vkeyAdj = g.key(dest);
                Edge edge = g.edge(vOrig, dest);
                Double edgeWeight = (Double) edge.getWeight();

                if (!visited[vkeyAdj]) {
                    Double s = sum.apply(dist[vkey], edgeWeight);

                    if (dist[vkeyAdj] == null || ce.compare(dist[vkeyAdj], s) > 0) {
                        dist[vkeyAdj] = s;
                        pathKeys[vkeyAdj] = dest;

                        // Increment the usage count for the edge
                        edgeUsageCount.put(edge, edgeUsageCount.getOrDefault(edge, 0) + 1);
                    }
                }
            }
        }
    }

    public static String formatClusterOutput(Map<Locality, Set<Locality>> clusters) {
        StringBuilder formattedOutput = new StringBuilder();

        for (Map.Entry<Locality, Set<Locality>> entry : clusters.entrySet()) {
            Locality hub = entry.getKey();
            Set<Locality> localities = entry.getValue();

            formattedOutput.append("Cluster with hub ").append(hub.getName()).append(": ");
            boolean firstLocality = true;

            for (Locality locality : localities) {
                if (!firstLocality) {
                    formattedOutput.append(", ");
                }
                formattedOutput.append(locality.getName());
                firstLocality = false;
            }

            formattedOutput.append("\n");
        }

        return formattedOutput.toString();
    }

    /**
     * Main for testing purposes
     * @param args
     * @throws Exception
     */
    public static void main(String[] args) throws Exception {
        DistributionDataToModel dataToModel = new DistributionDataToModel("locais_small.csv", "distancias_small.csv", "schedules_small.csv");
        MapGraph<Locality, Double> mapGraph = dataToModel.getDistances();

        LocationClustering locationClustering = new LocationClustering();

        System.out.println(formatClusterOutput(locationClustering.organizeGraphIntoClusters(mapGraph, 3)));
    }
}