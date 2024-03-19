import controllers.DistributionDataToModel;
import models.Locality;
import models.graph.Algorithms;
import models.graph.map.MapGraph;
import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.util.*;
import java.util.function.BinaryOperator;

import static org.junit.jupiter.api.Assertions.*;

class AlgorithmsTest {

    @Test
    void shortestPath() throws Exception {
        DistributionDataToModel dataToModel = new DistributionDataToModel("locais_testUSEI02.csv", "distancias_testUSEI02.csv", "schedules_small.csv");
        MapGraph<Locality, Double> mapGraph = dataToModel.getDistances();

        Comparator<Double> comparator = Comparator.naturalOrder();
        BinaryOperator<Double> sum = Double::sum;

        Locality vOrig = mapGraph.vertex(0);
        Locality vDest = mapGraph.vertex(1);
        Double zero = 0.0;

        LinkedList<Locality> shortPath = new LinkedList<>();
        Double lengthPath = Algorithms.shortestPath(
                mapGraph, vOrig, vDest, comparator, sum, zero, shortPath
        );

        assertNotNull(lengthPath, "Length of the shortest path should not be null");
        assertTrue(lengthPath >= 0.0, "Length of the shortest path should be non-negative");

        assertEquals(2.0, lengthPath, "Expected shortest path length is 2.0");

        List<Locality> expectedPath = Arrays.asList(vOrig, vDest);
        assertEquals(expectedPath, shortPath, "Actual shortest path does not match the expected path");
    }




    @Test
    void furthestVertices() throws Exception {
        DistributionDataToModel dataToModel = new DistributionDataToModel("locais_testUSEI02.csv", "distancias_testUSEI02.csv", "schedules_small.csv");
        MapGraph<Locality, Double> mapGraph = dataToModel.getDistances();

        Comparator<Double> comparator = Comparator.naturalOrder();
        BinaryOperator<Double> sum = Double::sum;

        Map.Entry<Locality, Locality> furthestPair = Algorithms.furthestVertices(mapGraph, comparator, sum);

        assertNotNull(furthestPair, "Furthest pair should not be null");

        assertEquals(new Locality("CT2"), furthestPair.getKey(), "Unexpected origin locality");
        assertEquals(new Locality("CT5"), furthestPair.getValue(), "Unexpected destination locality");
    }




    @Test
    void shortestPathElementsWithCharging() throws Exception {
        DistributionDataToModel dataToModel = new DistributionDataToModel("locais_testUSEI02.csv", "distancias_testUSEI02.csv", "schedules_small.csv");
        MapGraph<Locality, Double> mapGraph = dataToModel.getDistances();

        Comparator<Double> comparator = Comparator.naturalOrder();
        BinaryOperator<Double> sum = Double::sum;
        double vehicleAutonomy = 300000.0;

        Locality vOrig = mapGraph.vertex(0);
        Locality vDest = mapGraph.vertex(1);

        LinkedList<Locality> shortPath = Algorithms.shortestPathElementsWithCharging(mapGraph, vOrig, vDest, comparator, sum, 0.0, vehicleAutonomy);

        assertNotNull(shortPath, "Shortest path should not be null");


        assertEquals(2, shortPath.size(), "Unexpected number of localities in the shortest path");
        assertEquals(new Locality("CT1"), shortPath.getFirst(), "Unexpected origin locality");
        assertEquals(new Locality("CT2"), shortPath.getLast(), "Unexpected destination locality");

    }

}