package utils;

import interfaces.FileReading;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;

/**
 * This class creates a System prepared to read data
 * from an Excel spreadsheet
 *
 * @author Miguel Ferreira (1210701)
 */
public class ExcelReadingSystem implements FileReading {
	/**
	 * The file name
	 */
	private String filename;

	/**
	 * The sheet that we're working with
	 */
	private XSSFSheet sheet = null;

	/**
	 * This is the constructor with one argument (filename) that allows us to have more
	 * control when working with our Excel spreadsheet
	 *
	 * @param filename
	 * @throws IOException
	 */
	public ExcelReadingSystem(String filename) throws IOException {
		this.setFilename(filename);

		FileInputStream file = new FileInputStream(filename);
		XSSFWorkbook workbook = new XSSFWorkbook(file);

		/**
		 * This assumes that the sheet you're working with is at
		 * the first index. If not, use the constructor with
		 * the "sheet" parameter
		 */
		this.setSheet(workbook.getSheetAt(0));

		file.close();
	}

	/**
	 * This is the second constructor that takes in consideration
	 * the different sheets in the Excel file
	 *
	 * @param filename
	 * @param sheet
	 * @throws IOException
	 */
	public ExcelReadingSystem(String filename, int sheet) throws IOException {
		this.setFilename(filename);

		FileInputStream file = new FileInputStream(filename);
		XSSFWorkbook workbook = new XSSFWorkbook(file);

		this.setSheet(workbook.getSheetAt(sheet));

		file.close();
	}

	/**
	 * The getter for the filename
	 *
	 * @return String
	 */
	public String getFilename() {
		return filename;
	}

	/**
	 * The setter for the filename
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

	/**
	 * This function exists to verify if the passed
	 * data really is valid (not empty)
	 *
	 * @param name
	 * @return boolean
	 */
	private boolean isEmpty(String name) {
		return name.trim().isEmpty();
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
			".xlsx",
		};

		for(String possibleExtension : possibleExtensions)
			if(filename.contains(possibleExtension)) return true;

		return false;
	}

	/**
	 * The getter for the sheet
	 *
	 * @return XSSFSheet
	 */
	public XSSFSheet getSheet() {
		return sheet;
	}

	/**
	 * The setter for the sheet
	 *
	 * @param sheet
	 */
	public void setSheet(XSSFSheet sheet) {
		this.sheet = sheet;
	}

	/**
	 * This function will read all the data from our Excel file
	 * and return it in the form of a matrix
	 *
	 * @return String[][]
	 * @throws FileNotFoundException
	 */
	@Override
	public ArrayList<ArrayList<String>> readData() throws FileNotFoundException {
		if(this.getSheet() == null)
			throw new IllegalArgumentException("File was not setup correctly.");

		Iterator<Row> rowIterator = this.getSheet().iterator();

		int line = 0;

		ArrayList<ArrayList<String>> data = new ArrayList<>();

		while(rowIterator.hasNext()) {
			Row row = rowIterator.next();

			if (line == 0) {
				line++;
				continue;
			}

			while (data.size() <= (line - 1))
				data.add(new ArrayList<>());

			/**
			 * Get the cells of the row to loop through them
			 */
			Iterator<Cell> cellIterator = row.cellIterator();

			while(cellIterator.hasNext()) {
				Cell cell = cellIterator.next();
				String value = "";

				switch (cell.getCellType()) {
					case Cell.CELL_TYPE_NUMERIC:
						value = Double.toString(cell.getNumericCellValue());
						break;
					case Cell.CELL_TYPE_STRING:
						value = cell.getStringCellValue();
						break;
				}

				data.get(line - 1).add(value);
			}

			line++;
		}

		return data;
	}

	/**
	 * This function takes care of counting the file lines and
	 * returning the amount.
	 *
	 * @return short
	 */
	public short countFileLines() {
		short lines = 0;
		Iterator<Row> rowIterator = this.getSheet().iterator();

		while(rowIterator.hasNext())
			lines++;

		return lines;
	}
}
