==================
 Information flow
==================

Data update
===========

Direct
------

* Fetch minion connects to node, and writes data retrieved to RRD.

Pros: simple

Cons: what about push?

Indirect
--------

* Fetch minion connects to node, and writes data to queue.

* Node connects to web API, and submits data.  Web service writes data
  retrieved to queue.

* Storage minion reads data from queue, and writes to RRD.


Graph
=====

* Mojolicious receives request for graph.

* Graph job submitted to queue.

* Graph minion picks up job, generates graph, submits result.

* Mojolicious delivers result.


