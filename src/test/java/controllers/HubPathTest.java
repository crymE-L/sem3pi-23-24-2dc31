package controllers;

import models.Locality;
import models.graph.map.MapGraph;
import org.junit.jupiter.api.Test;

import java.io.IOException;

import static org.junit.Assert.assertNull;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;

public class HubPathTest {

    @Test
    public void testCalculateTimeTrip() {
        double averageSpeed = 60.0;
        double totalDistance = 120.0;

        double result = HubPath.calculateTimeTrip(averageSpeed, totalDistance);

        assertEquals(2.0, result, 0.01);

        double averageSpeedValid = 60.0;
        double totalDistanceValid = 120.0;
        double expectedTimeValid = 2.0;

        double resultValid = HubPath.calculateTimeTrip(averageSpeedValid, totalDistanceValid);
        assertEquals(expectedTimeValid, resultValid);


        double zeroSpeed = 0.0;
        double totalDistanceZeroSpeed = 100.0;

        double resultZeroSpeed = HubPath.calculateTimeTrip(zeroSpeed, totalDistanceZeroSpeed);
        assertEquals(Double.POSITIVE_INFINITY, resultZeroSpeed);


        double averageSpeedZeroDistance = 80.0;
        double zeroDistance = 0.0;

        double resultZeroDistance = HubPath.calculateTimeTrip(averageSpeedZeroDistance, zeroDistance);
        assertEquals(0.0, resultZeroDistance);
    }

    @Test
    public void testConvertToHoursAndMinutes() {
        double hoursOnly = 4.0;
        double hoursDecimal = 2.5;
        double invalidInput = -1.5;
        double zeroHours = 0.0;
        double minutes = 0.3;

        String result = HubPath.convertToHoursAndMinutes(hoursOnly);
        String result1 = HubPath.convertToHoursAndMinutes(hoursDecimal);
        String result2 = HubPath.convertToHoursAndMinutes(invalidInput);
        String result3 = HubPath.convertToHoursAndMinutes(zeroHours);
        String result4 = HubPath.convertToHoursAndMinutes(minutes);

        assertEquals("4h 00min", result);
        assertEquals("2h 30min", result1);
        assertEquals("Valor de horas inválido.", result2);
        assertEquals("0h 00min", result3);
        assertEquals("0h 18min", result4);
    }


    @Test
    public void testLocalityExists() throws Exception {
        DistributionDataToModel dataToModel = new DistributionDataToModel("locais_testUSEI08.csv", "distancias_testUSEI08.csv", "schedules_small.csv");

        MapGraph<Locality, Double> mapGraph = dataToModel.getDistances();


        Locality result = HubPath.localityExists(mapGraph, "CT2");
        Locality result1 = HubPath.localityExists(mapGraph, "Avanca");

        assertNotNull(result);
        assertEquals("CT2", result.getName());
        assertNull(result1);
    }
}
