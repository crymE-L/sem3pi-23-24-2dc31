package utils;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;

/**
 * This class exists to handle everything related to writing to a file.
 * The class won't work if you're trying to write to an Excel file
 *
 * @author Miguel Ferreira
 */
public class FileWritingSystem {
	private String filename;
	private final String absolutePath = new File("").getAbsolutePath() + "/filesOutput/";

	private File file;

	public FileWritingSystem(String filename) throws IOException {
		this.setFilename(filename);

		File file = new File(this.filename);

		if(!file.exists())
			file.createNewFile();

		this.setFile(file);
	}

	public String getFilename() {
		return filename;
	}

	public void setFilename(String filename) {
		if(this.isEmpty(filename))
			throw new IllegalArgumentException("The file name is invalid.");

		this.filename = absolutePath + filename;
	}

	public File getFile() {
		return file;
	}

	public void setFile(File file) {
		if(file == null)
			throw new IllegalArgumentException("The file provided is invalid.");

		this.file = file;
	}

	private boolean isEmpty(String filename) {
		return filename.trim().isEmpty();
	}

	public boolean writeManyLines(ArrayList<ArrayList<String>> lines) throws IOException {
		for (ArrayList<String> lineList : lines) {
			String line = this.generateLine(lineList);

			if(!this.writeLine(line))
				return false;
		}

		return true;
	}

	public boolean writeLine(String line) throws IOException {
		FileWriter fileWriter = new FileWriter(this.filename, true);

		try {
			fileWriter.write(line);
			fileWriter.write("\n");
		} catch (Exception exception) {
			fileWriter.close();
			return false;
		}

		fileWriter.close();
		return true;
	}

	/**
	 * This function takes in an ArrayList<String> and turns that list
	 * into a string
	 *
	 * @param lineList
	 * @return String
	 */
	public String generateLine(ArrayList<String> lineList) {
		StringBuilder stringBuilder = new StringBuilder();

		for (String lineChunk : lineList)
			stringBuilder.append(lineChunk).append(" ");

		return stringBuilder.toString();
	}
}
