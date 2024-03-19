package utils;

import oracle.jdbc.pool.OracleDataSource;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Objects;
import java.util.Properties;

public class DatabaseConnection {

	private static DatabaseConnection instance;

	private final Connection connection;

	public DatabaseConnection() throws SQLException {
		Properties properties = new Properties();

		try {
			properties.load(getClass().getResourceAsStream("/application.properties"));
		} catch (IOException e) {
			e.printStackTrace();
		}

		String databaseURL = properties.getProperty("database.url");
		String databaseUser = properties.getProperty("database.user");
		String databasePassword = properties.getProperty("database.password");

		OracleDataSource dataSource = new OracleDataSource();
		dataSource.setURL(databaseURL);

		connection = dataSource.getConnection(
			databaseUser,
			databasePassword
		);
		connection.setAutoCommit(false);
	}

	public Connection getConnection() {
		return this.connection;
	}

	public int testConnection() {
		if(Objects.isNull(connection))
			return -1;

		return 1;
	}

	public void closeConnection() throws SQLException {
		if(!connection.isClosed())
			connection.close();
	}

	public static DatabaseConnection getInstance() throws SQLException {
		if(Objects.isNull(instance))
			instance = new DatabaseConnection();

		return instance;
	}
}
