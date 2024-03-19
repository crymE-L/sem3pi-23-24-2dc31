import controllers.*;
import interfaces.BaseController;

import java.io.IOException;
import java.util.*;

public class Main {
	public static void main(String[] args) throws Exception {
		clearScreen();

		Scanner reader = new Scanner(System.in);
		byte option = 0;

		while(option != 6) {
			showMainMenu();

			try {
				System.out.print("Choose an option >> ");
				option = reader.nextByte();
			} catch (Exception exception) {
				option = 0;
				reader.nextLine();
			}

			switch (option) {
				case 1:
					runController(
						new OperationController()
					);

					break;
				case 2:
					runController(
						new DistributionController()
					);

					break;
				case 3:
					runController(
						new FieldNotebookController()
					);

					break;
				case 4:
					runController(
						new IrrigationController()
					);

					break;
				case 5:
					runController(
						new LegacyController()
					);

					break;
				case 6:
					break;
				default:
					System.out.println("Invalid option! Please choose a valid one.");
					break;
			}
		}

		System.out.println("Bye bye! :)");
	}

	public static void clearScreen()
	{
		try {
			final String os = System.getProperty("os.name");

			if (os.contains("Windows"))
				Runtime.getRuntime().exec("cls");
			else
				Runtime.getRuntime().exec("clear");
		}
		catch (final Exception e) {
			System.out.println("Couldn't clear screen.");
		}
	}

	private static void showMainMenu() {
		String[] menu = {
			"Operations",
			"Distribution system",
			"Field notebook",
			"Irrigation system",
			"Legacy data"
		};

		for (int i = 0; i < menu.length; i++)
			System.out.printf("%d - %s\n", (i + 1), menu[i]);

		System.out.printf("%d - Exit\n", (menu.length + 1));
	}

	/**
	 * The declaration and running of each controller was repetitive,
	 * so it's better to create a function that takes care of it
	 *
	 * @param controller
	 * @param <T>
	 */
	private static <T extends BaseController> void runController(T controller) throws Exception {
		try {
			controller.run();
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}
}
