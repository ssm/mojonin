===================
 API documentation
===================

document vs query parameters
============================

Document
--------

The document path determines the controller and the method in the
controller.  What kind of result are we looking for.  This is the api
endpoints.

Parameters
----------

The query parameter is the filter used to find the data to display.
The list of parameters pondered so far is:

* host, a comma separated list of host names.  This value is combined
  with group and service with AND to make a filter.

* group: a comma separated list of groups. This value is combined with
  host and service with AND to make a filter.

* service: a comma separated list of services. This value is combined
  with host and service with AND to make a filter.

* fqn: a comma separated list of fully qualified names on the format
  group:host;service

* time: a timestamp to center the data around.

* time_from: a timestamp for the start of the graph.

* time_to: a timestamp for the end of the graph.

* time_period: a period name, like "minute", "hour", "day", "week",
  "forthnight", "month", "year". Combines with _one_ of time,
  time_from or time_to.

TODO: Does adding host_id, group_id, service_id makes sense.  It
probably does, if you want to refer to a single host, and not search
for a match.

TODO: Does all parameters make sense for all api endpoints?  the
"time" parameters are obvious for graphing, but for selecting hosts,
do we show all hosts which checked in during that time?


Time formats
~~~~~~~~~~~~

Time is parsed with http://mojolicio.us/perldoc/Mojo/Date#parse, which
handles many formats.

Recommended time format in code, documentation and examples is defined
by RFC 3339.  Example: "1994-11-06T08:49:37Z".


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

