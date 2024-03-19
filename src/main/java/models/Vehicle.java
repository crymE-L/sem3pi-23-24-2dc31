package models;

public class Vehicle {

    private double autonomy;
    private double averageSpeed;
    private double chargingTime;
    private double dischargedTime;

    public Vehicle(double autonomy, double averageSpeed, double chargingTime) {
        this.autonomy = autonomy;
        this.averageSpeed = averageSpeed;
        this.chargingTime = chargingTime;
    }

    public Vehicle(double autonomy, double averageSpeed, double chargingTime, double dischargedTime) {
        this.autonomy = autonomy;
        this.averageSpeed = averageSpeed;
        this.chargingTime = chargingTime;
        this. dischargedTime = dischargedTime;
    }

    public double getAutonomy() {
        return autonomy;
    }

    public double getAverageSpeed() {
        return averageSpeed;
    }

    public double getChargingTime() {
        return chargingTime;
    }

    public double getDischargedTime() {
        return  dischargedTime;
    }
}
