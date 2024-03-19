package controllers;

import models.Locality;
import models.graph.Edge;
import models.graph.map.MapGraph;

import java.io.IOException;
import java.util.*;

/**
 * This class serves the purpose of determining the network that
 * connects all localities with the minimum distance.
 *
 * @author Gustavo Lima, 1221349@isep.ipp.pt
 */
public class MinimumSpanningTree {

    /**
     * Method that uses Prim's algorithm to determine
     * the minimum spanning tree (MST).
     * @param network
     * @return MapGraph with the minimum spanning tree (MST)
     */
    public static MapGraph<Locality, Double> findMinimumConnectionNetwork(MapGraph<Locality, Double> network) {
        Set<Locality> minimumSpanningTree = new LinkedHashSet<>();
        PriorityQueue<Edge<Locality, Double>> priorityQueue = new PriorityQueue<>(Comparator.comparing(Edge::getWeight));

        // Create a copy of the graph received by parameter to build the MST
        MapGraph<Locality, Double> minimumConnectionNetwork = new MapGraph<>(network.isDirected());

        // Get whatever vertex to start the algorithm
        Locality start = network.vertices().iterator().next();

        // Add the vertex we just got to the MST
        minimumSpanningTree.add(start);

        // Add the vertex of starting vertex to the priority queue
        for (Edge<Locality, Double> edge : network.outgoingEdges(start)) {
            priorityQueue.add(edge);
        }

        // Start using Prim's algorithm
        while (minimumSpanningTree.size() < network.vertices().size()) {
            Edge<Locality, Double> minEdge = priorityQueue.poll();

            Locality vOrig = minEdge.getVOrig();
            Locality vDest = minEdge.getVDest();

            if (!minimumSpanningTree.contains(vDest)) {
                minimumSpanningTree.add(vDest);
                minimumConnectionNetwork.addVertex(vDest);
                minimumConnectionNetwork.addEdge(vOrig, vDest, minEdge.getWeight());

                for (Edge<Locality, Double> edge : network.outgoingEdges(vDest)) {
                    if (!minimumSpanningTree.contains(edge.getVDest())) {
                        priorityQueue.add(edge);
                    }
                }
            }
        }

        return minimumConnectionNetwork;
    }

    /**
     * Method that extracts all localities from the minimum spanning tree (MST).
     * @param network
     * @return Set of localities
     */
    public static Set<Locality> extractLocalitiesFromMST(MapGraph<Locality, Double> network) {
        Set<Locality> localities = new HashSet<>();
        MapGraph<Locality, Double> minimumSpanningTree = findMinimumConnectionNetwork(network);

        if (minimumSpanningTree == null) {
            System.out.println("Minimum spanning tree is null or empty.");
            return localities;
        }

        for (Edge<Locality, Double> edges : minimumSpanningTree.edges()) {
            localities.add(edges.getVOrig());
            localities.add(edges.getVDest());
        }

        return localities;
    }

    /**
     * Method to print the minimum spanning tree (MST)
     * accordingly to the following format:
     * 1. Localities
     * 2. Distance between each locality
     * 3. Total network distance
     *
     * @param network
     */
    public static void printMinimumSpanningTree(MapGraph<Locality, Double> network) {
        MapGraph<Locality, Double> minimumSpanningTree = findMinimumConnectionNetwork(network);
        Set<Locality> localities = extractLocalitiesFromMST(network);

        double totalNetworkDistance = 0.0;

        System.out.println("Minimum Spanning Tree details: ");
        for (Locality locality : localities) {
            System.out.println("Locality: " + locality.getName());
            Collection<Edge<Locality, Double>> outgoingEdges = minimumSpanningTree.outgoingEdges(locality);

            if (outgoingEdges != null) {
                for (Edge<Locality, Double> edge : outgoingEdges) {
                    if (edge.getVOrig() == locality) {
                        Locality destination = edge.getVDest();
                        double weight = edge.getWeight();

                        // Check if the destination's name comes before the origin's name
                        if (destination.getName().compareTo(locality.getName()) < 0) {
                            totalNetworkDistance += weight;
                            System.out.println(" -> Destination: " + destination.getName() + " || Distance: " + weight);
                        }
                    }
                }
            }
        }
        System.out.println("\nTotal Network Distance: " + totalNetworkDistance + "\n");
    }


    public static void main(String[] args) throws Exception {
        // For testing purposes ONLY

        DistributionDataToModel dataToModel = new DistributionDataToModel("locais_small.csv", "distancias_small.csv", "schedules_small.csv");
        ArrayList<Locality> locaties = dataToModel.getLocaties();
        MapGraph<Locality, Double> mapGraph = dataToModel.getDistances();

//        MapGraph<Locality, Double> graph = new MapGraph<>(false);

//        Locality localityA = new Locality("CT1");
//        Locality localityB = new Locality("CT2");
//        Locality localityC = new Locality("CT3");
//        Locality localityD = new Locality("CT4");
//        Locality localityE = new Locality("CT5");
//
//        graph.addVertex(localityA);
//        graph.addVertex(localityB);
//        graph.addVertex(localityC);
//        graph.addVertex(localityD);
//        graph.addVertex(localityE);
//
//        graph.addEdge(localityA, localityB, 1.0);
//        graph.addEdge(localityA, localityC, 2.0);
//        graph.addEdge(localityA, localityD, 2.0);
//        graph.addEdge(localityB, localityC, 2.0);
//        graph.addEdge(localityB, localityE, 2.0);
//        graph.addEdge(localityC, localityD, 2.0);
//        graph.addEdge(localityC, localityE, 2.0);
//        graph.addEdge(localityD, localityE, 2.0);

        MinimumSpanningTree mst = new MinimumSpanningTree();

        mst.printMinimumSpanningTree(mapGraph);
    }
}
