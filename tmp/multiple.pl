#!/usr/bin/perl

package Multiple
use Mojo::Base '-base';
use Mojo::IOLoop;
use Mojo::Log;

my $log = Mojo::Log->new;

my $delay = Mojo::IOLoop->delay(
    sub {
        my ($delay, @streams) = @_;

        while (scalar @streams) {
            my $err = shift @streams;
            my $stream = shift @streams;

            if ($err) {
                $log->error($err);
            }
            else {
                $delay->pass($stream);
            }
        }
    },
);

sub new {

}
my $nodes = [
    {port => 4949},
    {port => 4948},
    {address => '::1', port => 4949},
    {address => '127.0.0.1', port => 4949},
];

foreach my $node (@{$nodes}) {
    my $id = Mojo::IOLoop->client($node => $delay->begin);
    say "$id";
}

$delay->wait;

package main;

Multiple->new();
