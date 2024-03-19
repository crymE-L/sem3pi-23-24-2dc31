package controllers;

import com.sun.tools.javac.Main;
import interfaces.BaseController;
import models.priority_queue.Entry;
import oracle.jdbc.OracleTypes;
import org.apache.commons.io.FileUtils;
import utils.DatabaseConnection;
import utils.FileReadingSystem;
import utils.FileWritingSystem;

import java.io.File;
import java.io.IOException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.*;

public class IrrigationController implements BaseController {
	@Override
	public void run() {
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
					this.checkIrrigation();
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
			"Check irrigation"
		};

		BaseController.super.showMenu(menu);
	}

	private void checkIrrigation() {
		String filename = "irrigation_data.txt";

		ArrayList<ArrayList<String>> data = new ArrayList<>();
		String absolutePath = new File("").getAbsolutePath() + "/filesOutput/";

		if(new File(absolutePath + "irrigation_system.csv").exists())
			try {
				FileUtils.delete(
					new File(absolutePath + "irrigation_system.csv")
				);
			} catch (Exception exception) {
				System.out.println(exception.getMessage());
			}

		FileReadingSystem fileReadingSystem = new FileReadingSystem(filename);
		FileWritingSystem fileWritingSystem = null;

		try {
			fileWritingSystem = new FileWritingSystem("irrigation_system.csv");
		} catch (Exception exception) {
			System.out.println(exception.getMessage());
		}

		try {
			data = fileReadingSystem.readData();
		} catch (Exception exception) {
			System.out.println(exception.getMessage());
		}

		ArrayList<Short> planCreationDate = this.readDate();

		LocalDate today = LocalDate.now();
		LocalTime now = LocalTime.now();

		ArrayList<String> irrigationTimes = data.get(0);
		ArrayList<ArrayList<Byte>> timesToNumbers = this.parseTimes(irrigationTimes);

		int daysDifference = today.getDayOfMonth() - planCreationDate.get(0);
		int monthDifference = today.getMonthValue() - planCreationDate.get(1);

		ArrayList<String> parcel;
		String parcelName;

		if(daysDifference > 0 && monthDifference > 0 && planCreationDate.get(2) > today.getDayOfYear()){
			System.out.println("This irrigation plan is expired (has more than 30 days).");
			return;
		}

		try {
			/**
			 * Create the file header
			 */
			fileWritingSystem.writeLine("Day;Sector;Duration;Beginning;End;Has mix");
		} catch (Exception exception) {
			System.out.println(exception.getMessage());
		}

		byte irrigationDuration;
		String currentDayString;

		int currentDay = today.getDayOfMonth();
		int currentMonth = today.getMonthValue();

		byte timeToFinishIrrigating;

		/**
		 * Since we can only have one irrigation system at
		 * the time let's create this little condition
		 */
		boolean alreadyIrrigating = false;

		boolean irrigationRegisteredInDatabase;
		boolean hasMix;
		boolean mixApplicationDay;
		boolean firstMixedIrrigation = false;

		/**
		 * The variables to keep track of the month changes
		 */
		short day = planCreationDate.get(0);
		short month = planCreationDate.get(1);
		short year = planCreationDate.get(2);

		/**
		 * This map will store all the information about the mix (and where) we're applying,
		 * when it was last applied and when we're going to apply next.
		 *
		 * The last applied acts as a counter, and when both match, we increment
		 * the next application by the number of days to skip, also present
		 * in the map.
		 */
		Map<ArrayList<String>, ArrayList<Short>> mixApplicationsMap = new HashMap<>();

		/**
		 * No matter the month, we want to create the plan for
		 * 30 days after the plan creation
		 */
		for (int k = 0; k < 30; k++) {
			if(hasToSkipMonth(day, month, year))
				month++;

			day = this.removeDays(day, month, planCreationDate);

			if(month > 12) {
				year++;
				month = 1;
			}

			currentDayString = String.format("%02d/%02d/%d", day, month, year);

			for(int i = 0; i < timesToNumbers.size(); i++) {
				/**
				 * The last irrigation time, in the first iteration, is going to be
				 * equals to the beginning of the first irrigation, because we're
				 * going to start irrigating at that time and, then, add the
				 * irrigation time to it (to check the end of irrigation).
				 */
				ArrayList<Byte> lastIrrigationTime = new ArrayList<>();
				lastIrrigationTime.add(timesToNumbers.get(i).get(0));
				lastIrrigationTime.add(timesToNumbers.get(i).get(1));

				irrigationRegisteredInDatabase = false;

				for (int j = 1; j < data.size(); j++) {
					parcel = data.get(j);
					irrigationDuration = (byte) Integer.parseInt(parcel.get(1));

					boolean irrigationCondition = this.checkIfInTime(timesToNumbers, now) && !alreadyIrrigating;

					parcelName = parcel.get(0);
					hasMix = parcel.size() > 3;

					/**
					 * If the parcel is not registered in the map,
					 * then we should add it. Right?
					 */
					if(hasMix && !this.parcelMixExists(mixApplicationsMap, parcelName, parcel.get(3))) {
						boolean isEvenDay = (day % 2) == 0;
						short applicationInterval = Short.parseShort(parcel.get(4));
						short nextApplication = (short) (day + applicationInterval);

						switch (parcel.get(2)) {
							case "T" -> {
								mixApplicationsMap.put(
									new ArrayList<>(
										Arrays.asList(parcelName, parcel.get(3))
									), new ArrayList<>(
										Arrays.asList(day, nextApplication, applicationInterval)
									)
								);
							}
							case "P" -> {
								if(isEvenDay)
									mixApplicationsMap.put(
										new ArrayList<>(
											Arrays.asList(parcelName, parcel.get(3))
										), new ArrayList<>(
											Arrays.asList(day, nextApplication, applicationInterval)
										)
									);
							}
							case "I" -> {
								if(!isEvenDay)
									mixApplicationsMap.put(
										new ArrayList<>(
											Arrays.asList(parcelName, parcel.get(3))
										), new ArrayList<>(
											Arrays.asList(day, nextApplication, applicationInterval)
										)
									);
							}
							case "3" -> {
								short currentCheckDay = day;

								do {
									/**
									 * If it's the day we reached is the current day, then we're
									 * going to verify if we're in time for irrigation or not
									 */
									if (day == currentCheckDay)
										mixApplicationsMap.put(
											new ArrayList<>(
												Arrays.asList(parcelName, parcel.get(3))
											), new ArrayList<>(
												Arrays.asList(day, nextApplication, applicationInterval)
											)
										);

									currentCheckDay = removeDays(currentCheckDay, (short) currentMonth, planCreationDate);
									currentCheckDay += 3;
								} while (currentCheckDay <= day);
							}
							default -> {}
						}

						firstMixedIrrigation = true;
					} else if(hasMix && this.parcelMixExists(mixApplicationsMap, parcelName, parcel.get(3))) {
						for (Map.Entry<ArrayList<String>, ArrayList<Short>> entry : mixApplicationsMap.entrySet())
							if(entry.getKey().get(0).equals(parcelName) && entry.getKey().get(1).equals(parcel.get(3))) {
								entry.getValue().set(
									0,
									(short) (entry.getValue().get(0) + 1)
								);
							}
					}

					mixApplicationDay = (hasMix && this.isMixApplicationDay(mixApplicationsMap, parcelName, parcel.get(3))) || firstMixedIrrigation;

					switch (parcel.get(2)) {
						case "T" -> {
							if(irrigationCondition) {
								timeToFinishIrrigating = this.timeToFinishIrrigate(timesToNumbers, now, parcel);
								alreadyIrrigating = true;

								System.out.printf("The parcel %s is irrigating and finishes in %d minutes.\n", parcelName, timeToFinishIrrigating);
							}

							try {
								lastIrrigationTime = writeDataToFile(
									currentDayString,
									parcel,
									irrigationDuration,
									lastIrrigationTime,
									fileWritingSystem,
									mixApplicationDay ? parcel.get(3) : "No"
								);
								registerIrrigationInFile(
									currentDayString,
									parcel,
									irrigationDuration,
									lastIrrigationTime,
									mixApplicationDay ? parcel.get(3) : "No"
								);
							} catch (Exception exception) {
								System.out.println(exception.getMessage());
							}
						}
						case "P" -> {
							if ((day % 2) == 0) {
								if(irrigationCondition) {
									timeToFinishIrrigating = this.timeToFinishIrrigate(timesToNumbers, now, parcel);
									alreadyIrrigating = true;

									System.out.printf("The parcel %s is irrigating and finished in %d minutes.\n", parcelName, timeToFinishIrrigating);
								}

								try {
									lastIrrigationTime = writeDataToFile(
										currentDayString,
										parcel,
										irrigationDuration,
										lastIrrigationTime,
										fileWritingSystem,
										mixApplicationDay ? parcel.get(3) : "No"
									);
									registerIrrigationInFile(
										currentDayString,
										parcel,
										irrigationDuration,
										lastIrrigationTime,
										mixApplicationDay ? parcel.get(3) : "No"
									);

									irrigationRegisteredInDatabase = registerIrrigationInDatabase(
										currentDayString,
										parcel,
										irrigationDuration,
										lastIrrigationTime,
										hasMix ? parcel.get(3) : null
									);

									if(!irrigationRegisteredInDatabase)
										System.out.printf("Couldn't register irrigation of parcel %s on the database.\n", parcel.get(0));
								} catch (Exception exception) {
									System.out.println(exception.getMessage());
								}
							}
						}
						case "I" -> {
							if ((day % 2) != 0) {
								if(irrigationCondition) {
									timeToFinishIrrigating = this.timeToFinishIrrigate(timesToNumbers, now, parcel);
									alreadyIrrigating = true;

									System.out.printf("The parcel %s is irrigating and finished in %d minutes.\n", parcelName, timeToFinishIrrigating);
								}

								try {
									lastIrrigationTime = writeDataToFile(
										currentDayString,
										parcel,
										irrigationDuration,
										lastIrrigationTime,
										fileWritingSystem,
										mixApplicationDay ? parcel.get(3) : "No"
									);
									registerIrrigationInFile(
										currentDayString,
										parcel,
										irrigationDuration,
										lastIrrigationTime,
										mixApplicationDay ? parcel.get(3) : "No"
									);

								irrigationRegisteredInDatabase = registerIrrigationInDatabase(
									currentDayString,
									parcel,
									irrigationDuration,
									lastIrrigationTime,
									hasMix ? parcel.get(3) : null
								);

								if(!irrigationRegisteredInDatabase)
									System.out.printf("Couldn't register irrigation of parcel %s on the database.\n", parcel.get(0));
								} catch (Exception exception) {
									System.out.println(exception.getMessage());
								}
							}
						}
						case "3" -> {
							short currentCheckDay = planCreationDate.get(0);

							do {
								/**
								 * If it's the day we reached is the current day, then we're
								 * going to verify if we're in time for irrigation or not
								 */
								if (day == currentCheckDay) {
									if (irrigationCondition) {
										timeToFinishIrrigating = this.timeToFinishIrrigate(timesToNumbers, now, parcel);
										alreadyIrrigating = true;

										System.out.printf("The parcel %s is irrigating and finished in %d minutes.\n", parcelName, timeToFinishIrrigating);
									}

									try {
										lastIrrigationTime = writeDataToFile(
											currentDayString,
											parcel,
											irrigationDuration,
											lastIrrigationTime,
											fileWritingSystem,
											mixApplicationDay ? parcel.get(4) : "No"
										);
										registerIrrigationInFile(
											currentDayString,
											parcel,
											irrigationDuration,
											lastIrrigationTime,
											mixApplicationDay ? parcel.get(3) : "No"
										);

										irrigationRegisteredInDatabase = registerIrrigationInDatabase(
											currentDayString,
											parcel,
											irrigationDuration,
											lastIrrigationTime,
											hasMix ? parcel.get(3) : null
										);

										if(!irrigationRegisteredInDatabase)
											System.out.printf("Couldn't register irrigation of parcel %s on the database.\n", parcelName);
									} catch (Exception exception) {
										System.out.println(exception.getMessage());
									}
								}

								currentCheckDay = removeDays(currentCheckDay, (short) currentMonth, planCreationDate);
								currentCheckDay += 3;
							} while (currentCheckDay <= day);
						}
						default -> {
						}
					}

					firstMixedIrrigation = false;
				}
			}

			day++;
		}

		if(!alreadyIrrigating) {
			System.out.println("No parcels irrigating at the time.");
		}
	}

	private boolean hasToSkipMonth(short day, short month, short year) {
		if(month == 2)
			if(this.isLeapYear(year) && day > 29)
				return true;
			else if(!this.isLeapYear(year) && day > 28)
				return true;

		if((this.monthHasThirtyDays(month) && day > 30) || (!this.monthHasThirtyDays(month) && day > 31))
			return true;

		return false;
	}

	/**
	 * In this function we're going to verify if the
	 * mix-parcel combination exists in our map
	 *
	 * @param map
	 * @param parcel
	 * @param mix
	 * @return boolean
	 */
	private boolean parcelMixExists(Map<ArrayList<String>, ArrayList<Short>> map, String parcel, String mix) {
		for (Map.Entry<ArrayList<String>, ArrayList<Short>> entry : map.entrySet())
			if(entry.getKey().get(0).equalsIgnoreCase(parcel) && entry.getKey().get(1).equalsIgnoreCase(mix))
				return true;

		return false;
	}

	private boolean isMixApplicationDay(Map<ArrayList<String>, ArrayList<Short>> map, String parcel, String mix) {
		ArrayList<String> mixCombination;
		ArrayList<Short> applicationInformation;
		short nextApplication;

		for (Map.Entry<ArrayList<String>, ArrayList<Short>> entry : map.entrySet()) {
			mixCombination = entry.getKey();
			applicationInformation = entry.getValue();

			if((mixCombination.get(0).equals(parcel) && mixCombination.get(1).equals(mix)) && (applicationInformation.get(0) == applicationInformation.get(1))) {
				nextApplication = (short) (applicationInformation.get(1) + applicationInformation.get(2));
				applicationInformation.set(1, nextApplication);

				return true;
			}
		}

		return false;
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

			System.out.print("Please input the irrigation plan creation date (i.e: 19/10/2023): ");
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
	 * In this function we're going to parse the irrigation times
	 * that we got from the file to a format that is easier
	 * for us to process.
	 *
	 * In the ArrayList we're going to store more ArrayLists
	 * each containing an hour and minutes
	 *
	 * @return ArrayList<ArrayList<Byte>>
	 */
	private ArrayList<ArrayList<Byte>> parseTimes(ArrayList<String> irrigationTimes) {
		ArrayList<ArrayList<Byte>> timesToNumbers = new ArrayList<>();

		/**
		 * As we can have different irrigation times, we're going
		 * to loop through each one of them
		 */
		irrigationTimes.forEach((String time) -> {
			String[] parsedTime = time.split(":");

			int hours = Integer.parseInt(parsedTime[0]);
			int minutes = Integer.parseInt(parsedTime[1]);

			/**
			 * This is a not-so-good way to initialize our ArrayList
			 * with the values of hours and minutes
			 */
			ArrayList<Byte> timeList = new ArrayList<>(
				Arrays.asList(
					(byte) hours,
					(byte) minutes
				)
			);

			timesToNumbers.add(timeList);
		});

		return timesToNumbers;
	}

	/**
	 * We're going to get the last irrigation time and
	 * add the duration of the parcel's irrigation
	 *
	 * @param parcel
	 * @param lastIrrigationTime
	 *
	 * @return ArrayList<Byte>
	 */
	private ArrayList<Byte> calculateIrrigationTime(ArrayList<String> parcel, ArrayList<Byte> lastIrrigationTime) {
		ArrayList<Byte> finalIrrigationTime = new ArrayList<>();
		byte irrigationTime = (byte) Integer.parseInt(parcel.get(1));

		byte lastIrrigationTimeHours = lastIrrigationTime.get(0);
		byte lastIrrigationTimeMinutes = lastIrrigationTime.get(1);

		lastIrrigationTimeMinutes += irrigationTime;

		if(lastIrrigationTimeMinutes >= 60) {
			lastIrrigationTimeMinutes -= 60;
			lastIrrigationTimeHours++;
		}

		finalIrrigationTime.add(0, lastIrrigationTimeHours);
		finalIrrigationTime.add(1, lastIrrigationTimeMinutes);

		return finalIrrigationTime;
	}

	private ArrayList<Byte> writeDataToFile(String today, ArrayList<String> parcel, byte duration, ArrayList<Byte> startTime, FileWritingSystem fileWritingSystem, String mix) throws IOException {
		ArrayList<Byte> lastIrrigationTime = calculateIrrigationTime(parcel, startTime);

		String startTimeString = String.format("%02d:%02d", startTime.get(0), startTime.get(1));
		String endTimeString = String.format("%02d:%02d", lastIrrigationTime.get(0), lastIrrigationTime.get(1));

		String data = String.format("%s;%s;%02d;%s;%s;%s", today, parcel.get(0), duration, startTimeString, endTimeString, mix);
		fileWritingSystem.writeLine(data);

		return lastIrrigationTime;
	}

	/**
	 * Upon reaching a certain number of days we have to
	 * remove them, in order to go to the next month.
	 * This function takes care of removing the number of days
	 * that is the max number of days in a month.
	 *
	 * i.e: if we're checking in March, we're going to remove 30
	 * days to the currentCheckDay
	 *
	 * @return short
	 */
	private short removeDays(short currentCheckDay, short currentCheckMonth, ArrayList<Short> planCreationDate) {
		if(planCreationDate.get(1) == 2)
			if(currentCheckDay > 28) {
				if(this.isLeapYear(planCreationDate.get(3)))
					currentCheckDay -= 29;
				else
					currentCheckDay -= 28;
			}

		if(monthHasThirtyDays(currentCheckMonth))
			if(currentCheckDay > 30)
				currentCheckDay -= 30;

		if(currentCheckDay > 31)
			currentCheckDay -= 31;

		return currentCheckDay;
	}

	private boolean isLeapYear(short currentYear) {
		return (currentYear % 4 == 0 && currentYear % 100 != 0) || currentYear % 400 == 0;
	}

	private boolean monthHasThirtyDays(short currentMonth) {
		List<Short> hasThirtyDays = new ArrayList<>(
			Arrays.asList(
				(short) 4,
				(short) 6,
				(short) 9,
				(short) 11
			)
		);

		return hasThirtyDays.contains(currentMonth);
	}

	/**
	 * This function verifies if the current time is in the irrigation
	 * time or not, in order to better to the switch case on the
	 * isIrrigating function
	 *
	 * @return boolean
	 */
	private boolean checkIfInTime(ArrayList<ArrayList<Byte>> timesToNumbers, LocalTime now) {
		int currentHour = now.getHour();
		int currentMinute = now.getMinute();

		for (ArrayList<Byte> time : timesToNumbers)
			if (time.get(0) == currentHour && time.get(1) <= currentMinute)
				return true;


		return false;
	}

	/**
	 * In this function we're going to calculate the that until
	 * the irrigation is finished in minutes
	 *
	 * @return short
	 */
	private byte timeToFinishIrrigate(ArrayList<ArrayList<Byte>> timesToNumbers, LocalTime now, ArrayList<String> parcel) {
		byte parcelIrrigationTime = (byte) Integer.parseInt(parcel.get(1));
		byte currentMinute = (byte) now.getMinute();
		byte irrigationStartMinutes;
		byte minutesDifference;

		for(ArrayList<Byte> time : timesToNumbers) {
			irrigationStartMinutes = time.get(1);

			if(time.get(0) == now.getHour()) {
				minutesDifference = (byte) (currentMinute - irrigationStartMinutes);
				return (byte) (parcelIrrigationTime - minutesDifference);
			}
		}

		return -1;
	}

	private void registerIrrigationInFile(String today, ArrayList<String> parcel, byte duration, ArrayList<Byte> startTime, String appliedMix) {
		FileWritingSystem fileWritingSystem = null;
		String operation = appliedMix.equalsIgnoreCase("No") ? "Watering" : "Watering (with production factor)";

		try {
			fileWritingSystem = new FileWritingSystem("field_notebook.csv");

			String data = String.format(
				"%s;%s;%d;%s;%02d:%02d;%s",
				operation, today, duration, parcel.get(0), startTime.get(0), startTime.get(1), appliedMix
			).toString();
			fileWritingSystem.writeLine(data);
		} catch (Exception exception) {
			System.out.println(exception.getMessage());
			return;
		}
	}

	private boolean registerIrrigationInDatabase(String today, ArrayList<String> parcel, byte duration, ArrayList<Byte> startTime, String mix) {
		CallableStatement callableStatement = null;

		try {
			Connection connection = DatabaseConnection.getInstance().getConnection();
			callableStatement = connection.prepareCall("{ ? = call registerIrrigation(?, ?, ?, ?, ?, ?) }");

			callableStatement.setString(2, today);
			callableStatement.setInt(3, duration);
			callableStatement.setString(4, "min");
			callableStatement.setString(5, this.addSpaceBeforeNumber(parcel.get(0)));
			callableStatement.setString(
				6,
				String.format("%02d:%02d", startTime.get(0), startTime.get(1)).toString()
			);
			callableStatement.setString(
				7,
				mix == null ? mix : null
			);

			callableStatement.registerOutParameter(1, OracleTypes.VARCHAR);

			callableStatement.execute();
			connection.commit();

			String message = callableStatement.getString(1);
			System.out.println(message);
		} catch (Exception exception) {
			System.out.println("Something went wrong: " + exception.getMessage());
			return false;
		} finally {
			if(!Objects.isNull(callableStatement))
				try {
					callableStatement.close();
				} catch (Exception exception) {
					System.out.println("Something went wrong: " + exception.getMessage());
				}
		}

		return true;
	}

	public static String addSpaceBeforeNumber(String input) {
		StringBuilder result = new StringBuilder();

		for (int i = 0; i < input.length(); i++) {
			char currentChar = input.charAt(i);
			if (i > 0 && Character.isDigit(currentChar) && Character.isLetter(input.charAt(i - 1))) {
				// If the current character is a digit, and the previous character is a letter
				result.append(' '); // Add a space before the digit
			}
			result.append(currentChar);
		}

		return result.toString();
	}
}
