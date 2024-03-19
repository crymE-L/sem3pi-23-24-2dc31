package models;

public class Locality {
	/**
	 * The variable to represents the name of
	 * the locality (hub)
	 */
	private String name;

	/**
	 * This variable represents the locality's position
	 * on the X axis, meaning latitude.
	 */
	private double x;

	/**
	 * This variable represents the locality's position
	 * on the Y axis, meaning longitude.
	 */
	private double y;

	/**
	 * This variable represents the number of
	 * collaborators in the locality.
	 */
	private int collaborators;

	/**
	 * This variable represents the opening hours
	 * of the locality.
	 */
	private String operatingHours;

	/**
	 * This variable represents the hub's
	 * opening hours
	 */
	private byte[] openingHours;

	/**
	 * This variable represents the hub's
	 * closing hours
	 */
	private byte[] closingHours;

	/**
	 * The constructor to generate the locality object,
	 * representing a Hub.
	 *
	 * @param name
	 * @param x
	 * @param y
	 */
	public Locality(String name, double x, double y) {
		this.setName(name);
		this.setX(x);
		this.setY(y);
	}

	/**
	 * The constructor to generate the locality object,
	 * representing a Hub without a provided location.
	 *
	 * @param name
	 */
	public Locality(String name) {
		this.setName(name);
		this.setX(0);
		this.setY(0);
	}

	/**
	 * The constructor to generate the locality object,
	 * representing a Hub with only a schedule.
	 *
	 * @param name
	 */
	public Locality(String name, String openingHours, String closingHours) {
		this.setName(name);
		this.setX(0);
		this.setY(0);

		this.setOpeningHours(
			this.timeStringToTime(openingHours)
		);
		this.setClosingHours(
			this.timeStringToTime(closingHours)
		);
	}

	/**
	 * The getter for the name property
	 *
	 * @return String
	 */
	public String getName() {
		return name;
	}

	/**
	 * The setter for the name property
	 *
	 * @param name
	 */
	public void setName(String name) {
		if(name.trim().isEmpty())
			throw new IllegalArgumentException("The name provided is not valid.");

		this.name = name;
	}

	/**
	 * The getter for the x property
	 *
	 * @return double
	 */
	public double getX() {
		return x;
	}

	/**
	 * The setter for the x property
	 *
	 * @param x
	 */
	public void setX(double x) {
		this.x = x;
	}

	/**
	 * The getter for the y property
	 *
	 * @return double
	 */
	public double getY() {
		return y;
	}

	/**
	 * The setter for the x property
	 *
	 * @param y
	 */
	public void setY(double y) {
		this.y = y;
	}

	/**
	 * The getter for the collaborators
	 * number
	 *
	 * @return int
	 */
	public int getCollaborators() {
		return collaborators;
	}

	/**
	 * The setter for the collaborators
	 * number
	 *
	 * @param collaborators
	 */
	public void setCollaborators(int collaborators) {
		this.collaborators = collaborators;
	}

	/**
	 * The getter for the locality opening
	 * hours
	 *
	 * @return String
	 */
	public String getOperatingHours() {
		return operatingHours;
	}

	/**
	 * The setter for the locality opening
	 * hours
	 *
	 * @param operatingHours
	 */
	public void setOperatingHours(String operatingHours) {
		this.operatingHours = operatingHours;
		String[] times = operatingHours.replace(" ", "").split("-");

		this.setOpeningHours(
			this.timeStringToTime(times[0])
		);
		this.setClosingHours(
			this.timeStringToTime(times[1])
		);
	}

	/**
	 * The getter for the opening hours
	 *
	 * @return byte[]
	 */
	public byte[] getOpeningHours() {
		return this.openingHours;
	}

	/**
	 * The setter for the opening hours
	 *
	 * @param openingHours
	 */
	public void setOpeningHours(byte[] openingHours) {
		if(!isValidTime(openingHours))
			throw new IllegalArgumentException("Invalid opening hours provided.");

		this.openingHours = openingHours;
	}

	/**
	 * The getter for the closing hours
	 *
	 * @return byte[]
	 */
	public byte[] getClosingHours() {
		return this.closingHours;
	}

	/**
	 * The setter for the closing hours
	 *
	 * @param closingHours
	 */
	public void setClosingHours(byte[] closingHours) {
		if(!isValidTime(closingHours))
			throw new IllegalArgumentException("Invalid opening hours provided.");

		this.closingHours = closingHours;
	}

	/**
	 * Convert any time from a string to an array of byte
	 *
	 * @param time
	 * @return byte[]
	 */
	public byte[] timeStringToTime(String time) {
		String[] separatedTime = time.split(":");
		byte[] resultTime = new byte[2];

		resultTime[0] = Byte.parseByte(separatedTime[0]);
		resultTime[1] = Byte.parseByte(separatedTime[1]);

		return resultTime;
	}

	/**
	 * Convert a time in a byte array and turn
	 * it into a valid string that we can
	 * show to the user hh:mm
	 *
	 * @param time
	 * @return String
	 */
	public String timeToString(byte[] time) {
		return String.format("%d:%d", time[0], time[1]);
	}

	@Override
	public String toString() {
		return String.format(this.getName());
	}

	public boolean equals(Locality other) {
		return this.getName().equals(other.getName());
	}

	/**
	 * This function exists to validate the time,
	 * returning false if it is not
	 *
	 * @param time
	 * @return false
	 */
	private boolean isValidTime(byte[] time) {
		if(time == null)
			return false;

		if(time[0] > 23 || time[1] > 59)
			return false;

		if(time[0] <0 || time[1] < 0)
			return false;

		return true;
	}
}
