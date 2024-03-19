import controllers.DistributionDataToModel;
import controllers.LocationClustering;
import models.Locality;
import models.graph.map.MapGraph;
import org.junit.jupiter.api.Test;

import java.util.Map;
import java.util.Set;

import static org.junit.jupiter.api.Assertions.*;

public class LocationClusteringTest {
    @Test
    public void testClusterSizes() throws Exception {
        DistributionDataToModel dataToModel = new DistributionDataToModel("locais_small.csv", "distancias_small.csv", "schedules_small.csv");
        MapGraph<Locality, Double> actualMapGraph = dataToModel.getDistances();
        int numberOfClusters = 3;

        Map<Locality, Set<Locality>> actualClusters = LocationClustering.organizeGraphIntoClusters(actualMapGraph, numberOfClusters);

        assertEquals(3, actualClusters.size());
    }

    @Test
    public void testCorrectnessOfClusters() throws Exception {
        DistributionDataToModel dataToModel = new DistributionDataToModel("locais_small.csv", "distancias_small.csv", "schedules_small.csv");
        MapGraph<Locality, Double> mapGraph = dataToModel.getDistances();
        int numberOfClusters = 3;

        Map<Locality, Set<Locality>> actualClusters = LocationClustering.organizeGraphIntoClusters(mapGraph, numberOfClusters);

        Locality expectedHubOne = new Locality("CT17",40.6667,-7.9167);
        Locality expectedHubTwo = new Locality("CT5",39.823,-7.4931);
        Locality expectedHubThree = new Locality("CT16",41.3002,-7.7398);

        assertTrue(actualClusters.keySet().stream().anyMatch(expectedHubOne::equals));
        assertTrue(actualClusters.keySet().stream().anyMatch(expectedHubTwo::equals));
        assertTrue(actualClusters.keySet().stream().anyMatch(expectedHubThree::equals));
    }

    @Test
    public void testExecutionTime() throws Exception {
        DistributionDataToModel dataToModel = new DistributionDataToModel("locais_small.csv", "distancias_small.csv", "schedules_small.csv");
        MapGraph<Locality, Double> mapGraph = dataToModel.getDistances();
        int numberOfClusters = 3;

        long startTime = System.currentTimeMillis();
        Map<Locality, Set<Locality>> actualClusters = LocationClustering.organizeGraphIntoClusters(mapGraph, numberOfClusters);

        long elapsedTime = System.currentTimeMillis() - startTime;
        long elapsedSeconds = elapsedTime / 1000;
        long maximumTimeAllowed = 10;

        assertTrue(elapsedSeconds < maximumTimeAllowed, "Execution time exceeded " + maximumTimeAllowed + " seconds." + elapsedSeconds);
        assertNotNull(actualClusters);
    }
}
