package Mojonin::Mojolicious::Plugin::Fetch;

use strict;
use warnings;

use Mojolicious::Plugin;
use base 'Mojolicious::Plugin';

sub register {
    my ( $plugin, $app ) = @_;

    $app->_routes;

    $app->minion->add_task(
        fetch => sub {
            my ( $job ) = @_;
            $app->log->debug('starting fetch');
            $app->minion->enqueue(update => ['fake data']);
            1;
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

sub _
1;
