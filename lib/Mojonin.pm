package Mojonin;
use Mojo::Base 'Mojolicious';

# This method will run once at server start
sub startup {
    my $app = shift;

    $app->_plugins;
    $app->_routes;
}

sub _plugins {
    my $app = shift;

    $app->plugin( 'Config' => file => $ENV{MOJO_CONFIG}
                    || $app->home->rel_file('mojonin.conf') );

    $app->plugin( 'Minion', File => $app->home->rel_file('minion.db') );
    $app->plugin('Mojonin::Mojolicious::Plugin::Fetch');
    $app->plugin('Mojonin::Mojolicious::Plugin::Update');

}

sub _routes {
    my $app = shift;

    $app->routes->get('/')->to('dashboard#welcome');

    $app->routes->get('/group')->to('page#group');
    $app->routes->get('/host')->to('page#host');
    $app->routes->get('/service')->to('page#service');

    $app->routes->any([qw(GET POST)] => '/submit')->to(controller => 'NodeData', action => 'submit');
}
1;
