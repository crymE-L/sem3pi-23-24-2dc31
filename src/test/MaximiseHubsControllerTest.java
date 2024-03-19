import controllers.DistributionDataToModel;
import controllers.HubTrip;
import controllers.MaximiseHubsController;
import models.Locality;
import models.graph.map.MapGraph;
import org.junit.jupiter.api.Test;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import static org.junit.jupiter.api.Assertions.*;

public class MaximiseHubsControllerTest {
    @Test
    public void testGetPathWithMostHubs() throws Exception {
        DistributionDataToModel dataToModel = new DistributionDataToModel("locais_small.csv", "distancias_small.csv", "schedules_small.csv");
        MapGraph<Locality, Double> actualMapGraph = dataToModel.getDistances();
        int numberOfHubs = 3;

        MaximiseHubsController controller = new MaximiseHubsController();
        controller.generateTrueMapGraph(actualMapGraph, numberOfHubs);

        controller.setAutonomy(200);
        controller.setVelocity(60);
        controller.setChargingTime(30);
        controller.setUnloadingTime(15);

        List<HubTrip> hubTrips = controller.getPathWithMostHubs();

        assertNotNull(hubTrips);
        assertFalse(hubTrips.isEmpty());
    }

    @Test
    public void testInsufficientAutonomy() throws Exception {
        MaximiseHubsController maximizeHubsController = new MaximiseHubsController();
        maximizeHubsController.setStartingLocation(new Locality("CT1", 40.0, -7.0));
        maximizeHubsController.setAutonomy(50);

        List<HubTrip> hubTrips = maximizeHubsController.getPathWithMostHubs();

        assertEquals(0, hubTrips.size());
    }

    @Test
    public void testTrueHubsSelection() throws Exception {
        MaximiseHubsController maximizeHubsController = new MaximiseHubsController();
        maximizeHubsController.setStartingLocation(new Locality("CT1", 40.0, -7.0));
        maximizeHubsController.setAutonomy(2000000);

        Set<Locality> selectedTrueHubs = new HashSet<>();
        selectedTrueHubs.add(new Locality("CT3", 42.0, -8.0));
        selectedTrueHubs.add(new Locality("CT5", 39.0, -7.5));

        maximizeHubsController.setTrueHubs(selectedTrueHubs);

        List<HubTrip> hubTrips = maximizeHubsController.getPathWithMostHubs();

        assertTrue(hubTrips.size() > 0);
        for (HubTrip trip : hubTrips) {
            assertTrue(selectedTrueHubs.contains(trip.getShortestPath().getLast()));
        }
    }

}
