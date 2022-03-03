CREATE (VECINDARIO:Lugar {name: 'VECINDARIO'}),
       (INGENIO:Lugar {name: 'INGENIO'}),
       (ARINAGA:Lugar {name: 'ARINAGA'}),
       (LA_GARITA:Lugar {name: 'LA GARITA'}),
       (TAFIRA_ALTA:Lugar {name: 'TAFIRA ALTA'}),
       (MASPALOMAS:Lugar {name: 'MASPALOMAS'}),
       (FATAGA:Lugar {name: 'FATAGA'}),
       (TEJEDA:Lugar {name: 'TEJEDA'}),
       (LOMO_ESPINO:Lugar {name: 'LOMO ESPINO'}),
       (CAZADORES:Lugar {name: 'CAZADORES'}),
       (LA_GALERA:Lugar {name: 'LA GALERA'}),

       (VECINDARIO)-[:COCHE {km: 14.3}]->(INGENIO),
       (VECINDARIO)-[:COCHE {km: 6.5}]->(ARINAGA),
       (VECINDARIO)-[:COCHE {km: 20.8}]->(LA_GARITA),
       (VECINDARIO)-[:COCHE {km: 21.9}]->(MASPALOMAS),

       (INGENIO)-[:COCHE {km: 15.2}]->(VECINDARIO),
       (INGENIO)-[:COCHE {km: 14.6}]->(ARINAGA),
       (INGENIO)-[:COCHE {km: 17.2}]->(LA_GARITA),
       (INGENIO)-[:COCHE {km: 13.2}]->(CAZADORES),

       (ARINAGA)-[:COCHE {km: 6.5}]->(VECINDARIO),
       (ARINAGA)-[:COCHE {km: 14.6}]->(INGENIO),
       (ARINAGA)-[:COCHE {km: 20.2}]->(LA_GARITA),

       (LA_GARITA)-[:COCHE {km: 21.7}]->(VECINDARIO),
       (LA_GARITA)-[:COCHE {km: 16.4}]->(INGENIO),
       (LA_GARITA)-[:COCHE {km: 21}]->(ARINAGA),
       (LA_GARITA)-[:COCHE {km: 15.3}]->(TAFIRA_ALTA),
       (LA_GARITA)-[:COCHE {km: 22.6}]->(LOMO_ESPINO),
       (LA_GARITA)-[:COCHE {km: 19}]->(LA_GALERA),

       (TAFIRA_ALTA)-[:COCHE {km: 13.5}]->(LA_GARITA),
       (TAFIRA_ALTA)-[:COCHE {km: 30.4}]->(TEJEDA),
       (TAFIRA_ALTA)-[:COCHE {km: 13.1}]->(LA_GALERA),

       (MASPALOMAS)-[:COCHE {km: 23.7}]->(VECINDARIO),
       (MASPALOMAS)-[:COCHE {km: 17.9}]->(FATAGA),

       (FATAGA)-[:COCHE {km: 17.7}]->(MASPALOMAS),
       (FATAGA)-[:COCHE {km: 31.2}]->(TEJEDA),

       (TEJEDA)-[:COCHE {km: 30.9}]->(FATAGA),
       (TEJEDA)-[:COCHE {km: 20.9}]->(LOMO_ESPINO),
       (TEJEDA)-[:COCHE {km: 22.8}]->(CAZADORES),

       (LOMO_ESPINO)-[:COCHE {km: 22.1}]->(LA_GARITA),
       (LOMO_ESPINO)-[:COCHE {km: 9.6}]->(TAFIRA_ALTA),
       (LOMO_ESPINO)-[:COCHE {km: 20.9}]->(TEJEDA),

       (CAZADORES)-[:COCHE {km: 26.3}]->(INGENIO),
       (CAZADORES)-[:COCHE {km: 23.3}]->(TEJEDA),

       (LA_GALERA)-[:COCHE {km: 18.5}]->(LA_GARITA),
       (LA_GALERA)-[:COCHE {km: 9.6}]->(TAFIRA_ALTA)

CALL gds.graph.create(
    'miGrafo',
    'Lugar',
    'COCHE',
    {
        relationshipProperties: 'km'
    }
)

MATCH (source:Lugar {name: 'VECINDARIO'}), (target:Lugar {name: 'TEJEDA'})
CALL gds.shortestPath.dijkstra.stream('miGrafo', {
    sourceNode: source,
    targetNode: target,
    relationshipWeightProperty: 'km'
})
YIELD index, sourceNode, targetNode, totalCost, nodeIds, costs, path
RETURN
    index,
    gds.util.asNode(sourceNode).name AS sourceNodeName,
    gds.util.asNode(targetNode).name AS targetNodeName,
    totalCost,
    [nodeId IN nodeIds | gds.util.asNode(nodeId).name] AS nodeNames,
    costs,
    nodes(path) as path
ORDER BY index

MATCH (source:Lugar {name: 'FATAGA'}), (target:Lugar {name: 'TAFIRA ALTA'})
CALL gds.shortestPath.dijkstra.stream('miGrafo', {
    sourceNode: source,
    targetNode: target,
    relationshipWeightProperty: 'km'
})
YIELD index, sourceNode, targetNode, totalCost, nodeIds, costs, path
RETURN
    index,
    gds.util.asNode(sourceNode).name AS sourceNodeName,
    gds.util.asNode(targetNode).name AS targetNodeName,
    totalCost,
    [nodeId IN nodeIds | gds.util.asNode(nodeId).name] AS nodeNames,
    costs,
    nodes(path) as path
ORDER BY index