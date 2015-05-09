#!/usr/bin/perl
use Mojo::Base '-base';
use Mojo::IOLoop;
use Mojo::Log;

my $log = Mojo::Log->new();
$log->format(
    sub {
        my ( $time, $level, @lines ) = @_;
        return sprintf( "[%s] %s\n", $level, join( "\n", @lines ) );
    }
);

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
                $log->error($message);
            }
        );

        $stream->on(
            write => sub {
                my ( $self, $message ) = @_;
                chomp $message;
                $log->debug(">> $message");
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
                $log->debug("<< $bytes");
                if ( $bytes =~ /^# munin node at (\S+)$/sm ) {
                    $delay->data( { hostname => $1 } );
                }
                else {
                    die "protocol error (banner)\n";
                }
                $end->($stream);
            }
        );
    },

    # Send "cap" command
    sub {
        my ( $delay, $stream ) = @_;
        my $end = $delay->begin(0);

        $stream->write( "cap dirtyconfig multigraph\n" => $end->($stream) );
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
                $log->debug("<< $bytes");
                if ( $bytes =~ /cap (.*)/ ) {
                    my @capabilities = split( /\s+/, $1 );
                    $delay->data( { capabilities => \@capabilities } );
                }
                else {
                    $log->debug('no capabilities');
                }
                $end->($stream);
            }
        );
    },

    # Send "list" command
    sub {
        my ( $delay, $stream ) = @_;
        $stream->write( "list\n" => $delay->begin(0)->($stream) );
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
                $log->debug("<< $bytes");
                my @plugins = split( /\s+/, $bytes );
                $delay->data( { plugins => \@plugins } );
                $end->($stream);
            }
        );
    },

    # Get config
    sub {
        my ( $delay, $stream ) = @_;
        my $end     = $delay->begin(0);

        my @plugins = sort @{ $delay->data('plugins') };
        $log->debug( 'Looping over ' . scalar @plugins . ' plugins' );

        my @subs;

        foreach my $plugin (@plugins) {

            push @subs, sub {
                my ($delay, $stream, $plugin) = @_;
                $log->debug( ref $delay );
                my $end = $delay->begin(0);
                $stream->write("config ${plugin}\n") => $end->($stream);
            };

            push @subs, sub {
                my ( $delay, $stream ) = @_;
                my $end = $delay->begin(0);

                my $response = '';

                $stream->on(
                    read => sub {
                        my ( $stream, $bytes ) = @_;
                        $response .= $bytes;
                        if ($bytes =~ m/^\.$/smx) {
                            $stream->unsubscribe('read');
                            $log->debug("<< $response");
                            $end->($stream);
                        }
                    }
                );
            }
        }

        my $p = Mojo::IOLoop->delay(@subs);
        $p->begin($stream);
        $p->wait;

        $end->($stream);
    },

    # Finish
    sub {
        my ( $delay, $stream ) = @_;
        $stream->write( "exit\n" => $delay->begin(0) );
    },

    # Summary
    sub {
        my ($delay) = @_;
        say "Blah, blah, blah";
        say "----------------";
        say "Hostname:     " . $delay->data('hostname');
        say "Capabilities: "
            . join( ', ', @{ $delay->data('capabilities') } );
        say "Plugins:      "
            . join( ', ', sort @{ $delay->data('plugins') } );

    }
);

Mojo::IOLoop->client( { port => 4949 } => $delay->begin(0) );
Mojo::IOLoop->client( { port => 4949 } => $delay->begin(0) );
$delay->wait;

# Mojo::IOLoop->start unless Mojo::IOLoop->is_running;
