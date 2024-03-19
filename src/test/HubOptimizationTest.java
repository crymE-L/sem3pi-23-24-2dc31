import static org.junit.jupiter.api.Assertions.*;

import controllers.*;
import models.*;
import models.graph.map.*;
import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.util.*;

class HubOptimizationTest {

    @Test
    void orderByAllCriteria() throws Exception {
        DistributionDataToModel dataToModel = new DistributionDataToModel("locais_testUSEI02.csv", "distancias_testUSEI02.csv", "schedules_small.csv");
        MapGraph<Locality, Double> mapGraph = dataToModel.getDistances();

        HubOptimization hubOptimization = new HubOptimization();
        List<Locality> result = hubOptimization.orderByAllCriteria(mapGraph, 5);

        assertNotNull(result);
        assertEquals(5, result.size());
        assertEquals("CT1", result.get(0).getName());
        assertEquals("CT4", result.get(1).getName());
        assertEquals("CT5", result.get(2).getName());
        assertEquals("CT2", result.get(3).getName());
        assertEquals("CT3", result.get(4).getName());
    }
}
