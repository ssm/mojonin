package Mojonin;
use Mojo::Base 'Mojolicious';

# This method will run once at server start
sub startup {
    my $app = shift;

    $app->plugin( 'Config' => file => $ENV{MOJO_CONFIG}
          || $app->home->rel_file('mojonin.conf') );

    # Minion plugin
    $app->plugin( 'Minion', File => 'minion.db' );

    $app->_routes;
}

sub _routes {
    my $app = shift;

    $app->routes->get('/') - to('dashboard#welcome');

}
1;
