package controllers;

import com.sun.tools.javac.Main;
import interfaces.BaseController;

import java.io.IOException;
import java.util.Scanner;

public class OperationController implements BaseController {
	@Override
	public void run() throws Exception {
		Scanner reader = new Scanner(System.in);
		byte option = 0;

		while(option != 3) {
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
					this.checkOperations();
					break;
				case 2:
					runController(
						new RegisterOperationController()
					);
					break;
				case 3:
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
			"Check operations",
			"Register operation"
		};

		BaseController.super.showMenu(menu);
	}

	private void checkOperations() {
		throw new UnsupportedOperationException("Not supported yet.");
	}

	/**
	 * The declaration and running of each controller was repetitive,
	 * so it's better to create a function that takes care of it
	 *
	 * @param controller
	 * @param <T>
	 */
	private static <T extends BaseController> void runController(T controller) throws Exception {
		controller.run();
	}
}
