package controllers;

import models.Locality;
import org.apache.commons.lang3.tuple.ImmutablePair;
import org.apache.commons.lang3.tuple.MutablePair;
import org.apache.commons.lang3.tuple.Pair;
import utils.Utils;

import java.util.Iterator;
import java.util.LinkedList;

public class HubTrip extends Path {

    double startingAutonomy;
    double finishingAutonomy;
    LinkedList<Boolean> charges = new LinkedList<>(); //each element corresponds to the one in Path
    LinkedList<Pair<Integer,Integer>> departingTimes = new LinkedList<>();
    LinkedList<Pair<Integer,Integer>> arrivalTimes = new LinkedList<>();
    //departing times and arrival times are offset by 1 element
    //this is because the 1st hub has no arrival time and the last has no departing time

    public HubTrip(double startingAutonomy, Path path) {
        super(path);
        this.startingAutonomy = startingAutonomy;
    }

    public void calculateCharges(int maxAutonomy) {
        charges = new LinkedList<>();
        double currentAutonomy = startingAutonomy;
        Iterator<Locality> hubIterator = getShortestPath().iterator();
        Iterator<Double> weightIterator = getWeights().iterator();
        hubIterator.next(); //first hub

        while (hubIterator.hasNext()) {
            hubIterator.next(); //for each hub reached
            double edgeWeight = weightIterator.next();
            if (edgeWeight > currentAutonomy) {
                charges.addLast(true);
                currentAutonomy = maxAutonomy - edgeWeight;
            } else {
                charges.addLast(false);
                currentAutonomy -= edgeWeight;
            }
        }
        finishingAutonomy = currentAutonomy;
    }

    /**
     * Calculates the time it takes from being unloaded in the starting hub, and arriving at the destination hub
     * @param startingTime the time after unloading but before charging (if needed)
     * @param velocity the velocity of the vehicle, in m/min
     * @param chargingTime the time it takes for the vehicle to charge, in minutes
     * @return true if midnight was passed, false otherwise
     */
    public boolean calculateTime(Pair<Integer,Integer> startingTime, double velocity, int chargingTime) {
        boolean passedMidnight = false;
        MutablePair<Integer, Integer> currentTime = new MutablePair<>(startingTime.getLeft(), startingTime.getRight());
        departingTimes = new LinkedList<>();
        arrivalTimes = new LinkedList<>();
        Iterator<Locality> hubIterator = getShortestPath().iterator();
        Iterator<Double> weightIterator = getWeights().iterator();
        Iterator<Boolean> chargesIterator = charges.iterator();
        if (chargesIterator.next())
            Utils.addTime(currentTime, chargingTime);
        departingTimes.addFirst(new ImmutablePair<>(currentTime.getLeft(), currentTime.getRight()));

        boolean stop = false;
        hubIterator.next(); //first hub
        do {
            hubIterator.next(); //each hub reached
            int timeTaken = (int) Math.ceil(weightIterator.next() / velocity);
            boolean midnightCheck = Utils.addTime(currentTime, timeTaken);
            if (midnightCheck)
                passedMidnight = true;
            arrivalTimes.addLast(new ImmutablePair<>(currentTime.getLeft(), currentTime.getRight()));

            if (chargesIterator.hasNext()) { //not last stop
                if (chargesIterator.next()) {
                    midnightCheck = Utils.addTime(currentTime, chargingTime);
                    if (midnightCheck)
                        passedMidnight = true;
                }
            } else {
                stop = true;
            }
            departingTimes.addLast(new ImmutablePair<>(currentTime.getLeft(), currentTime.getRight()));
        } while (!stop);
        return passedMidnight;
    }

    public double getFinishingAutonomy() {
        return finishingAutonomy;
    }

    public MutablePair<Integer, Integer> getFinishingTime() {
        return new MutablePair<>(arrivalTimes.getLast().getLeft(), arrivalTimes.getLast().getRight());
    }

    public LinkedList<Boolean> getCharges() {
        return charges;
    }

    public LinkedList<Pair<Integer, Integer>> getDepartingTimes() {
        return departingTimes;
    }

    public LinkedList<Pair<Integer, Integer>> getArrivalTimes() {
        return arrivalTimes;
    }
}