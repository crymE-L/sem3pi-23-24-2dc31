package interfaces;

import java.io.IOException;

public interface BaseController {
	public void run() throws Exception;
	void showMenu();

	/**
	 * Each controller has its own menu, therefore we
	 * should force the controller to show it to
	 * the user
	 */
	default void showMenu(String[] menu) {
		for (int i = 0; i < menu.length; i++)
			System.out.printf("%d - %s\n", (i + 1), menu[i]);

		System.out.printf("%d - Exit / Go back\n", (menu.length + 1));
	}
}
