package controllers;

import java.util.Iterator;
import java.util.LinkedList;
import java.util.Optional;

import models.Locality;
import models.graph.map.MapGraph;
import org.apache.commons.lang3.tuple.ImmutablePair;
import org.apache.commons.lang3.tuple.Pair;

public class Path implements Comparable<Path> {
    double weight;
    LinkedList<Locality> shortestPath = new LinkedList<>();
    LinkedList<Double> weights = new LinkedList<>();

    public Path() {}

    public Path(Path hubPath) {
        if (hubPath != null) {
            this.weight = hubPath.getWeight();
            this.shortestPath = hubPath.getShortestPath();
            this.weights = hubPath.getWeights();
        }
    }

    public boolean id(Locality start, Locality end) {
        return (start == shortestPath.peekFirst() && end == shortestPath.peekLast());
    }

    /**
     * Updates the weight of the total path
     * IMPORTANT: if the return is not empty the weight will not be complete!!!
     *
     * @param mapGraph the map graph
     * @param autonomy the autonomy of the vehicle
     * @return Empty if the path can be done with the given autonomy, and the first pair of edges that do not allow
     * to do so if any.
     */
    public Optional<Pair<Locality, Locality>> updateValues(MapGraph<Locality, Double> mapGraph, int autonomy) {
        this.weights = new LinkedList<>();
        this.weight = 0;
        Iterator<Locality> iterator = shortestPath.iterator();
        Locality startingLocation = iterator.next();
        Locality finishingLocation;
        while (iterator.hasNext()) {
            finishingLocation = iterator.next();
            double edgeWeight = mapGraph.edge(startingLocation, finishingLocation).getWeight();
            if (edgeWeight > autonomy)
                return Optional.of(new ImmutablePair<>(startingLocation, finishingLocation));
            this.weight += edgeWeight;
            this.weights.addLast(edgeWeight);
            startingLocation = finishingLocation;
        }
        return Optional.empty();
    }

    public double getWeight() {
        return weight;
    }

    public LinkedList<Locality> getShortestPath() {
        return shortestPath;
    }

    public LinkedList<Double> getWeights() {
        return weights;
    }

    @Override
    public int compareTo(Path o) {
        return Double.compare(this.weight, o.weight);
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Path hubPath = (Path) o;

        return (hubPath.getShortestPath().peekFirst() == shortestPath.peekFirst()
                && hubPath.shortestPath.peekLast() == shortestPath.peekLast());
    }

    @Override
    public int hashCode() {
        return shortestPath.hashCode();
    }
}