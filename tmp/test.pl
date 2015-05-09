#!/usr/bin/perl

use Mojo::Base 'Mojo::EventEmitter';
use Mojo::IOLoop;
use Scalar::Util 'weaken';

my $delay = Mojo::IOLoop->delay(
    sub {
        my ($delay, $loop, $err, $stream) = @_;
        $delay->pass($stream)
    },

    sub {
        my ($delay, $stream) = @_;
        my $end = $delay->begin(0);

        # imaginary async call
        $stream->on(
            read => sub {
                my ( $stream, $bytes ) = @_;
                say $bytes;
                $end->($stream);
            }
        );

    },

    sub {
        my ($delay, $stream) = @_;
        my $end = $delay->begin(0);
        $stream->write("list\n" => $end->($stream));
    },

    sub {
        my ($delay, $stream) = @_;
        my $end = $delay->begin(0);
        $stream->on(
            read => sub {
                my ( $stream, $bytes ) = @_;
                $end->($stream);
            }
        );
    },

);

Mojo::IOLoop->client( { port => 4949 } => $delay->begin(0) );
$delay->wait;

sub _make_stream {
    my ($self, $sock, $loop) = @_;
    weaken $self;

    $self->{stream} = Mojo::IOLoop::Stream->new($sock);
    $self->{stream}->reactor($loop->reactor);
    $self->{stream}->start;
}

sub _send_command {
    my ($self, $cb, $command) = @_;
}

sub _read_banner {
    my ($self, $cb) = @_;
}
sub _read_response {
    my ($self, $cb, $last) = @_;
    $self->{stream}->timeout($self->inactivity_timeout);
    my $resp = '';

    $self->{stream}->on(
        read => sub {
            $resp .= $_[-1];
            if ($resp =~ /^\.$/sm) {
                $self->{stream}->unsubscribe('read');
                $cb->($self, $resp);
            }
        }
    );
}
