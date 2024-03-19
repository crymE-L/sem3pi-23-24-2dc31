package models.graph;

import models.graph.Graph;
import models.graph.matrix.MatrixGraph;

import java.lang.reflect.Array;
import java.util.*;
import java.util.function.BinaryOperator;

/**
 *
 * @author DEI-ISEP
 *
 */
public class Algorithms {

    /** Performs breadth-first search of a Graph starting in a vertex
     *
     * @param g Graph instance
     * @param vert vertex that will be the source of the search
     * @return a LinkedList with the vertices of breadth-first search
     */
    public static <V, E> LinkedList<V> BreadthFirstSearch(Graph<V, E> g, V vert) {

        if (g == null || vert == null || !g.validVertex(vert)) {
            return null;
        }

        LinkedList<V> qbfs = new LinkedList<>();
        LinkedList<V> qaux = new LinkedList<>();
        boolean[] visited = new boolean[g.numVertices()];

        qbfs.add(vert);
        qaux.add(vert);
        visited[g.key(vert)] = true;

        while(!qaux.isEmpty()){
            V vOrig = qaux.remove(0);
            for (V vAdj : g.adjVertices(vOrig)) {
                if (!visited[g.key(vAdj)]) {
                    qbfs.add(vAdj);
                    qaux.add(vAdj);
                    visited[g.key(vAdj)] = true;
                }
            }
        }
        return qbfs;
    }

    /** Performs depth-first search starting in a vertex
     *
     * @param g Graph instance
     * @param vOrig vertex of graph g that will be the source of the search
     * @param visited set of previously visited vertices
     * @param qdfs return LinkedList with vertices of depth-first search
     */
    private static <V, E> void DepthFirstSearch(Graph<V, E> g, V vOrig, boolean[] visited, LinkedList<V> qdfs) {

        if (visited[g.key(vOrig)]) {
            return;
        }
        qdfs.add(vOrig);
        visited[g.key(vOrig)] = true;

        for (V vAdj : g.adjVertices(vOrig)) {
            if (!visited[g.key(vAdj)]) {
                DepthFirstSearch(g, vAdj, visited, qdfs);
            }
        }
    }

    /** Performs depth-first search starting in a vertex
     *
     * @param g Graph instance
     * @param vert vertex of graph g that will be the source of the search

     * @return a LinkedList with the vertices of depth-first search
     */
    public static <V, E> LinkedList<V> DepthFirstSearch(Graph<V, E> g, V vert) {

        if (g == null || vert == null || !g.validVertex(vert))
            return null;

        LinkedList<V> qdfs = new LinkedList<>();
        boolean[] visited = new boolean[g.numVertices()];

        DepthFirstSearch(g,vert,visited,qdfs);

        return qdfs;
    }

    /** Returns all paths from vOrig to vDest
     *
     * @param g       Graph instance
     * @param vOrig   Vertex that will be the source of the path
     * @param vDest   Vertex that will be the end of the path
     * @param visited set of discovered vertices
     * @param path    stack with vertices of the current path (the path is in reverse order)
     * @param paths   ArrayList with all the paths (in correct order)
     */
    private static <V, E> void allPaths(Graph<V, E> g, V vOrig, V vDest, boolean[] visited,
                                        LinkedList<V> path, ArrayList<LinkedList<V>> paths) {

        path.push(vOrig);
        visited[g.key(vOrig)] = true;

        for (V vAdj : g.adjVertices(vOrig)){

            if (vAdj == vDest) {
                path.push(vDest);
                paths.add(path);
                path.pop();
            }else {
                if (!visited[g.key(vAdj)])
                    allPaths(g,vAdj,vDest,visited,path,paths);
            }
        }
        path.pop();
    }

    /**
     * Returns all paths from vOrig to vDest
     *
     * @param g        Graph instance
     * @param vOrig    information of the Vertex origin
     * @param vDest    information of the Vertex destination
     * @return paths ArrayList with all paths from vOrig to vDest
     */
    public static <V, E> ArrayList<LinkedList<V>> allPaths(Graph<V, E> g, V vOrig, V vDest) {

        boolean[] visited = new boolean[g.numVertices()];
        LinkedList<V> path = new LinkedList<>();
        ArrayList<LinkedList<V>> paths = new ArrayList<>();

        if (g == null || vOrig == null || vDest == null || !g.validVertex(vOrig)|| !g.validVertex(vDest))
            return null;

        allPaths(g,vOrig,vDest,visited,path,paths);
        return paths;
    }

    public static <V, E extends Comparable<E>> ArrayList<LinkedList<V>> allPathsWithAutonomy(Graph<V, E> g, V vOrig, V vDest, double vehicleAutonomy) {
        boolean[] visited = new boolean[g.numVertices()];
        ArrayList<LinkedList<V>> paths = new ArrayList<>();

        if (g == null || vOrig == null || vDest == null || !g.validVertex(vOrig) || !g.validVertex(vDest))
            return null;

        allPathsWithAutonomy(g, vOrig, vDest, visited, new LinkedList<>(), paths, vehicleAutonomy);
        return paths;
    }

    private static <V, E extends Comparable<E>> void allPathsWithAutonomy(Graph<V, E> g, V current, V destination, boolean[] visited, LinkedList<V> currentPath, ArrayList<LinkedList<V>> allPaths, double remainingAutonomy) {
        visited[g.key(current)] = true;
        currentPath.add(current);

        if (current.equals(destination)) {
            allPaths.add(new LinkedList<>(currentPath));
        } else {
            for (V neighbor : g.adjVertices(current)) {
                if (!visited[g.key(neighbor)]) {
                    E edgeWeight = g.edge(current, neighbor).getWeight();

                    double edgeWeightValue = Double.parseDouble(edgeWeight.toString());
                    double newRemainingAutonomy = remainingAutonomy - edgeWeightValue;

                    if (newRemainingAutonomy >= 0) {
                        LinkedList<V> newPath = new LinkedList<>(currentPath);
                        allPathsWithAutonomy(g, neighbor, destination, visited, newPath, allPaths, newRemainingAutonomy);
                    }
                }
            }
        }

        visited[g.key(current)] = false;
    }



    /**
     * Computes shortest-path distance from a source vertex to all reachable
     * vertices of a graph g with non-negative edge weights
     * This implementation uses Dijkstra's algorithm
     *
     * @param g        Graph instance
     * @param vOrig    Vertex that will be the source of the path
     * @param visited  set of previously visited vertices
     * @param pathKeys minimum path vertices keys
     * @param dist     minimum distances
     */
    private static <V, E> void shortestPathDijkstra(Graph<V, E> g, V vOrig,
                                                    Comparator<E> ce, BinaryOperator<E> sum, E zero,
                                                    boolean[] visited, V [] pathKeys, E [] dist) {

        int vkey = g.key(vOrig);
        dist[vkey] = zero;
        pathKeys[vkey] = vOrig;

        while (vOrig != null) {
            vkey = g.key(vOrig);
            visited[vkey] = true;

            for (Edge<V, E> edge : g.outgoingEdges(vOrig)) {
                int vkeyAdj = g.key(edge.getVDest());

                if (!visited[vkeyAdj]) {
                    E s = sum.apply(dist[vkey], edge.getWeight());

                    if (dist[vkeyAdj] == null || ce.compare(dist[vkeyAdj], s) > 0) {
                        dist[vkeyAdj] = s;
                        pathKeys[vkeyAdj] = vOrig;
                    }
                }
            }
            E minDist = null;  //next vertice, that has minimum dist
            vOrig = null;

            for (V vert : g.vertices()) {
                int i = g.key(vert);
                if (!visited[i] && dist[i] != null && (minDist == null || ce.compare(dist[i], minDist) < 0)) {
                    minDist = dist[i];
                    vOrig = vert;
                }
            }
        }
    }

    /**
     * Computes shortest-path distance from a source vertex to all reachable
     * @param <V>
     * @param <E>
     * @param g
     * @param vOrig
     * @param vDest
     * @param ce
     * @param sum
     * @param zero
     * @return
     */
    public static <V, E> ArrayList<LinkedList<V>> allShortestPathsDijkstra(Graph<V, E> g, V vOrig, V vDest, Comparator<E> ce, BinaryOperator<E> sum, E zero) {
        int numVertices = g.numVertices();
        boolean[] visited = new boolean[numVertices];
        E[] dist = (E[]) new Object[numVertices];
        ArrayList<LinkedList<V>>[] paths = new ArrayList[numVertices];
    
        for (int i = 0; i < numVertices; i++) {
            paths[i] = new ArrayList<>();
        }
    
        int vkey = g.key(vOrig);
        dist[vkey] = zero;
        LinkedList<V> initialPath = new LinkedList<>();
        initialPath.add(vOrig);
        paths[vkey].add(initialPath);
    
        while (vOrig != null) {
            vkey = g.key(vOrig);
            visited[vkey] = true;
    
            for (Edge<V, E> edge : g.outgoingEdges(vOrig)) {
                int vkeyAdj = g.key(edge.getVDest());
    
                if (!visited[vkeyAdj]) {
                    E s = sum.apply(dist[vkey], edge.getWeight());
    
                    if (dist[vkeyAdj] == null || ce.compare(dist[vkeyAdj], s) > 0) {
                        dist[vkeyAdj] = s;
                        paths[vkeyAdj].clear();
                        for (LinkedList<V> path : paths[vkey]) {
                            LinkedList<V> newPath = new LinkedList<>(path);
                            newPath.add(edge.getVDest());
                            paths[vkeyAdj].add(newPath);
                        }
                    } else if (ce.compare(dist[vkeyAdj], s) == 0) {
                        for (LinkedList<V> path : paths[vkey]) {
                            LinkedList<V> newPath = new LinkedList<>(path);
                            newPath.add(edge.getVDest());
                            paths[vkeyAdj].add(newPath);
                        }
                    }
                }
            }
            E minDist = null;
            vOrig = null;
    
            for (V vert : g.vertices()) {
                int i = g.key(vert);
                if (!visited[i] && dist[i] != null && (minDist == null || ce.compare(dist[i], minDist) < 0)) {
                    minDist = dist[i];
                    vOrig = vert;
                }
            }
        }
        return paths[g.key(vDest)];
    }

    /** Shortest-path between two vertices
     *
     * @param g graph
     * @param vOrig origin vertex
     * @param vDest destination vertex
     * @param ce comparator between elements of type E
     * @param sum sum two elements of type E
     * @param zero neutral element of the sum in elements of type E
     * @param shortPath returns the vertices which make the shortest path
     * @return if vertices exist in the graph and are connected, true, false otherwise
     */
    public static <V, E> E shortestPath(Graph<V, E> g, V vOrig, V vDest,
                                        Comparator<E> ce, BinaryOperator<E> sum, E zero,
                                        LinkedList<V> shortPath) {

        if (!g.validVertex(vOrig) || !g.validVertex(vDest))
            return null;

        shortPath.clear();
        int numVerts = g.numVertices();
        boolean[] visited = new boolean[numVerts];
        @SuppressWarnings("unchecked")
        V[] pathKeys = (V[]) new Object[numVerts];
        @SuppressWarnings("unchecked")
        E[] dist = (E[]) new Object[numVerts];

        for (int i = 0; i < numVerts; i++) {
            dist[i] = null;
            pathKeys[i] = null;
        }

        shortestPathDijkstra(g, vOrig, ce, sum, zero, visited, pathKeys, dist);
        E lengthPath = dist[g.key(vDest)];

        if (lengthPath == null)
            return null;

        getPath(g, vOrig, vDest, pathKeys, shortPath);

        return lengthPath;
    }



    /** Shortest-path between two vertices
     *
     * @param g graph
     * @param vOrig origin vertex
     * @param vDest destination vertex
     * @param ce comparator between elements of type E
     * @param sum sum two elements of type E
     * @param zero neutral element of the sum in elements of type E
     * @param shortPath returns the vertices which make the shortest path
     *
     * @return if vertices exist in the graph and are connected, true, false otherwise
     */
    public static <V, E> V[] shortestPathElements(Graph<V, E> g, V vOrig, V vDest, Comparator<E> ce, BinaryOperator<E> sum, E zero, LinkedList<V> shortPath) {

        if (!g.validVertex(vOrig) || !g.validVertex(vDest))
            return null;

        shortPath.clear();
        int numVerts = g.numVertices();
        boolean[] visited = new boolean[numVerts];

        @SuppressWarnings("unchecked")
        V[] pathKeys = (V[]) Array.newInstance(vOrig.getClass(), numVerts);

        @SuppressWarnings("unchecked")
        E[] dist = (E[]) Array.newInstance(zero.getClass(), numVerts);

        for (int i = 0; i < numVerts; i++) {
            dist[i] = null;
            pathKeys[i] = null;
        }

        shortestPathDijkstra(g, vOrig, ce, sum, zero, visited, pathKeys, dist);
        E lengthPath = dist[g.key(vDest)];

        if (lengthPath == null)
            return null;

        getPath(g, vOrig, vDest, pathKeys, shortPath);

        return pathKeys;
    }

    /** Shortest-path between a vertex and all other vertices
     *
     * @param g graph
     * @param vOrig start vertex
     * @param ce comparator between elements of type E
     * @param sum sum two elements of type E
     * @param zero neutral element of the sum in elements of type E
     * @param paths returns all the minimum paths
     * @param dists returns the corresponding minimum distances
     * @return if vOrig exists in the graph true, false otherwise
     */
    public static <V, E> boolean shortestPaths(Graph<V, E> g, V vOrig,
                                               Comparator<E> ce, BinaryOperator<E> sum, E zero,
                                               ArrayList<LinkedList<V>> paths, ArrayList<E> dists) {

        if (!g.validVertex(vOrig))
            return false;

        int numVerts = g.numVertices();
        boolean[] visited = new boolean[numVerts]; //default value: false
        @SuppressWarnings("unchecked")
        V[] pathKeys = (V[]) new Object[numVerts];
        @SuppressWarnings("unchecked")
        E[] dist = (E[]) new Object[numVerts];

        for (int i = 0; i < numVerts; i++) {
            dist[i] = null;
            pathKeys[i] = null;
        }

        shortestPathDijkstra(g, vOrig, ce, sum, zero, visited, pathKeys, dist);

        dists.clear();
        paths.clear();

        for (int i = 0; i < numVerts; i++) {
            paths.add(null);
            dists.add(null);
        }

        for (V vDst : g.vertices()) {
            int i = g.key(vDst);
            if (dist[i] != null) {
                LinkedList<V> shortPath = new LinkedList<>();
                getPath(g, vOrig, vDst, pathKeys, shortPath);
                paths.set(i, shortPath);
                dists.set(i, dist[i]);
            }
        }

        return true;
    }

    /**
     * Extracts from pathKeys the minimum path between voInf and vdInf
     * The path is constructed from the end to the beginning
     *
     * @param g        Graph instance
     * @param vOrig    information of the Vertex origin
     * @param vDest    information of the Vertex destination
     * @param pathKeys minimum path vertices keys
     * @param path     stack with the minimum path (correct order)
     */
    private static <V, E> void getPath(Graph<V, E> g, V vOrig, V vDest,
                                       V [] pathKeys, LinkedList<V> path) {

        if (vOrig != vDest){
            path.push(vDest);
            vDest = pathKeys[g.key(vDest)];
            getPath(g,vOrig,vDest,pathKeys,path);

        }else {
            path.push(vOrig);
        }
    }

    /** Calculates the minimum distance graph using Floyd-Warshall
     *
     * @param g initial graph
     * @param ce comparator between elements of type E
     * @param sum sum two elements of type E
     * @return the minimum distance graph
     */
    public static <V,E> MatrixGraph<V,E> minDistGraph(Graph <V,E> g, Comparator<E> ce, BinaryOperator<E> sum) {

        int numVerts = g.numVertices();
        if (numVerts == 0)
            return null;

        E[][] dist = (E[][]) new Object[g.numVertices()][g.numVertices()];

        for (int i = 0; i < numVerts; i++) {
            for (int j = 0; j < numVerts; j++) {
                Edge<V, E> e = g.edge(i, j);
                if (e != null) dist[i][j] = e.getWeight();
            }
        }

        for (int k = 0; k < numVerts; k++) {
            for (int i = 0; i < numVerts; i++) {
                if (i != k && dist[i][k] != null) {
                    for (int j = 0; j < numVerts; j++) {
                        if (j != i && j != k && dist[k][j] != null) {
                            E s = sum.apply(dist[i][k], dist[k][j]);
                            if ((dist[i][j] == null) || ce.compare(dist[i][j], s) > 0) dist[i][j] = s;
                        }
                    }
                }
            }
        }
        return new MatrixGraph<>(g.isDirected(), g.vertices(), dist);
    }

    public static <V, E> List<V> findFarthestPair(Graph<V, E> g) {
        int maxDist = Integer.MIN_VALUE;
        LinkedList<V> farthestPair = new LinkedList<>();

        for (V vertex : g.vertices()) {
            LinkedList<V> bfsResult = BreadthFirstSearch(g, vertex);

            if (bfsResult.size() > maxDist) {
                maxDist = bfsResult.size();
                farthestPair.clear();
                farthestPair.addAll(bfsResult);
            }
        }

        return farthestPair;
    }

    public static <V, E extends Comparable<E>> LinkedList<V> shortestPathWithAutonomy(Graph<V, Double> g, V vOrig, V vDest, Comparator<Double> ce, BinaryOperator<Double> sum, Double zero, double vehicleAutonomy) {
        if (!g.validVertex(vOrig) || !g.validVertex(vDest))
            return null;

        LinkedList<V> shortPath = new LinkedList<>();
        int numVerts = g.numVertices();
        boolean[] visited = new boolean[numVerts];

        @SuppressWarnings("unchecked")
        V[] pathKeys = (V[]) Array.newInstance(vOrig.getClass(), numVerts);

        Double[] dist = new Double[numVerts];
        Arrays.fill(dist, null);
        dist[g.key(vOrig)] = zero;

        PriorityQueue<AbstractMap.SimpleEntry<V, Double>> queue = new PriorityQueue<>(Comparator.comparing(AbstractMap.SimpleEntry::getValue));
        queue.add(new AbstractMap.SimpleEntry<>(vOrig, zero));

        while (!queue.isEmpty()) {
            AbstractMap.SimpleEntry<V, Double> current = queue.poll();
            V currentNode = current.getKey();
            Double currentDist = current.getValue();

            if (visited[g.key(currentNode)])
                continue;

            visited[g.key(currentNode)] = true;

            for (V neighbor : g.adjVertices(currentNode)) {
                if (!visited[g.key(neighbor)]) {
                    double newDist = currentDist + g.edge(currentNode, neighbor).getWeight();

                    // Compare with the vehicle autonomy and update newDist if necessary
                    if (newDist > vehicleAutonomy) {
                        newDist = vehicleAutonomy;
                    }

                    if (dist[g.key(neighbor)] == null || newDist < dist[g.key(neighbor)]) {
                        dist[g.key(neighbor)] = newDist;
                        pathKeys[g.key(neighbor)] = currentNode;
                        queue.add(new AbstractMap.SimpleEntry<>(neighbor, newDist));
                    }
                }
            }
        }

        getPath(g, vOrig, vDest, pathKeys, shortPath);

        return shortPath;
    }


    public static <V, E> Map.Entry<V, V> furthestVertices(Graph<V, E> g, Comparator<E> ce, BinaryOperator<E> sum) {
        int numVerts = g.numVertices();
        if (numVerts == 0) {
            return null;
        }

        E[][] dist = (E[][]) new Object[g.numVertices()][g.numVertices()];

        for (int i = 0; i < numVerts; i++) {
            for (int j = 0; j < numVerts; j++) {
                Edge<V, E> e = g.edge(g.vertices().get(i), g.vertices().get(j));
                if (e != null) {
                    dist[i][j] = e.getWeight();
                }
            }
        }

        for (int k = 0; k < numVerts; k++) {
            for (int i = 0; i < numVerts; i++) {
                if (i != k && dist[i][k] != null) {
                    for (int j = 0; j < numVerts; j++) {
                        if (j != i && j != k && dist[k][j] != null) {
                            E s = sum.apply(dist[i][k], dist[k][j]);
                            if ((dist[i][j] == null) || ce.compare(dist[i][j], s) > 0) {
                                dist[i][j] = s;
                            }
                        }
                    }
                }
            }
        }

        E maxDistance = null;
        Map.Entry<V, V> furthestVertices = null;

        for (int i = 0; i < numVerts; i++) {
            for (int j = 0; j < numVerts; j++) {
                if (dist[i][j] != null && (maxDistance == null || ce.compare(dist[i][j], maxDistance) > 0)) {
                    maxDistance = dist[i][j];
                    furthestVertices = new AbstractMap.SimpleEntry<>(g.vertices().get(i), g.vertices().get(j));
                }
            }
        }

        return furthestVertices;
    }

    public static <V, E extends Comparable<E>> LinkedList<V> shortestPathElementsWithCharging(Graph<V, E> g, V vOrig, V vDest, Comparator<E> ce, BinaryOperator<E> sum, E zero, double vehicleAutonomy) {

        if (!g.validVertex(vOrig) || !g.validVertex(vDest))
            return null;

        LinkedList<V> shortPath = new LinkedList<>();
        int numVerts = g.numVertices();
        boolean[] visited = new boolean[numVerts];

        @SuppressWarnings("unchecked")
        V[] pathKeys = (V[]) Array.newInstance(vOrig.getClass(), numVerts);

        @SuppressWarnings("unchecked")
        E[] dist = (E[]) Array.newInstance(zero.getClass(), numVerts);

        for (int i = 0; i < numVerts; i++) {
            dist[i] = null;
            pathKeys[i] = null;
        }

        shortestPathDijkstraWithCharging(g, vOrig, ce, sum, zero, visited, pathKeys, dist, vehicleAutonomy);
        E lengthPath = dist[g.key(vDest)];

        if (lengthPath == null)
            return null;

        getPath(g, vOrig, vDest, pathKeys, shortPath);

        return shortPath;
    }

    private static <V, E extends Comparable<E>> void shortestPathDijkstraWithCharging(Graph<V, E> g, V vOrig, Comparator<E> ce, BinaryOperator<E> sum, E zero, boolean[] visited, V[] pathKeys, E[] dist, double vehicleAutonomy) {

        int numVerts = g.numVertices();

        PriorityQueue<AbstractMap.SimpleEntry<V, E>> queue = new PriorityQueue<>(Comparator.comparing(AbstractMap.SimpleEntry::getValue));
        queue.add(new AbstractMap.SimpleEntry<>(vOrig, zero));

        while (!queue.isEmpty()) {
            AbstractMap.SimpleEntry<V, E> current = queue.poll();
            V currentNode = current.getKey();
            E currentDist = current.getValue();

            if (visited[g.key(currentNode)])
                continue;

            visited[g.key(currentNode)] = true;

            for (V neighbor : g.adjVertices(currentNode)) {
                if (!visited[g.key(neighbor)]) {
                    E newDist = sum.apply(currentDist, g.edge(currentNode, neighbor).getWeight());

                    // If the neighbor is a charging station, reset the remaining autonomy to the vehicle's autonomy
                    int neighborKey = g.key(neighbor);
                    if (neighborKey >= 0 && neighborKey < dist.length && dist[neighborKey] != null && ce.compare(newDist, dist[neighborKey]) > 0) {
                        newDist.equals(vehicleAutonomy);
                    }

                    if (dist[g.key(neighbor)] == null || ce.compare(newDist, dist[g.key(neighbor)]) < 0) {
                        dist[g.key(neighbor)] = newDist;
                        pathKeys[g.key(neighbor)] = currentNode;
                        queue.add(new AbstractMap.SimpleEntry<>(neighbor, newDist));
                    }
                }
            }
        }
    }
}
