package controllers;

import models.Locality;
import models.graph.map.MapGraph;
import utils.FileReadingSystem;

import java.io.IOException;
import java.util.ArrayList;

public class DistributionDataToModel {
	private ArrayList<ArrayList<String>> locationsData = new ArrayList<>();
	private ArrayList<ArrayList<String>> distancesData = new ArrayList<>();
	private ArrayList<ArrayList<String>> schedulesData = new ArrayList<>();

	private ArrayList<Locality> locaties = null;
	private MapGraph<Locality, Double> distances = null;

	public DistributionDataToModel(String locationsFile, String distancesFile, String scheduleFile) throws Exception {
		FileReadingSystem locationsReadingSystem = new FileReadingSystem(locationsFile, 2);
		FileReadingSystem distancesReadingSystem = new FileReadingSystem(distancesFile, 2);
		FileReadingSystem schedulesReadingSystem = new FileReadingSystem(scheduleFile, 2);

		this.locationsData = locationsReadingSystem.readData();
		this.distancesData = distancesReadingSystem.readData();
		this.schedulesData = schedulesReadingSystem.readData();

		this.insertLocalities();
		this.insertDistances();
		this.checkSchedules();
	}

	/**
	 * In this function we're going to insert all the
	 * localities in a list of type Locality
	 */
	private void insertLocalities() {
		this.locaties = new ArrayList<>();

		for(ArrayList<String> data : locationsData)
			this.locaties.add(
				new Locality(
					data.get(0),
					Double.parseDouble(data.get(1)),
					Double.parseDouble(data.get(2))
				)
			);
	}

	/**
	 * A simple function to get the locality
	 * by its name, so we can use it in
	 * the insertDistances function
	 *
	 * @param name
	 * @return Locality
	 */
	private Locality localityByName(String name) {
		for(Locality locality : this.locaties)
			if(locality.getName().equalsIgnoreCase(name))
				return locality;

		return null;
	}

	/**
	 * This function takes care of inserting the distances
	 * in a MapGraph
	 */
	private void insertDistances() {
		this.distances = new MapGraph<>(false);

		Locality origin;
		Locality destiny;

		for(ArrayList<String> data : this.distancesData) {
			origin = localityByName(data.get(0));
			destiny = localityByName(data.get(1));

			/**
			 * Since there's the chance that the vertexes
			 * already exist, then we're going to
			 * verify it
			 */
			if(!vertexExists(origin))
				this.distances.addVertex(origin);

			if(!vertexExists(destiny))
				this.distances.addVertex(destiny);

			this.distances.addEdge(
				origin,
				destiny,
				Double.parseDouble( data.get(2))
			);
		}
	}

	/**
	 * This function takes a Locality as a parameter,
	 * which is the vertex object, and verifies
	 * if it exists in the vertexes list
	 * or not.
	 *
	 * For information verify the function validVertex
	 * present in the MapGraph class
	 *
	 * @param vertex
	 * @return boolean
	 */
	private boolean vertexExists(Locality vertex) {
		return this.distances.validVertex(vertex);
	}

	/**
	 * Get all the localities present in the ArrayList
	 *
	 * @return ArrayList<Locality>
	 */
	public ArrayList<Locality> getLocaties() {
		if(this.locaties == null)
			throw new IllegalStateException("Localities are null or not initialized.");

		return this.locaties;
	}

	/**
	 * Get the distances graph
	 *
	 * @return MapGraph<Locality, Double>
	 */
	public MapGraph<Locality, Double> getDistances() {
		if(this.distances == null)
			throw new IllegalStateException("Distances are null or not initialized.");

		return this.distances;
	}

	/**
	 * In this function we're going through all the schedules in the
	 * provided file and then update all the schedules for the
	 * existing hubs and create new ones if they don't exist
	 */
	private void checkSchedules() throws Exception {
		Locality currentLocality;

		for (ArrayList<String> schedule : this.schedulesData) {
			if(this.localityByName(schedule.get(0)) == null) {
				System.out.printf("Hub %s does not exist.\n", schedule.get(0));

				continue;
			}

			currentLocality = this.localityByName(schedule.get(0));

			assert currentLocality != null;

			currentLocality.setOpeningHours(
				currentLocality.timeStringToTime(
					schedule.get(1)
				)
			);
			currentLocality.setClosingHours(
				currentLocality.timeStringToTime(
					schedule.get(2)
				)
			);
		}
	}
}
