package controllers;

import com.sun.tools.javac.Main;
import interfaces.BaseController;
import org.apache.commons.io.FileUtils;
import utils.FileReadingSystem;
import utils.FileWritingSystem;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.Scanner;

public class LegacyController implements BaseController {
	/**
	 * The legacy file that was provided has an X number of
	 * sheets, and we can control them here
	 */
	private final int numberOfSheets = 5;

	/**
	 * We need to have these global variables because
	 * we're going to have some relationships on
	 * the tables that are going to need the
	 * values in these variables
	 */
	ArrayList<String[]> plants = new ArrayList<>();
	ArrayList<String[]> crops = new ArrayList<>();
	ArrayList<String[]> plots = new ArrayList<>();
	ArrayList<String> units = new ArrayList<>();
	ArrayList<String> productionFactors = new ArrayList<>();

	@Override
	public void run() throws Exception {
		Scanner reader = new Scanner(System.in);
		byte option = 0;

		while(option != 2) {
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
					this.loadLegacyData();
					break;
				case 2:
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
			"Load legacy data"
		};

		BaseController.super.showMenu(menu);
	}

	private void loadLegacyData() throws Exception {
		/**
		 * Start off by cleaning old files to have new ones
		 */
		FileUtils.cleanDirectory(
			new File("filesOutput/")
		);

		for (int i = 0; i < numberOfSheets; i++) {
			FileReadingSystem fileReadingSystem = new FileReadingSystem("legacy_data_2.xlsx", (short) i);

			ArrayList<ArrayList<String>> data = fileReadingSystem.readData();

			switch (i) {
				case 0 -> insertPlants(data);
				case 1 -> insertProductionFactors(data);
				case 2 -> insertAgriculturalExploration(data);
				case 3 -> insertCrops(data);
				case 4 -> insertOperations(data);
			}
		}
	}

	private void insertPlants(ArrayList<ArrayList<String>> data) throws IOException {
		FileWritingSystem fileWritingSystem = new FileWritingSystem("plants.sql");

		for (ArrayList<String> dataChunk : data) {
			StringBuilder query = new StringBuilder();

			query.append("INSERT INTO plant " +
				"(id, specie, common_name, variety, pruning_date, flowering_date, harvest_date, plantation_date)" +
				" VALUES (");

			query.append(plants.size() + 1).append(", '");
			query.append(dataChunk.get(0)).append("', '");
			query.append(dataChunk.get(1)).append("', '");
			query.append(dataChunk.get(2).replace("'", "''")).append("', ");
			query.append("'").append(valueOrEmpty(dataChunk, 4)).append("', ");
			query.append("'").append(valueOrEmpty(dataChunk, 5)).append("', ");
			query.append("'").append(valueOrEmpty(dataChunk, 6)).append("', '");
			query.append(dataChunk.get(3)).append("');");

			fileWritingSystem.writeLine(query.toString());

			String[] plantCombination = new String[2];

			plantCombination[0] = dataChunk.get(1).trim();
			plantCombination[1] = dataChunk.get(2).trim();

			plants.add(plantCombination);
		}
	}

	private String valueOrEmpty(ArrayList<String> dataChunk, int position) {
		String value;

		try {
			value = dataChunk.get(position);
		} catch (Exception exception) {
			value = "";
		}

		return value;
	}

	private void insertProductionFactors(ArrayList<ArrayList<String>> data) throws IOException {
		FileWritingSystem fileWritingSystem = new FileWritingSystem("production-factors.sql");
		FileWritingSystem datasheetWS = new FileWritingSystem("datasheet-items.sql");

		/**
		 * Different tables relating to the production factor
		 */
		ArrayList<String> applicationModes = new ArrayList<>();
		ArrayList<String> productionFactorTypes = new ArrayList<>();
		ArrayList<String> productionTypeFormats = new ArrayList<>();
		ArrayList<String> manufacturers = new ArrayList<>();
		ArrayList<String> substances = new ArrayList<>();

		int datasheetCounter = 0;

		for (ArrayList<String> dataChunk : data) {
			StringBuilder query = new StringBuilder();

			String manufacturer = dataChunk.get(1);
			String format = dataChunk.get(2);
			String type = dataChunk.get(3);
			String application = dataChunk.get(4);

			String substance;

			if(!manufacturers.contains(manufacturer)) {
				manufacturers.add(manufacturer);

				insertManufacturer(manufacturers.size(), manufacturer);
			}

			if(!productionTypeFormats.contains(format)) {
				productionTypeFormats.add(format);

				insertProductionTypeFormat(productionTypeFormats.size(), format);
			}

			if(!productionFactorTypes.contains(type)) {
				productionFactorTypes.add(type);

				insertProductionFactorType(productionFactorTypes.size(), type);
			}

			if(!applicationModes.contains(application)) {
				applicationModes.add(application);

				insertApplicationModes(applicationModes.size(), application);
			}

			for (int i = 5; i < data.size(); i += 2) {
				substance = valueOrEmpty(dataChunk, i);

				if(!substance.equals("") && !substances.contains(substance)) {
					substances.add(substance);

					insertSubstance(substances.size(), substance);
				}
			}

			query.append("INSERT INTO production_factor(id, commercial_name, application_modeid, formatid, manufacturerid, production_factor_typeid) VALUES(");

			query.append(productionFactors.size() + 1).append(", '");
			query.append(dataChunk.get(0)).append("', ");
			query.append((applicationModes.indexOf(application) + 1)).append(", ");
			query.append((productionTypeFormats.indexOf(format) + 1)).append(", ");
			query.append((manufacturers.indexOf(manufacturer) + 1)).append(", ");
			query.append((productionFactorTypes.indexOf(type) + 1)).append("); ");

			productionFactors.add(dataChunk.get(0));

			fileWritingSystem.writeLine(query.toString());

			for (int i = 5; i < data.size(); i += 2) {
				substance = valueOrEmpty(dataChunk, i);

				if(!substance.equals("")) {
					datasheetCounter++;

					String datasheetQuery = "INSERT INTO datasheet_item(datasheet_itemid, substanceid, amount, production_factorid) VALUES("
						+ datasheetCounter + ", "
						+ (substances.indexOf(substance) + 1) + ", "
						+ Float.parseFloat(dataChunk.get(i + 1)) + ", "
						+ productionFactors.size() + ");";

					datasheetWS.writeLine(datasheetQuery);
				}
			}
		}
	}

	private void insertManufacturer(int id, String name) throws IOException {
		FileWritingSystem manufacturerWS = new FileWritingSystem("manufacturers.sql");

		String query = "INSERT INTO manufacturer(id, manufacturer) VALUES (" + id + ", '" + name + "');";
		manufacturerWS.writeLine(query);
	}

	private void insertProductionTypeFormat(int id, String format) throws IOException {
		FileWritingSystem productionTypeFormatWS = new FileWritingSystem("production-type-formats.sql");

		String query = "INSERT INTO format(id, format) VALUES (" + id + ", '" + format + "');";
		productionTypeFormatWS.writeLine(query);
	}

	private void insertProductionFactorType(int id, String type) throws IOException {
		FileWritingSystem productionFactorType = new FileWritingSystem("production-factor-types.sql");

		String query = "INSERT INTO production_factor_type(id, type) VALUES (" + id + ", '" + type + "');";
		productionFactorType.writeLine(query);
	}

	private void insertApplicationModes(int id, String applicationMode) throws IOException {
		FileWritingSystem applicationModes = new FileWritingSystem("application-modes.sql");

		String query = "INSERT INTO application_mode(id, application_mode) VALUES (" + id + ", '" + applicationMode + "');";
		applicationModes.writeLine(query);
	}

	private void insertSubstance(int id, String substance) throws IOException {
		FileWritingSystem substancesWS = new FileWritingSystem("substances.sql");

		String query = "INSERT INTO substance(id, chemical_formula) VALUES (" + id + ", '" + substance + "');";
		substancesWS.writeLine(query);
	}

	private void insertAgriculturalExploration(ArrayList<ArrayList<String>> data) throws IOException {
		FileWritingSystem fileWritingSystem = new FileWritingSystem("agricultural-plots.sql");
		String query;

		String type;
		String unit;
		String id;
		String area;

		float realArea;

		ArrayList<String> buildingTypes = new ArrayList<>(
			Arrays.asList(
				"Armazém",
				"Garagem",
				"Moinho",
				"Rega"
			)
		);

		for(String buildingType : buildingTypes)
			insertBuildingTypes(
				(buildingTypes.indexOf(buildingType) + 1),
				buildingType
			);

		for(ArrayList<String> dataChunk : data) {
			type = dataChunk.get(1);
			unit = valueOrEmpty(dataChunk, 4);

			id = dataChunk.get(0).substring(0, 3);
			area = valueOrEmpty(dataChunk, 3);

			realArea = area.equals("") ? 0 : Float.parseFloat(area);

			if(!units.contains(unit) && !unit.equals("")) {
				units.add(unit);

				insertMeasureUnits(units.size(), unit);
			}

			if(buildingTypes.contains(type)) {
				insertBuilding(
					Integer.parseInt(id),
					dataChunk.get(2),
					units.indexOf(unit) + 1,
					buildingTypes.indexOf(type) + 1,
					realArea
				);
				continue;
			}

			String[] plotCombination = new String[2];

			plotCombination[0] = id;
			plotCombination[1] = dataChunk.get(2).trim();

			plots.add(plotCombination);

			query = "INSERT INTO agricultural_plot(id, name, watering_systemid, area, unitid) VALUES("
				+ Integer.parseInt(id) + ", '"
				+ dataChunk.get(2) + "', "
				+ "NULL, "
				+ realArea + ", "
				+ units.indexOf(unit) + 1 + ");";

			fileWritingSystem.writeLine(query);
		}
	}

	private void insertBuildingTypes(int id, String type) throws IOException {
		FileWritingSystem buildingTypesWS = new FileWritingSystem("building-types.sql");

		buildingTypesWS.writeLine("INSERT INTO building_type(id, type) VALUES (" + id + ", '" + type + "');");
	}

	private void insertMeasureUnits(int id, String unit) throws IOException {
		FileWritingSystem fileWritingSystem = new FileWritingSystem("units.sql");

		String query = "INSERT INTO unit (id, unit) VALUES (" + id + ", '" + unit + "');";
		fileWritingSystem.writeLine(query);
	}

	private void insertBuilding(int id, String name, int unitId, int buildingTypeId, float dimension) throws IOException {
		FileWritingSystem buildingsWS = new FileWritingSystem("buildings.sql");
		String realId = unitId != 0 ? String.valueOf(unitId) : "NULL";

		String query = "INSERT INTO building(id, name, unitid, building_typeid, dimension) VALUES(" +
			id + ", '" +
			name + "', " +
			realId + ", " +
			buildingTypeId + ", " +
			dimension + ");";

		buildingsWS.writeLine(query);
	}

	private void insertCrops(ArrayList<ArrayList<String>> data) throws Exception {
		FileWritingSystem fileWritingSystem = new FileWritingSystem("crops.sql");
		FileWritingSystem cropDatesWS = new FileWritingSystem("crop-dates.sql");

		ArrayList<String> cropTypes = new ArrayList<>();
		String query;

		String type;
		String finalDate;

		String[] plant;

		int cropId = 0;

		for (ArrayList<String> dataChunk : data) {
			cropId++;

			type = dataChunk.get(3);
			finalDate = valueOrEmpty(dataChunk, 5);

			plant = dataChunk.get(2).split(" ");
			int plantId = findPlantCombinationIndex(plant) + 1;

			if(!cropTypes.contains(type)) {
				cropTypes.add(type);

				insertCropType(cropTypes.size(), type);
			}

			String formattedBeginDate = String.format("TO_DATE('%s', 'DD/MON/YYYY')", this.convertNumberToDate(dataChunk.get(4)));

			String convertedDate = this.convertNumberToDate(finalDate);
			String formattedFinalDate = String.format("TO_DATE('%s', 'DD/MON/YYYY')", convertedDate);

			if(convertedDate.contains("/1900") || convertedDate.contains("/1901")) {
				formattedFinalDate = "NULL";
			}

			query = "INSERT INTO crop(id, name, crop_typeid, plantid) VALUES ("
				+ cropId + ", '"
				+ dataChunk.get(2) + "', "
				+ (cropTypes.indexOf(type) + 1) + ", "
				+ plantId + ");";
			fileWritingSystem.writeLine(query);

			query = "INSERT INTO crop_dates(id, begin_date, finish_date, cropid) VALUES("
				+ cropId + ", "
				+ formattedBeginDate + ", "
				+ formattedFinalDate + ", "
				+ cropId + ");";
			cropDatesWS.writeLine(query);

			String[] cropCombination = new String[2];

			cropCombination[0] = dataChunk.get(2);
			cropCombination[1] = this.convertNumberToDate(dataChunk.get(4));

			crops.add(cropCombination);
		}

		this.insertCropAgriculturalPlot(data);
	}

	/**
	 * Given a plant combination (the array with the different parts
	 * of the plant) we're going to find its index in the plants
	 * ArrayList. The plant id corresponds to the index + 1
	 *
	 * @param plantCombination
	 * @return int
	 */
	private int findPlantCombinationIndex(String[] plantCombination) {
		String variety = "";
		int index = 0;

		for (int i = 1; i < plantCombination.length; i++)
			variety += plantCombination[i] + " ";

		variety = variety.trim();

		for(String[] plant : plants) {
			if(plant[0].equalsIgnoreCase(plantCombination[0]) && plant[1].equalsIgnoreCase(variety))
				return index;

			index++;
		}

		return -1;
	}

	private void insertCropType(int id, String type) throws IOException {
		FileWritingSystem cropTypeWS = new FileWritingSystem("crop-types.sql");

		String query = "INSERT INTO crop_type(id, type) VALUES (" + id + ", '" + type + "');";
		cropTypeWS.writeLine(query);
	}

	/**
	 * This function takes in a number and formats it into
	 * a date format that we know and love
	 *
	 * @param number
	 * @return String
	 * @throws Exception
	 */
	private String convertNumberToDate(String number) throws Exception {
		float numberDate = Float.parseFloat(number);

		SimpleDateFormat dateFormatter = new SimpleDateFormat("dd/MMM/yyyy");
		Date date = dateFormatter.parse("01/Jan/1900");

		date.setTime((long) (date.getTime() + (numberDate - 2) * 24L * 60 * 60 * 1000));

		return dateFormatter.format(date);
	}

	private void insertCropAgriculturalPlot(ArrayList<ArrayList<String>> data) throws Exception {
		FileWritingSystem fileWritingSystem = new FileWritingSystem("crop-agricultural-plot.sql");

		int cropId;
		String cropName;
		String beginningDate;

		String plotName;
		int plotId;

		for(ArrayList<String> dataChunk : data) {
			plotName = dataChunk.get(1);
			plotId = Integer.parseInt(this.findPlotId(plotName));

			cropName = dataChunk.get(2);
			beginningDate = this.convertNumberToDate(dataChunk.get(4));
			cropId = this.indexOfCrop(cropName, beginningDate) + 1;

			String query = "INSERT INTO crop_agricultural_plot(cropid, agricultural_plotid) VALUES("
				+ cropId + ", "
				+ plotId + ");";
			fileWritingSystem.writeLine(query);
		}
	}

	/**
	 * This function receives the name of the plot
	 * and finds the id of the plot with that
	 * name ("" for when the plot
	 * isn't found)
	 *
	 * @param name
	 * @return String
	 */
	private String findPlotId(String name) {
		for(String[] plot : plots)
			if(plot[1].equalsIgnoreCase(name))
				return plot[0];

		return "";
	}

	private int indexOfCrop(String name, String beginningDate) {
		int index = 0;

		for(String[] crop : crops) {
			if(crop[0].equalsIgnoreCase(name) && crop[1].equalsIgnoreCase(beginningDate))
				return index;

			index++;
		}

		return -1;
	}

	private void insertOperations(ArrayList<ArrayList<String>> data) throws Exception {
		FileWritingSystem fileWritingSystem = new FileWritingSystem("operations.sql");

		ArrayList<String> operationTypes = new ArrayList<>();

		String operationType;
		String unit;
		String productionFactor;
		String quantityString;
		String plot;

		int unitId;
		int operationTypeId;
		int cropId;

		int index = 0;

		int quantityIndex = 0;
		int unitIndex = 0;
		int productionFactorIndex = 0;
		int dateIndex = 0;
		int cropIndex = 3;

		for (ArrayList<String> dataChunk : data) {
			/**
			 * It's 1:30 am, in a Thursday night.
			 * Please, don't look at this sh*tty code. Thank you.
			 */
			switch (dataChunk.size()) {
				case 9 -> {
					unitIndex = 7;
					productionFactorIndex = 8;
					quantityIndex = 6;
					dateIndex = 5;
					cropIndex = 4;
				}
				case 7 -> {
					unitIndex = 6;
					productionFactorIndex = 8;
					quantityIndex = 5;
					dateIndex = 4;
					cropIndex = 3;
				}
				case 6 -> {
					unitIndex = -1;
					productionFactorIndex = -1;
					quantityIndex = 5;
					dateIndex = 4;
				}
				case 5 -> {
					unitIndex = -1;
					productionFactorIndex = -1;
					quantityIndex = -1;
					dateIndex = 4;
				}
				default -> {
				}
			}

			index++;

			unit = valueOrEmpty(dataChunk, unitIndex);
			operationType = dataChunk.get(2);
			productionFactor = valueOrEmpty(dataChunk, productionFactorIndex);

			if(unit.equals("")) {
				unitId = 0;
			} else {
				if(!units.contains(unit)) {
					units.add(unit);

					insertMeasureUnits(units.size(), unit);
				}

				unitId = units.indexOf(unit) + 1;
			}

			if(!operationTypes.contains(operationType)) {
				operationTypes.add(operationType);

				this.insertOperationType(operationTypes.size(), operationType);
			}

			operationTypeId = operationTypes.indexOf(operationType) + 1;
			quantityString = valueOrEmpty(dataChunk, quantityIndex);

			plot = this.findPlotId(dataChunk.get(1));
			cropId = this.findCropByName(dataChunk.get(cropIndex));

			String operationDate = String.format("TO_DATE('%s', 'DD/Mon/YYYY')", convertNumberToDate(dataChunk.get(dateIndex)));

			String query = "INSERT INTO operation(id, operation_date, amount, unitid, operation_typeid, crop_agricultural_plotcropid, crop_agricultural_plotagricultural_plotid, production_factorid) VALUES ("
				+ index + ", "
				+ operationDate + ", "
				+ (quantityString.equals("") ? "NULL" : Float.parseFloat(quantityString)) + ", "
				+ (unitId == 0 ? "NULL" : unitId) + ", "
				+ operationTypeId + ", "
				+ cropId + ", "
				+ plot + ", "
				+ (productionFactor.equals("")
				? "NULL"
				: (productionFactors.indexOf(productionFactor) + 1)
			) + ");";
			fileWritingSystem.writeLine(query);
		}
	}

	private void insertOperationType(int id, String type) throws IOException {
		FileWritingSystem operationTypesWS = new FileWritingSystem("operation-types.sql");

		String query = "INSERT INTO operation_type(id, type) VALUES (" + id + ", '" + type + "');";
		operationTypesWS.writeLine(query);
	}

	private int findCropByName(String name) {
		int id = 0;

		for (String[] crop : crops) {
			id++;

			if(crop[0].contains(name))
				return id;
		}

		return -1;
	}
}
