package utils;

import interfaces.FileReading;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.Scanner;

/**
 * This class exists to help us read csv files more easily
 * without having to rewrite over and over again
 * complex operations.
 *
 * @author Miguel Ferreira (1210701)
 */
public class CSVReadingSystem implements FileReading {
	/**
	 * The file's name
	 */
	private String filename;

	/**
	 * The file that we want to work with
	 */
	private File file;

	/**
	 * The number of lines that the file has and, by
	 * default, is set to -1.
	 * This -1 flag is used to verify if the user
	 * was created correctly or not.
	 */
	private short lines = -1;

	/**
	 * The line where the reader should
	 * start to read the file
	 */
	private int startingLine = 1;

	/**
	 * This constructor is the default constructor for the CSVReadingSystem
	 * and, on a special note, takes a second parameter.
	 * This parameter is the columns and, by default, as the value 1.
	 *
	 * @param filename
	 * @throws FileNotFoundException
	 */
	public CSVReadingSystem(String filename) throws FileNotFoundException {
		setFilename(filename);
		setStartingLine(1);

		File file = null;

		try {
			file = new File(filename);
		} catch (IllegalArgumentException exception) {
			throw new IllegalArgumentException("Invalid file provided.");
		}

		/**
		 * Now that everything is verified properly
		 */
		this.file = file;
		this.lines = this.countFileLines();
	}

	/**
	 * This constructor is the default constructor for the CSVReadingSystem
	 * and, on a special note, takes a second parameter.
	 * This parameter is the columns and, by default, as the value 1.
	 *
	 * @param filename
	 * @throws FileNotFoundException
	 */
	public CSVReadingSystem(String filename, int startingLine) throws FileNotFoundException {
		setFilename(filename);
		setStartingLine(startingLine);

		File file = null;

		try {
			file = new File(filename);
		} catch (IllegalArgumentException exception) {
			throw new IllegalArgumentException("Invalid file provided.");
		}

		/**
		 * Now that everything is verified properly
		 */
		this.file = file;
		this.lines = this.countFileLines();
	}

	/**
	 * This setter for the filename will verify if
	 * the filename isn't empty and if it has
	 * a valid file extension
	 *
	 * @param filename
	 */
	public void setFilename(String filename) {
		if(this.isEmpty(filename))
			throw new IllegalArgumentException("Invalid filename.");

		if(!this.hasValidExtension(filename))
			throw new IllegalArgumentException("Invalid file extension.");

		this.filename = filename;
	}

	public void setStartingLine(int startingLine) {
		if(startingLine < 1)
			throw new IllegalArgumentException("Starting line is invalid.");

		this.startingLine = startingLine;
	}

	/**
	 * This function exists has a private validation to really
	 * see if the file has a valid exception or not,
	 * according to an array
	 *
	 * @param filename
	 * @return boolean
	 */
	private boolean hasValidExtension(String filename) {
		/**
		 * A little of all the possible extensions
		 * to the file
		 */
		String[] possibleExtensions = {
			".csv",
			".txt"
		};

		for(String possibleExtension : possibleExtensions)
			if(filename.contains(possibleExtension)) return true;

		return false;
	}

	/**
	 * This function exists to verify if the passed
	 * data really is valid (not empty)
	 *
	 * @param name
	 * @return boolean
	 */
	private boolean isEmpty(String name) {
		return name.trim().equals("");
	}

	/**
	 * This function will check the number of lines in the initialized
	 * file and return them, in order for the programmer to use later
	 *
	 * @return short
	 */
	public short countFileLines() throws FileNotFoundException {
		/**
		 * We want to verify if the file was really
		 * initializes and is ready to be used
		 */
		if(this.file.exists() && !this.file.isFile())
			throw new IllegalArgumentException("You must first provide a valid file.");

		Scanner read = new Scanner(this.file);
		short counter = 0;

		while (read.hasNextLine())
			if(!read.nextLine().isEmpty()) counter++;

		read.close();

		return counter;
	}

	/**
	 * This method exists to return all
	 * the data that the file has
	 *
	 * @return ArrayList<ArrayList<String>>
	 */
	@Override
	public ArrayList<ArrayList<String>> readData() throws FileNotFoundException {
		String dataChunk;
		String processedData;

		int currentLine = 0;

		if(this.file.exists() && !this.file.isFile())
			throw new IllegalArgumentException("You must first provide a valid file.");

		/**
		 * If the file is not initialized correctly, then
		 * the number of lines is -1
		 */
		if(lines == -1)
			throw new IllegalArgumentException("You must first provide a valid file.");

		ArrayList<ArrayList<String>> data = new ArrayList<>();

		for (int i = this.startingLine; i <= this.lines; i++) {
			dataChunk = this.findLine(i);

			/**
			 * Sometimes the file may present some empty
			 * lines, and, therefore, we shouldn't
			 * include them in our data variable
			 */
			if(this.isEmpty(dataChunk))
				continue;

			processedData = this.processData(dataChunk);

			while (data.size() <= currentLine)
				data.add(new ArrayList<>());

			/**
			 * We're going to loop through each string chunk in a line
			 * and add it to our data array, creating that way a nice and
			 * clean matrix with all the info we need.
			 *
			 * The rowPlacement variable is here to place the data in its
			 * specific positions
			 */
			for (String parameter : processedData.split(",")) {
				data.get(currentLine).add(parameter.trim());
			}

			currentLine++;
		}

		return data;
	}

	/**
	 * This function exists to find the content of a specific
	 * line in our file, allowing us to have a better
	 * understanding of its content
	 *
	 * @param line
	 * @return String
	 * @throws FileNotFoundException
	 */
	public String findLine(int line) throws FileNotFoundException {
		Scanner read = new Scanner(this.file);
		int counter = 0;

		while (read.hasNextLine()) {
			String currentLine = read.nextLine();

			if (counter == (line - 1)) {
				read.close();
				return currentLine;
			}

			counter++;
		}

		read.close();

		/**
		 * If the line doesn't exist in the file,
		 * we're going to return an empty string
		 */
		return "";
	}

	/**
	 * This private function exists to remove all the possible
	 * spaces in a given data chunk, in order for the code
	 * to have the purest form of data
	 *
	 * @return String
	 */
	private String processData(String dataChunk) {
		/**
		 * We're going to take the string with all of its spaces
		 * just so it's easier to get the data from the string
		 * after we split it
		 */
		return dataChunk.replaceAll("\\s", "");
	}
}
