package controllers;

import com.sun.tools.javac.Main;
import interfaces.BaseController;
import models.*;
import models.graph.*;
import models.graph.map.*;

import java.io.IOException;
import java.util.*;

import java.util.Map;
import java.util.Scanner;

public class DistributionController implements BaseController {
	DistributionDataToModel dataToModel = new DistributionDataToModel("locais_small.csv", "distancias_small.csv", "schedules_small.csv");
	ArrayList<Locality> locaties = dataToModel.getLocaties();
	MapGraph<Locality, Double> mapGraph = dataToModel.getDistances();

	public DistributionController() throws Exception {
	}

	@Override
	public void run() throws Exception {
		Scanner reader = new Scanner(System.in);
		byte option = 0;

		while(option != 7) {
			this.showMenu();

			try {
				System.out.print("Choose an option >> ");
				option = reader.nextByte();
			} catch (Exception exception) {
				option = 0;
				reader.nextLine();
			}

			switch (option) {
				case 1:
					break;
				case 2:
					this.determineVehicleMinimumCourse();
					break;
				case 3:
					this.determineMinimumDistance();
					break;
				case 4:
					this.determineIdealLocationNHubs();
					break;
				case 5:
					this.determineDeliveryCircuit();
					break;
				case 6:
					this.clusterLocations();
					break;
				case 7:
					this.hubMaximise();
					break;
				case 8:
					break;
				default:
					System.out.println("Invalid option! Please choose a valid one.");
					break;
			}
		}

		try {
			Main.main(null);
		} catch(Exception exception) {
			System.out.println(exception.getMessage());
		}
	}

	@Override
	public void showMenu() {
		String[] menu = {
				"Find optimal path",
				"Determine vehicle minimum course",
				"Determine minimum distance",
				"Determine the ideal location of N hub",
				"Find delivery circuit through N hubs (with the most collaborators)",
				"Cluster the graph",
				"Maximise hubs"
		};

		BaseController.super.showMenu(menu);
	}

	private void findOptimalPath() {
		throw new UnsupportedOperationException("Not supported yet.");
	}

	private void determineVehicleMinimumCourse() {
		Map.Entry<Locality, Locality> furthestPair = Algorithms.furthestVertices(mapGraph, Comparator.naturalOrder(), Double::sum);
		LinkedList<Locality> shortPath = new LinkedList<>();
		List<Double> distances = new LinkedList<>();
		List<Locality> chargings = new ArrayList<>();

		Vehicle vehicle = new Vehicle(300000,1,1);
		double autonomy = vehicle.getAutonomy();
		double currentAutonomy = autonomy;


		Locality origin = furthestPair.getKey();
		Locality destination = furthestPair.getValue();

		System.out.println("\n");
		System.out.printf("Furthest locations are %s and %s \n", origin, destination);
		System.out.printf("Origin is %s \n", origin);
		System.out.printf("Destination is %s \n", destination);
		System.out.println("\n");
		System.out.println("Path between the two furthest locations in the distribution network:");


		LinkedList<Locality> localities = Algorithms.shortestPathElementsWithCharging(this.mapGraph, origin, destination, Comparator.naturalOrder(), Double::sum, 0.0, autonomy);
		double totalDistance = 0;
		double distanceBetweenLocalities = 0;

		if (localities != null) {
			for (int i = 0; i < localities.size() - 1; i++) {
				distanceBetweenLocalities = Algorithms.shortestPath(this.mapGraph, localities.get(i), localities.get(i + 1), Comparator.naturalOrder(), Double::sum, 0.0, shortPath);
				System.out.printf("%s -> %s : %.2f Km\n", localities.get(i).toString(), localities.get(i + 1).toString(), distanceBetweenLocalities/1000);
				totalDistance += distanceBetweenLocalities;
				distances.add(distanceBetweenLocalities);

				if (distances.get(i) > currentAutonomy) {
					chargings.add(localities.get(i));
					currentAutonomy = autonomy;
				} else {
					currentAutonomy -= distances.get(i);
				}
			}
		}

		System.out.println("\n");
		System.out.println("Locations where the car was charged:");
		for (int i = 0; i < chargings.size(); i++) {
			System.out.println(chargings.get(i).toString());
		}

		System.out.println("\n");
		int numCharges = chargings.size();
		System.out.printf("Number of charges needed: %d\n", numCharges);
		System.out.printf("Total distance of the path is %.02f km\n",totalDistance/1000);
	}

	private void determineMinimumDistance() {
		MinimumSpanningTree mst = new MinimumSpanningTree();

		mst.printMinimumSpanningTree(mapGraph);
	}

	private void determineIdealLocationNHubs() throws IOException {
		HubOptimization hubOptimization = new HubOptimization();
		List<Locality> orderedCriteria = hubOptimization.orderByAllCriteria(mapGraph, 5);

		System.out.println("Ordered hubs: ");
		for (Locality locality : orderedCriteria)
			System.out.printf("Hub: %s | Opening time: %s | Closing time: %s | Collaborators: %d\n",
					locality.getName(), locality.timeToString(locality.getOpeningHours()), locality.timeToString(locality.getClosingHours()), locality.getCollaborators());
	}

	private void determineDeliveryCircuit() {
		Scanner reader = new Scanner(System.in);
		DeliveryCircuit deliveryCircuit = new DeliveryCircuit();

		int count = 1;

		System.out.println("Hubs list:");
		for (Locality locality : mapGraph.vertices()) {
			System.out.printf("%d : %s\n", count, locality.getName());
			count ++;
		}
		System.out.print("Choose the origin hub >> ");
		int localityIndex = reader.nextInt();

		Locality originLocality = mapGraph.vertices().get(localityIndex-1);

		System.out.print("Choose the vehicle autonomy >> ");
		double autonomy = reader.nextDouble();

		System.out.print("Choose the vehicle average speed (in km/h) >> ");
		double averageSpeed = reader.nextDouble();

		System.out.print("Choose the vehicle charging time (in minutes) >> ");
		double userChargingTime = reader.nextInt();

		System.out.print("Choose the vehicle discharged time (in minutes) >> ");
		double userDischargedTime = reader.nextInt();

		Vehicle vehicle = new Vehicle(autonomy, averageSpeed, userChargingTime, userDischargedTime);

		System.out.print("Choose the number of hubs >> ");
		int numHubs = reader.nextInt();

		List<Locality> optimalCircuit = deliveryCircuit.findOptimalDeliveryCircuit(mapGraph, originLocality, numHubs, vehicle);

		double totalDistance = 0;
		double currentAutonomy = 0;
		List<Boolean> charge = new ArrayList<>();
		System.out.println("\nOptimal Delivery Circuit:");
		List<Locality> targetHubs = deliveryCircuit.getHubs(mapGraph, numHubs);

		for (int i = 0; i < optimalCircuit.size() - 1; i++) {
			Locality currentLocality = optimalCircuit.get(i);
			Locality nextLocality = optimalCircuit.get(i+1);

			double distanceLocalitys = deliveryCircuit.calculateDistanceBetweenLocalitys(currentLocality, nextLocality, mapGraph);
			totalDistance += distanceLocalitys;

			if (deliveryCircuit.shouldCharge(currentAutonomy, distanceLocalitys)) {
				charge.add(true);
				currentAutonomy = vehicle.getAutonomy();
			}

			System.out.printf("%s -> %s : distância = %.2f metros\n", currentLocality.getName(), nextLocality.getName(), distanceLocalitys);
			currentAutonomy -= distanceLocalitys;
		}

		System.out.println();

		for (Locality locality : targetHubs) {
			System.out.printf("Hub %s : %d collaborators\n", locality.getName(), locality.getCollaborators());
		}

		int numberOfCharges = charge.size();
		double travelledTime = deliveryCircuit.calculateTravelledTime(vehicle.getAverageSpeed(), totalDistance);
		double dischargedTime = deliveryCircuit.calculateDischargedTime(numHubs, vehicle.getDischargedTime());
		double chargingTime = deliveryCircuit.calculateChargingTime(numberOfCharges, vehicle.getChargingTime());
		double totalTimeSpend = deliveryCircuit.calculateTotalTimeSpend(travelledTime, dischargedTime, chargingTime);

		System.out.printf("\nTotal distance: %.2f meters\n", totalDistance);
		System.out.printf("Number of charges: %d\n", numberOfCharges);
		System.out.printf("Travelled time: %.1f minutes\n", travelledTime);
		System.out.printf("Dischared time: %.1f minutes\n", dischargedTime);
		System.out.printf("Charging time : %.1f minutes\n", chargingTime);
		System.out.printf("Total time spend: %.1f minutes\n\n", totalTimeSpend);
	}

	private void clusterLocations() {
		Scanner reader = new Scanner(System.in);
		LocationClustering locationClustering = new LocationClustering();

		System.out.print("Choose the amount of clusters >> ");
		int numberOfClusters = reader.nextInt();

		System.out.println(locationClustering.formatClusterOutput(locationClustering.organizeGraphIntoClusters(mapGraph, numberOfClusters)));
	}

	private void hubMaximise() throws Exception {
		Scanner reader = new Scanner(System.in);
		MaximiseHubsController hubMaximisation = new MaximiseHubsController();
		MapGraph<Locality, Double> mapGraph = dataToModel.getDistances();

		System.out.print("Choose the amount of hubs >> ");
		int numberOfHubs = reader.nextInt();

		hubMaximisation.generateTrueMapGraph(mapGraph, numberOfHubs);
	}
}
