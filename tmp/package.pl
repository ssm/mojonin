#!/usr/bin/perl

package Mojonin::Client;
use Mojo::Base 'Mojo::EventEmitter';
use Mojo::IOLoop;

has 'address' => 'localhost';
has 'port'    => 4949;

has 'state' => 'disconnected';

has 'stream';

sub new {
    my $class = shift;
    my $self  = $class->SUPER::new(@_);

    $self->_connect;

    $self;
}

sub _connect {
    my ( $self, $cb ) = @_;

    $self->{client}->on(
        connect => sub {
            my ( $client, $handle ) = @_;
            $self->state('connected');
            $self->_seq( 'connect', $cb );
        }
    );
}

sub fetch {
    my ( $self, @plugins ) = @_;
}

package main;

my $c       = Mojonin::Client->new();
# my $plugins = $c->plugins();
# my $results = $c->fetch();
