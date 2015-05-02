package Mojonin::Controller::Page;
use Mojo::Base 'Mojolicious::Controller';

sub group {
    my $self = shift;
    $self->render(json => []);
}

sub host {
  my $self = shift;
  $self->render(json => [] );
}

sub service {
    my $self = shift;
    $self->render(json => [] );
}
1;
