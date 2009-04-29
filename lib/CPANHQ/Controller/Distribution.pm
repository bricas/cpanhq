package CPANHQ::Controller::Distribution;

use strict;
use warnings;

use parent 'Catalyst::Controller';

__PACKAGE__->config->{namespace} = 'dist';

=head1 NAME

CPANHQ::Controller::Distribution - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

sub instance :Chained('/') :PathPart(dist) :CaptureArgs(1) {
    my( $self, $c, $distname ) = @_;
    my $dist = $c->model('DB::Distribution')->find( { name => $distname }, { key => 'distribution_name' } );

    if( !$dist ) {
        $c->res->code( 404 );
        $c->res->body( "Distribution '$distname' not found." );
        $c->detach;
    }

    $c->stash( dist => $dist );
}

sub show :Chained(instance) :PathPart('') :Args(0) {
    my( $self, $c ) = @_;
    my $dist = $c->stash->{ dist };
    my $latest = $dist->latest_release;
    $c->stash( release => $latest, title => $latest->name );
}

sub version :Chained(instance) :PathPart('') :Args(1) {
    my( $self, $c, $version ) = @_;
    my $dist = $c->stash->{ dist };
    my $release = $dist->releases( { version => $version } )->first;

    if( !$release ) {
        $c->res->code( 404 );
        $c->res->body( $dist->name . " version '$version' not found." );
        $c->detach;
    }

    $c->stash( release => $release, title => $release->name );
}


=head1 AUTHOR

Brian Cassidy,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
