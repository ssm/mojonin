===========
 Data flow
===========

Node data
=========

Getting node data can be done with "pull" and "push".

- The "pull" model uses one or more workers which connect to the nodes
  requesting data.

- The "push" model allows nodes to submit data via the web interface.


Pull with munin protocol
------------------------

The minion connects to a munin node using a TCP socket, retrieves data
using the munin master/node protocol, and submits data to the minion
queue.

TODO: Mojolicious uses IO::Socket::IP. Look at using this in a
non-blocking manner for outgoing connections to munin nodes.


Pull with command line
----------------------

The minion executes a command, retrieves data, and submits data to the
minion queue.

Current munin master "alternative transport", STDIN/STDOUT to the
executed command emulates a TCP connection to a munin node. It uses
the munin master/node protocol.


Push
----

The web interface accept POST with node data, which submits data to
the minion queue.

This will use the /submit API endpoint.

TODO: Bikeshed submission format.


RRD update
==========

The RRD update minion reads submitted data from the minion queue, and
writes to RRD.


RRD Graph
=========

#. Mojolicious receives HTTP request for graph.

#. Graph job submitted to minion queue.

#. Graph minion picks up job, generates graph, submits result.

#. Mojolicious delivers result when minion delivers data.
