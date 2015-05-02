package Mojonin::Mojolicious::Plugin::Update;

use strict;
use warnings;

use Mojolicious::Plugin;
use base 'Mojolicious::Plugin';

sub register {
    my ( $plugin, $app ) = @_;

    $app->minion->add_task(
        update => sub {
            my ( $job ) = @_;
            # TODO: For each plugin / data source:
            # * Store config
            # * Store data with RRD Update.
            # * Check limits, and queue for notification.
            1;
        }
    );
}
1;
