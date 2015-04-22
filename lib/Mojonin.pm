package Mojonin;
use Mojo::Base 'Mojolicious';

# This method will run once at server start
sub startup {
  my $self = shift;

  # Minion plugin
  $self->plugin('Minion', File => 'minion.db' );

  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->get('/')->to('dashboard#welcome');
}

1;
