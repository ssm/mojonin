package Mojonin::Mojolicious::Plugin::Fetch;

use strict;
use warnings;

use Mojolicious::Plugin;
use base 'Mojolicious::Plugin';

sub register {
    my ( $plugin, $app ) = @_;

    $app->_routes;
    $app->_tasks;
}

sub _tasks {
    my $app = shift;

    $app->minion->add_task(
        fetch => sub {
            my ( $job ) = @_;

            my $data = qw{ some fake node data };
            return $app->minion->enqueue(update => $data);
        }
    );
}

sub _routes {
    my $app = shift;

    $app->routes->get('/fetch') => sub {
        my $c = shift;
        $c->minion->enqueue( fetch => { node => "foo.example.com", group => 'example.com' });
        $c->render( text => 'ok' );
    };


}

1;
