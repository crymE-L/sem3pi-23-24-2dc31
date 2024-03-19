package controllers;

import com.sun.tools.javac.Main;
import interfaces.BaseController;
import oracle.jdbc.OracleType;
import oracle.jdbc.OracleTypes;
import utils.DatabaseConnection;

import java.io.IOException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Objects;
import java.util.Scanner;

public class RegisterOperationController implements BaseController {
	@Override
	public void run() throws IOException {
		Scanner reader = new Scanner(System.in);
		byte option = 0;

		while(option != 5) {
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
					this.registerSeeding();
					break;
				case 2:
					this.registerWeed();
					break;
				case 3:
					this.registerHarvest();
					break;
				case 4:
					this.registerApplicationOfProductionFactor();
					break;
				case 5:
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
			"Register seeding operation",
			"Register weed operation",
			"Register harvest operation",
			"Register application of production factor operation"
		};

		BaseController.super.showMenu(menu);
	}

	private void registerSeeding() {
		float amount = this.readValidFloat("Please introduce an amount >> ");
		float area = this.readValidFloat("Please introduce an area >> ");

		String unit = this.readValidString("Please introduce the quantity unit name >> ");
		String crop = this.readValidString("Please introduce the crop name >> ");
		String agriculturalPlot = this.readValidString("Please introduce the agricultural plot name >> ");
		String areaUnitName = this.readValidString("Please introduce the area unit name (i.e: m3) >> ");

		ArrayList<Short> operationDate = this.readDate();
		String operationDateString = String.format("%02d/%s/%02d", operationDate.get(0), this.getMonthByNumber(operationDate.get(1)), operationDate.get(2));

		CallableStatement callableStatement = null;
		ResultSet resultSet = null;

		try {
			Connection connection = DatabaseConnection.getInstance().getConnection();
			callableStatement = connection.prepareCall("{ ? = call registerOperationSeeding(?, ?, ?, ?, ?, ?, ?) }");

			callableStatement.setString(2, operationDateString);
			callableStatement.setFloat(3, amount);
			callableStatement.setString(4, unit);
			callableStatement.setString(5, crop);
			callableStatement.setString(6, agriculturalPlot);
			callableStatement.setFloat(7, area);
			callableStatement.setString(8, areaUnitName);

			callableStatement.registerOutParameter(1, OracleTypes.VARCHAR);

			callableStatement.execute();
			connection.commit();

			String message = callableStatement.getString(1);
			System.out.println(message);
		} catch (Exception exception) {
			System.out.println("Something went wrong: " + exception.getMessage());
		} finally {
			if(!Objects.isNull(callableStatement))
				try {
					callableStatement.close();
				} catch (Exception exception) {
					System.out.println("Something went wrong: " + exception.getMessage());
				}
		}
	}

	/**
	 * With this function we're going to get the
	 * date from a String with the format
	 * 17/10/2023
	 *
	 * @return ArrayList<Byte>
	 */
	private ArrayList<Short> readDate() {
		ArrayList<Short> byteDate = new ArrayList<>();

		String dateString;
		String[] dateArray;

		short dateArrayLength;
		int dateChunk;

		boolean correctFormatDate;

		Scanner reader = new Scanner(System.in);

		/**
		 * We're going to be looping through this section to
		 * make sure that the date that we read is in the
		 * correct format (3 chunks)
		 */
		do {
			/**
			 * We can't ensure that the previous date was
			 * inputted correctly
			 */
			correctFormatDate = true;

			System.out.print("Please input the operation date (i.e: 19/10/2023): ");
			dateString = reader.nextLine();

			dateArray = dateString.split("/");
			dateArrayLength = (byte) dateArray.length;

			if(dateArrayLength < 3) {
				System.out.println("The date format inputted is wrong.");
				reader.next();
			}

			for (int i = 0; i < dateArrayLength; i++) {
				try {
					Integer.parseInt(dateArray[i]);
				} catch (Exception exception) {
					System.out.println("Please input a valid date format (use only numbers).");
					correctFormatDate = false;
				}
			}
		} while((dateArrayLength < 3) && correctFormatDate);

		/**
		 * After preparing all the data (as it comes in a String format)
		 * we have to convert it to an integer and then to a byte
		 */
		for (int i = 0; i < dateArrayLength; i++) {
			dateChunk = Integer.parseInt(dateArray[i]);
			byteDate.add((short) dateChunk);
		}

		return byteDate;
	}

	/**
	 * Since we have to read a lot of numbers throughout our
	 * program, this function takes care of reading and
	 * validating the number for us.
	 *
	 * What a cutie. ☺️
	 *
	 * @param message
	 * @return
	 */
	private int readValidInteger(String message) {
		Scanner reader = new Scanner(System.in);

		int value = 0;
		boolean validReading = false;

		do {
			System.out.print(message);

			try {
				value = reader.nextInt();

				if(value > 0)
					validReading = true;
			} catch (Exception exception) {
				validReading = false;
			}

			if(!validReading)
				System.out.println("Please introduce a valid number (greater than 0).");
		} while(!validReading);

		return value;
	}

	private float readValidFloat(String message) {
		Scanner reader = new Scanner(System.in);

		float value = 0;
		boolean validReading = false;

		do {
			System.out.print(message);

			try {
				value = reader.nextFloat();

				if(value > 0)
					validReading = true;
			} catch (Exception exception) {
				validReading = false;
			}

			if(!validReading)
				System.out.println("Please introduce a valid number (greater than 0).");
		} while(!validReading);

		return value;
	}

	/**
	 * Did you read the comment of readValidInteger()?
	 * This is the same thing, but for strings
	 *
	 * @param message
	 * @return
	 */
	private String readValidString(String message) {
		Scanner reader = new Scanner(System.in);

		String value = "";
		boolean validReading = false;

		do {
			validReading = false;

			System.out.print(message);
			value = reader.nextLine();

			if(!value.trim().isEmpty())
				validReading = true;

			if(!validReading)
				System.out.println("The introduced value is not valid.");
		} while(!validReading);

		return value;
	}

	private String getMonthByNumber(short month) {
		switch (month) {
			case 1:
				return "Jan";
			case 2:
				return "Feb";
			case 3:
				return "Mar";
			case 4:
				return "Apr";
			case 5:
				return "May";
			case 6:
				return "Jun";
			case 7:
				return "Jul";
			case 8:
				return "Aug";
			case 9:
				return "Sep";
			case 10:
				return "Oct";
			case 11:
				return "Nov";
			case 12:
				return "Dec";
		}

		return "";
	}

	private void registerWeed() {
		float amount = this.readValidFloat("Please introduce an amount >> ");

		String unit = this.readValidString("Please introduce the unit name >> ");
		String crop = this.readValidString("Please introduce the crop name >> ");
		String agriculturalPlot = this.readValidString("Please introduce the agricultural plot name >> ");

		ArrayList<Short> operationDate = this.readDate();
		String operationDateString = String.format("%02d/%s/%02d", operationDate.get(0), this.getMonthByNumber(operationDate.get(1)), operationDate.get(2));

		CallableStatement callableStatement = null;
		ResultSet resultSet = null;

		try {
			Connection connection = DatabaseConnection.getInstance().getConnection();
			callableStatement = connection.prepareCall("{ ? = call registerOperationWeed(?, ?, ?, ?, ?) }");

			callableStatement.setString(2, operationDateString);
			callableStatement.setFloat(3, amount);
			callableStatement.setString(4, unit);
			callableStatement.setString(5, crop);
			callableStatement.setString(6, agriculturalPlot);

			callableStatement.registerOutParameter(1, OracleTypes.VARCHAR);

			callableStatement.execute();
			connection.commit();

			String message = callableStatement.getString(1);
			System.out.println(message);
		} catch (Exception exception) {
			System.out.println("Something went wrong: " + exception.getMessage());
		} finally {
			if(!Objects.isNull(callableStatement))
				try {
					callableStatement.close();
				} catch (Exception exception) {
					System.out.println("Something went wrong: " + exception.getMessage());
				}
		}
	}

	private void registerHarvest() {
		float amount = this.readValidFloat("Please introduce an amount >> ");

		String unit = this.readValidString("Please introduce the unit name >> ");
		String crop = this.readValidString("Please introduce the crop name >> ");
		String agriculturalPlot = this.readValidString("Please introduce the agricultural plot name >> ");

		ArrayList<Short> operationDate = this.readDate();
		String operationDateString = String.format("%02d/%s/%02d", operationDate.get(0), this.getMonthByNumber(operationDate.get(1)), operationDate.get(2));

		CallableStatement callableStatement = null;
		ResultSet resultSet = null;

		try {
			Connection connection = DatabaseConnection.getInstance().getConnection();
			callableStatement = connection.prepareCall("{ ? = call registerHarvestOperation(?, ?, ?, ?, ?) }");

			callableStatement.setString(2, operationDateString);
			callableStatement.setFloat(3, amount);
			callableStatement.setString(4, unit);
			callableStatement.setString(5, crop);
			callableStatement.setString(6, agriculturalPlot);

			callableStatement.registerOutParameter(1, OracleTypes.VARCHAR);

			callableStatement.execute();
			connection.commit();

			String message = callableStatement.getString(1);
			System.out.println(message);
		} catch (Exception exception) {
			System.out.println("Something went wrong: " + exception.getMessage());
		} finally {
			if(!Objects.isNull(callableStatement))
				try {
					callableStatement.close();
				} catch (Exception exception) {
					System.out.println("Something went wrong: " + exception.getMessage());
				}
		}
	}

	private void registerApplicationOfProductionFactor() {
		float area = this.readValidFloat("Please introduce an area to apply the production factor >> ");
		float amount = this.readValidFloat("Please introduce an amount to apply >> ");

		String unit = this.readValidString("Please introduce the amount unit name >> ");
		String areaUnit = this.readValidString("Please introduce the area unit name >> ");
		String agriculturalPlot = this.readValidString("Please introduce the agricultural plot name >> ");
		String operationTypeName = this.readValidString("Please introduce the operation type name >> ");

		String productionFactorName = this.readValidString("Please introduce the production factor name >> ");
		String productionFactorApplicationMode = this.readValidString("Please introduce the production factor application mode >> ");

		ArrayList<Short> operationDate = this.readDate();
		String operationDateString = String.format("%02d/%s/%02d", operationDate.get(0), this.getMonthByNumber(operationDate.get(1)), operationDate.get(2));

		CallableStatement callableStatement = null;
		ResultSet resultSet = null;

		try {
			Connection connection = DatabaseConnection.getInstance().getConnection();
			callableStatement = connection.prepareCall("{ ? = call fncAddOperationApplyProductionFactor(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) }");

			callableStatement.setString(2, operationTypeName);
			callableStatement.setString(3, agriculturalPlot);
			callableStatement.setNull(4, OracleTypes.NULL);
			callableStatement.setString(5, operationDateString);
			callableStatement.setString(6, productionFactorName);
			callableStatement.setString(7, productionFactorApplicationMode);
			callableStatement.setFloat(8, area);
			callableStatement.setString(9, areaUnit);
			callableStatement.setFloat(10, amount);
			callableStatement.setString(11, unit);
			callableStatement.setNull(12, OracleTypes.NULL);

			callableStatement.registerOutParameter(1, OracleTypes.VARCHAR);

			callableStatement.execute();
			connection.commit();

			String message = callableStatement.getString(1);
			System.out.println(message);
		} catch (Exception exception) {
			System.out.println("Something went wrong: " + exception.getMessage());
		} finally {
			if(!Objects.isNull(callableStatement))
				try {
					callableStatement.close();
				} catch (Exception exception) {
					System.out.println("Something went wrong: " + exception.getMessage());
				}
		}
	}
}
