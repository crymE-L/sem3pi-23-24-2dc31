package interfaces;

import java.io.IOException;
import java.util.ArrayList;

/**
 * This interface exists so that all the classes
 * that demand a kind of file reading feature
 * have a convention of methods
 *
 * @author: Miguel Ferreira (1210701@isep.ipp.pt)
 */
public interface FileReading {
	/**
	 * In every class that implements a file reading feature
	 * should have a method called readData that takes
	 * care of reading the file and returns the
	 * data in a form of a strings matrix
	 *
	 * @return String[][]
	 */
	public ArrayList<ArrayList<String>> readData() throws IOException;
}
