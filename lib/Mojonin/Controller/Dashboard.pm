package Mojonin::Controller::Dashboard;
use Mojo::Base 'Mojolicious::Controller';

# This action will render a template
sub welcome {
  my $self = shift;

  # Render template "dashboard/welcome.html.ep" with reassuring message
  $self->render(msg => 'Everything in order. Go back to your coffee.');
}

1;
