package Mojonin::Controller::NodeData;
use Mojo::Base 'Mojolicious::Controller';
use Mojo::JSON qw(decode_json);

=head1 NAME

NodeData - Controller for data from munin nodes

=head1 SYNOPSIS

    $r->any(qw[GET POST] => '/submit')->to('nodedata#submit')

=head1 DESCRIPTION

Receive plugin data.  Arguments:

=over

=item data

json string with plugin configuration and data.  Format example:a

    [{
      'group': 'example.com',
      'host': 'foo.example.com',
      'services': [
         { 'name': 'cpu',
           'config': ['array', 'of', 'config', 'lines'],
           'data': ['array', 'of', 'data', 'lines']
         }
      ]
    }]

=back

=cut

sub submit {
    my $self = shift;

    my $validation = $self->validation;
    return $self->render unless $validation->has_data;

    # Validate parameters
    $validation->required('data');
    return $self->render if $validation->has_error();

    $self->delay(
        # decode json
        sub {
            my $delay = shift;
            my $data = decode_json($validation->param('data'));
            $delay->pass( $validation->param('data') );
        },

        # submit to queue
        sub {
            my ($delay, $submission) = @_;
            $self->minion->enqueue('update', $submission);
            $delay->pass();
        },

        sub {
            $self->render( text => 'ok' )
        },
    );

}

1;
