===================
 API documentation
===================

Status
======

Nodes
-----

Get status of nodes.

* List of nodes

For each node:
~~~~~~~~~~~~~~

List of plugins

Metadata

* Time of last attempted contact
* Time of last successful contact
* Connection log.

For each plugin
~~~~~~~~~~~~~~~

Config

Data

Metadata

* stdout output
* time of last config / data

Missing metadata
* Return code
* stderr output

Master
------

Get status of master.  Which minions are running, and how many.

Command
=======

Send command to minions.

* Fetch data for a selection of nodes and services.
* Fetch spooled data from node

Submit
======

* API for nodes to send data to master.  (example implementation of
  node: fetch from munin-async, format as json, post with curl)

Presentation
============

Graph
-----

Generate an RRD graph for a set of data sources.

(Default, a "service" on a "host".  This is set of data sources
configured by a plugin on a node.)

Host
----

