package controllers;

import com.sun.tools.javac.Main;
import interfaces.BaseController;

import java.util.Scanner;

public class FieldNotebookController implements BaseController {
	@Override
	public void run() {
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
					this.checkFieldNotebook();
					break;
				case 2:
					this.registerIrrigationFromFile();
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

	private void checkFieldNotebook() {
		throw new UnsupportedOperationException("Not supported yet.");
	}

	private void registerIrrigationFromFile() {
		throw new UnsupportedOperationException("Not supported yet.");
	}
}
