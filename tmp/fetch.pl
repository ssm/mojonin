#!/usr/bin/perl
use Mojo::Base 'Mojo::EventEmitter';
use Mojo::IOLoop;

my $delay = Mojo::IOLoop->delay(

    # Check connections
    sub {
        my ( $delay, $loop, $err, $stream ) = @_;
        die $err if $err;
        $delay->pass($stream);
    },

    # Register stream hooks
    sub {
        my ( $delay, $stream ) = @_;
        $stream->on(
            error => sub {
                my ( $self, $message ) = @_;
                say "[ERROR] $message";
            }
        );

        $stream->on(
            write => sub {
                my ( $self, $message ) = @_;
                say ">> $message";
            }
        );
        $delay->pass($stream);
    },

    # Read banner, get hostname
    sub {
        my ( $delay, $stream ) = @_;
        my $end = $delay->begin(0);

        $stream->on(
            read => sub {
                my ( $stream, $bytes ) = @_;
                $stream->unsubscribe('read');
                chomp $bytes;
                say "<< $bytes";
                if ( $bytes =~ /munin node at (.*)/ ) {
                    $delay->data( { hostname => $1 } );
                    $end->($stream);
                }
                else {
                    die "protocol error (banner)\n";
                }
            }
        );
    },

    # Send "cap" command
    sub {
        my ( $delay, $stream ) = @_;
        $stream->write(
            "cap dirtyconfig multigraph\n" => $delay->begin(0)->($stream) );
    },

    # Read capabilities
    sub {
        my ( $delay, $stream ) = @_;
        my $end = $delay->begin(0);

        $stream->on(
            read => sub {
                my ( $stream, $bytes ) = @_;
                $stream->unsubscribe('read');
                chomp $bytes;
                say "<< $bytes";
                if ( $bytes =~ /cap (.*)/ ) {
                    my @capabilities = split( /\s+/, $1 );
                    $delay->data( { capabilities => \@capabilities } );
                    $end->($stream);
                }
                else {
                    die "protocol error (cap)\n";
                }
            }
        );
    },

    # Send "list" command
    sub {
        my ( $delay, $stream ) = @_;
        $stream->write("list\n" => $delay->begin(0)->($stream));
    },

    # Read list of plugins
    sub {
        my ( $delay, $stream ) = @_;
        my $end = $delay->begin(0);

        $stream->on(
            read => sub {
                my ( $stream, $bytes ) = @_;
                $stream->unsubscribe('read');
                chomp $bytes;
                say "<< $bytes";
                my @plugins = split( /\s+/, $bytes );
                $delay->data( { plugins => \@plugins } );
                $end->($stream);
            }
        );
    },

    # Finish
    sub {
        my ( $delay, $stream ) = @_;
        $stream->write("exit\n" => $delay->begin);
    },

    # Summary
    sub {
        my ($delay) = @_;
        say "Blah, blah, blah";
        say "----------------";
        say "Hostname:     " . $delay->data('hostname');
        say "Capabilities: " . join(', ', @{$delay->data('capabilities')});
        say "Plugins:      " . join(', ', @{$delay->data('plugins')});

    }
  );

Mojo::IOLoop->client( { port => 4949 } => $delay->begin(0) );
$delay->wait;

# Mojo::IOLoop->start unless Mojo::IOLoop->is_running;
