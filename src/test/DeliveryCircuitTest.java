import controllers.DeliveryCircuit;
import controllers.DistributionDataToModel;
import models.Locality;
import models.Vehicle;
import models.graph.map.MapGraph;
import org.junit.jupiter.api.Test;
import utils.LowAutonomyException;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import static org.junit.Assert.assertThrows;
import static org.junit.jupiter.api.Assertions.assertEquals;

public class DeliveryCircuitTest {
    @Test
    void findOptimalDeliveryCircuit() throws Exception {
        DistributionDataToModel dataToModel = new DistributionDataToModel("locais_testUSEI08.csv", "distancias_testUSEI08.csv", "schedules_small.csv");
        MapGraph<Locality, Double> mapGraph = dataToModel.getDistances();
        Locality originLocality = mapGraph.vertices().get(0);
        DeliveryCircuit deliveryCircuit = new DeliveryCircuit();
        Vehicle vehicle = new Vehicle(30000000, 120, 20, 20);
        List<Locality> optimalCircuit = deliveryCircuit.findOptimalDeliveryCircuit(mapGraph, originLocality, 3, vehicle);

        assertEquals("CT1", optimalCircuit.get(0).getName());
        assertEquals("CT1", optimalCircuit.get(optimalCircuit.size()-1).getName());
        assertEquals(7, optimalCircuit.size());
        assertEquals("CT5", optimalCircuit.get(3).getName());
        assertEquals("CT4", optimalCircuit.get(4).getName());
        assertEquals("CT2", optimalCircuit.get(5).getName());
    }

    @Test
    void lowAutonomy() throws Exception {
        DistributionDataToModel dataToModel = new DistributionDataToModel("locais_testUSEI08.csv", "distancias_testUSEI08.csv", "schedules_small.csv");
        MapGraph<Locality, Double> mapGraph = dataToModel.getDistances();
        Locality originLocality = mapGraph.vertices().get(0);
        DeliveryCircuit deliveryCircuit = new DeliveryCircuit();

        List<Locality> targetLocalities = new ArrayList<>();
        targetLocalities.add(mapGraph.vertices().get(1));
        targetLocalities.add(mapGraph.vertices().get(2));

        assertEquals(Collections.emptyList(), deliveryCircuit.findShortestPathThroughVertices(mapGraph, originLocality, targetLocalities, 0));
    }


    @Test
    void shouldCharge() {
        DeliveryCircuit deliveryCircuit = new DeliveryCircuit();

        assertEquals(true, deliveryCircuit.shouldCharge(80, 1000));
        assertEquals(false, deliveryCircuit.shouldCharge(1000, 80));
    }

    @Test
    void calculateTotalTimeSpend() {
        DeliveryCircuit deliveryCircuit = new DeliveryCircuit();

        assertEquals(30, deliveryCircuit.calculateTotalTimeSpend(10, 10, 10));
    }

    @Test
    void calculateChargingTime() {
        DeliveryCircuit deliveryCircuit = new DeliveryCircuit();

        assertEquals(20, deliveryCircuit.calculateChargingTime(4, 5));
    }

    @Test
    void calculateDischargedTime() {
        DeliveryCircuit deliveryCircuit = new DeliveryCircuit();

        assertEquals(20, deliveryCircuit.calculateDischargedTime(4, 5));
    }

    @Test
    void calculateTravelledTime() {
        DeliveryCircuit deliveryCircuit = new DeliveryCircuit();

        assertEquals(0.6, deliveryCircuit.calculateTravelledTime(100, 1000));
    }
}
