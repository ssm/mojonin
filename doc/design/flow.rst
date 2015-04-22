==================
 Information flow
==================

Node data
=========

Pull
----

Fetch minion connects to node, and submits data to the minion queue.


Push
----

Web interface accept POST with node data, which submits data to the
minion queue.


RRD update
==========

Update minion reads submitted data from queue, and writes to RRD.


RRD Graph
=========

#. Mojolicious receives HTTP request for graph.

#. Graph job submitted to minion queue.

#. Graph minion picks up job, generates graph, submits result.

#. Mojolicious delivers result when minion delivers data.
