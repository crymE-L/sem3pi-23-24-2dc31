package controllers;

import models.Locality;
import models.graph.Algorithms;
import models.graph.map.MapGraph;

import java.io.IOException;
import java.util.*;

public class HubPath {

    public static double calculateTimeTrip (Double averageSpeed, Double totalDistance) {
        return totalDistance/averageSpeed;
    }

    public static String convertToHoursAndMinutes(double horasDecimal) {
        if (horasDecimal < 0) {
            return "Valor de horas inválido.";
        }

        int horas = (int) horasDecimal;
        int minutos = (int) ((horasDecimal - horas) * 60);

        return String.format("%dh %02dmin", horas, minutos);
    }

    public static Locality localityExists(MapGraph<Locality, Double> mapGraph, String localityName) {
        for (Locality locality : mapGraph.vertices()) {
            if (locality.getName().equals(localityName)) {
                return locality;
            }
        }
        return null;
    }


    public static void main(String[] args) throws Exception {
        DistributionDataToModel dataToModel = new DistributionDataToModel("locais_small.csv", "distancias_small.csv", "schedules_small.csv");
        MapGraph<Locality, Double> mapGraph = dataToModel.getDistances();
        Locality origin = null;
        Locality hub = null;
        Scanner reader = new Scanner(System.in);

        while (origin == null) {
            System.out.print("Enter a locality name >> ");
            String localityName = reader.next();

            origin = HubPath.localityExists(mapGraph, localityName);

            if (origin == null) {
                System.out.println("Localidade não encontrada. Tente novamente.");
            }
        }


        while (hub == null) {
            System.out.print("Enter a hub name >> ");
            String localityName = reader.next();

            hub = HubPath.localityExists(mapGraph, localityName);

            if (hub == null) {
                System.out.println("Hub não encontrado. Tente novamente.");
            }
        }

        System.out.print("Choose the vehicle autonomy (in km) >> ");
        double autonomy = reader.nextDouble();


        System.out.print("Choose the vehicle average speed (in km/h) >> ");
        double averageSpeed = reader.nextDouble();

        System.out.println();

        LinkedList<Locality> shortPath = new LinkedList<>();


        ArrayList<LinkedList<Locality>> paths = Algorithms.allPathsWithAutonomy(mapGraph, origin, hub, autonomy * 1000);

        double totalDistance = 0;

        if (paths != null) {
            for (LinkedList<Locality> path : paths) {
                double totalDistanceWithinPath = 0;

                System.out.println("Point of Origin: " + origin);
                System.out.print("Path: ");
                for (Locality vertex : path) {
                    System.out.print(vertex + " ");
                }
                System.out.println();

                for (int i = 0; i < path.size() - 1; i++) {
                    Locality currentVertex = path.get(i);
                    Locality nextVertex = path.get(i + 1);

                    double distanceBetweenVertices = Algorithms.shortestPath(mapGraph, currentVertex, nextVertex, Comparator.naturalOrder(), Double::sum, 0.0, shortPath);
                    totalDistanceWithinPath += distanceBetweenVertices;

                    System.out.printf("%s -> %s : Distance %.2f Km\n", currentVertex, nextVertex, distanceBetweenVertices / 1000);
                }

                System.out.printf("Total Distance for Path: %.2f Km\n", totalDistanceWithinPath / 1000);
                System.out.println("Time Spent: " + convertToHoursAndMinutes(calculateTimeTrip(averageSpeed * 1000, totalDistanceWithinPath)));
                System.out.println();
            }
        }
    }
}