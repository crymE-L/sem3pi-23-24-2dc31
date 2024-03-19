import controllers.DistributionDataToModel;
import controllers.MinimumSpanningTree;
import models.Locality;
import models.graph.Edge;
import models.graph.map.MapGraph;
import org.junit.Test;

import java.io.IOException;

import static org.junit.jupiter.api.Assertions.*;

public class MinimumSpanningTreeTest {

    @Test
    public void testPrimAlgorithmVertices() {
        MapGraph<Locality, Double> vertexOnlyGraph = createTestGraph();

        MapGraph<Locality, Double> vertexOnlyResult = MinimumSpanningTree.findMinimumConnectionNetwork(vertexOnlyGraph);

        assertEquals(4, vertexOnlyResult.vertices().size());
    }

    @Test
    public void testPrimAlgorithmEdges() {
        MapGraph<Locality, Double> edgesOnlyGraph = createTestGraph();

        MapGraph<Locality, Double> edgesOnlyResult = MinimumSpanningTree.findMinimumConnectionNetwork(edgesOnlyGraph);

        assertEquals(6, (edgesOnlyResult.edges().size()));
    }

    @Test
    public void testPrimAlgorithmDifferentWeights() {
        MapGraph<Locality, Double> differentWeightsGraph = createTestGraph();

        MapGraph<Locality, Double> differentWeightsNotNull = MinimumSpanningTree.findMinimumConnectionNetwork(differentWeightsGraph);
        MapGraph<Locality, Double> differentWeightsVertices = MinimumSpanningTree.findMinimumConnectionNetwork(differentWeightsGraph);
        MapGraph<Locality, Double> differentWeightsEdges = MinimumSpanningTree.findMinimumConnectionNetwork(differentWeightsGraph);

        assertNotNull(differentWeightsNotNull);
        assertEquals(4, differentWeightsVertices.vertices().size());
        assertEquals(6, differentWeightsVertices.edges().size());
    }

    @Test
    public void testPrimAlgorithmTimeConsumption() throws Exception {
        DistributionDataToModel dataToModel = new DistributionDataToModel("locais_big.csv", "distancias_big.csv", "schedules_small.csv");
        MapGraph<Locality, Double> timeConsumptionGraph = dataToModel.getDistances();

        long startTime = System.currentTimeMillis();

        MapGraph<Locality, Double> timeConsumptionResult = MinimumSpanningTree.findMinimumConnectionNetwork(timeConsumptionGraph);


        long elapsedTime = System.currentTimeMillis() - startTime;
        long elapsedSeconds = elapsedTime / 1000;
        long maximumTimeAllowed = 3;

        assert elapsedSeconds < maximumTimeAllowed :
                "Execution time exceeded " + maximumTimeAllowed + " seconds." + elapsedSeconds;
    }

    private MapGraph<Locality, Double> createTestGraph() {
        MapGraph<Locality, Double> mapGraph = new MapGraph<>(false);

        // Adicionar localidades ao grafo de application.example.properties
        Locality locality1 = new Locality("CT1");
        Locality locality2 = new Locality("CT2");
        Locality locality3 = new Locality("CT3");
        Locality locality4 = new Locality("CT4");

        mapGraph.addVertex(locality1);
        mapGraph.addVertex(locality2);
        mapGraph.addVertex(locality3);
        mapGraph.addVertex(locality4);

        mapGraph.addEdge(locality1, locality2, 1.0);
        mapGraph.addEdge(locality2, locality3, 1.0);
        mapGraph.addEdge(locality3, locality4, 1.0);

        return mapGraph;
    }

    private String generateExpectedResult(MapGraph<Locality, Double> graph) {
        StringBuilder expected = new StringBuilder();
        expected.append("Graph: ")
                .append(graph.vertices().size())
                .append(" vertices, ")
                .append(graph.edges().size())
                .append(" edges\n");

        for (Locality v : graph.vertices()) {
            expected.append(v.toString()).append(": \n");
            for (Edge<Locality, Double> edge : graph.outgoingEdges(v)) {
                expected.append(edge.getVOrig().toString())
                        .append(" -> ")
                        .append(edge.getVDest().toString())
                        .append("\nWeight: ")
                        .append(edge.getWeight())
                        .append("\n");
            }
        }
        return expected.toString();
    }
}
