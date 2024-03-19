package utils;

import interfaces.FileReading;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;

/**
 * This class exists to help us read files more easily
 * without having to rewrite over and over again
 * complex operations. This class is dynamic
 * and ready to be used by multiple types
 * of files
 *
 * @author Miguel Ferreira (1210701)
 */
public class FileReadingSystem implements FileReading {
	private String filename;
	private final String absolutePath = new File("").getAbsolutePath() + "/src/files/";

	private short sheet = 0;
	private int startingLine = 1;

	public FileReadingSystem(String filename) {
		this.setFilename(filename);
		this.setStartingLine(1);
	}

	public FileReadingSystem(String filename, short sheet) {
		this.setFilename(filename);
		this.setSheet(sheet);
		this.setStartingLine(1);
	}

	public FileReadingSystem(String filename, int startingLine) {
		this.setFilename(filename);
		this.setStartingLine(startingLine);
	}

	public String getFilename() {
		return filename;
	}

	public void setFilename(String filename) {
		this.filename = absolutePath + filename;
	}

	public short getSheet() {
		return sheet;
	}

	public void setSheet(short sheet) {
		if(sheet < 0)
			throw new IllegalArgumentException("Invalid sheet provided");

		this.sheet = sheet;
	}

	public int getStartingLine() {
		return this.startingLine;
	}

	public void setStartingLine(int startingLine) {
		if(startingLine < 1)
			throw new IllegalArgumentException("Starting line is invalid.");

		this.startingLine = startingLine;
	}

	/**
	 * No matter the type of file we're using, this function will
	 * read the data from the file provided and return in a
	 * String's matrix
	 *
	 * @return String[][]
	 * @throws FileNotFoundException
	 */
	@Override
	public ArrayList<ArrayList<String>> readData() throws IOException {
		if(this.verifyFileType().equals("excel")) {
			ExcelReadingSystem excelReadingSystem =
				new ExcelReadingSystem(
					this.getFilename(),
					this.sheet
				);

			return excelReadingSystem.readData();
		}

		CSVReadingSystem csvReadingSystem =
			new CSVReadingSystem(
				this.getFilename(),
				this.getStartingLine()
			);

		return csvReadingSystem.readData();
	}

	private String verifyFileType() {
		int dotPosition = this.filename.indexOf('.');
		String extension = this.filename.substring(dotPosition);

		if (extension.equals(".xlsx"))
			return "excel";

		return "csv";
	}
}
