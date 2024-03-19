package controllers;

import models.*;
import models.graph.*;
import models.graph.map.*;

import java.io.IOException;
import java.util.*;

/**
 * This class exists to perform all the functionalities required
 * by US02 of the information structures disciplin (ESINF).
 *
 * @author Diogo Martins (1221223)
 */
public class HubOptimization {

    /**
     * This method order by influence criterion the N hubs.
     *
     * @param mapGraph
     * @param numberOfHubs
     * @return List<Locality>
     */
    public static List<Locality> orderByAllCriteria(MapGraph<Locality, Double> mapGraph, int numberOfHubs){
        List<Locality> localities = new ArrayList<>(mapGraph.vertices());

        Comparator<Locality> influenceComparator = new Comparator<Locality>() {
            @Override
            public int compare(Locality locality1, Locality locality2) {
                int comparision = Integer.compare(mapGraph.inDegree(locality1), mapGraph.inDegree(locality2));

                if (comparision == 0)
                    comparision = Double.compare(calculateAverageDistance(mapGraph, locality1), calculateAverageDistance(mapGraph, locality2));

                if (comparision == 0)
                    comparision = Integer.compare(calculateCentrality(mapGraph, locality1), calculateCentrality(mapGraph, locality2));

                return comparision;
            }
        };

        localities.sort(influenceComparator);
        Collections.reverse(localities);

        List<Locality> selectedHubs = localities.subList(0, Math.min(numberOfHubs, localities.size()));

        assignCollaborators(selectedHubs);
        setHubOperatingHours(selectedHubs);

        return selectedHubs;
    }

    /**
     * This method calculates the average distance from a locality to all other localities in the graph.
     *
     * @param mapGraph
     * @param locality
     * @return double
     */
    public static double calculateAverageDistance(MapGraph<Locality, Double> mapGraph, Locality locality) {
        double totalDistance = 0;
        int numVertices = mapGraph.numVertices() - 1;

        for(Locality targetLocality : mapGraph.vertices()) {
            if(!locality.equals(targetLocality)){
                LinkedList<Locality> shortestPath = new LinkedList<>();
                Double distance = Algorithms.shortestPath(mapGraph, locality, targetLocality, Comparator.naturalOrder(), Double::sum, 0.0, shortestPath);

                if (distance != null)
                    totalDistance += distance;
            }
        }

        double averageDistance = totalDistance / numVertices;

        return averageDistance;
    }

    /**
     * Calculates centrality of a locality based on reachable vertices using Dijkstra's algorithm.
     *
     * @param mapGraph
     * @param locality
     * @return int
     */
    private static int calculateCentrality(MapGraph<Locality, Double> mapGraph, Locality locality) {
        int centrality = 0;
        for (Locality targetLocality : mapGraph.vertices()) {
            if (!locality.equals(targetLocality) && Algorithms.shortestPath(mapGraph, locality, targetLocality, Comparator.naturalOrder(), Double::sum, 0.0, new LinkedList<>()) != null) {
                centrality++;

            }
        }

        return centrality;
    }

    /**
     * This method assigns number of collaborators
     * to hubs based on the number in the locality.
     *
     * @param hubs
     */
    private static void assignCollaborators(List<Locality> hubs) {
        for (Locality hub : hubs)
            hub.setCollaborators(Integer.parseInt(hub.getName().substring(2)));

    }

    /**
     * This method sets hub opening hours based on
     * the number in the locality.
     *
     * @param hubs
     */
    private static void setHubOperatingHours(List<Locality> hubs) {
        for (Locality hub : hubs) {
            int hubNumber = Integer.parseInt(hub.getName().substring(2));
            if (hubNumber <= 105) {
                hub.setOperatingHours("09:00 - 14:00");
            } else if (hubNumber <= 215) {
                hub.setOperatingHours("11:00 - 16:00");
            } else {
                hub.setOperatingHours("12:00 - 17:00");
            }
        }
    }


    // For test reasons. DELETE
    public static void main(String[] args) throws Exception {
        long startTime = System.currentTimeMillis();

        DistributionDataToModel dataToModel = new DistributionDataToModel("locais_small.csv", "distancias_small.csv", "schedules_small.csv");
        MapGraph<Locality, Double> mapGraph = dataToModel.getDistances();

        HubOptimization hubOptimization = new HubOptimization();
        List<Locality> orderedCriteria = hubOptimization.orderByAllCriteria(mapGraph, 5);

        System.out.println("Ordered hubs: ");
        for (Locality locality : orderedCriteria) {
            System.out.println("Hub: " + locality.getName() + "  Time: " + locality.getOperatingHours() + " Collaborators: " + locality.getCollaborators());
        }

        // Timer (end)
        long elapsedTime = System.currentTimeMillis() - startTime;
        long elapsedSeconds = elapsedTime / 1000;
        long secondsDisplay = elapsedSeconds % 60;
        System.out.println("Milliseconds: " + elapsedTime);
        System.out.println("Seconds: " + secondsDisplay);
    }
}
