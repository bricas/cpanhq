package CPANHQ::Controller::Distribution;

use strict;
use warnings;

use parent 'Catalyst::Controller';
use Graph::Easy;

__PACKAGE__->config->{namespace} = 'dist';

=head1 NAME

CPANHQ::Controller::Distribution - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=head2 $self->instance($c, $distname)

Initialises an instance of the distname distribution upon accessing
C</dist/MyDistro-On-CPAN/> .

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

=head2 $self->show($c)

The L<Catalyst> show method.

=cut

sub show : Chained(instance) : PathPart('') : Args(0) {
    my ( $self, $c ) = @_;
    my $dist   = $c->stash->{dist};
    my $latest = $dist->latest_release;
    $latest->_process_meta_yml();

    my $graph = Graph::Easy->new();

    my $uses = $dist->uses;
    my $dist_uses;
    while ( my $use = $uses->next ) {
        my $name = $use->dist_to->name;
        push @$dist_uses, $name;
        $graph->add_edge(
            $latest->distribution->name,
            $name,
        );
    }
    my $graph_output = $graph->as_ascii();
    $c->stash(
        release => $latest,
        title   => $latest->name,
        graph   => $graph_output,
        uses    => $dist_uses,
    );
}

=head2 $self->version($c, $version)

Handles the distribution of version $version.

=cut

sub version :Chained(instance) :PathPart('') :Args(1) {
    my( $self, $c, $version ) = @_;
    my $dist = $c->stash->{ dist };
    my $release = $dist->releases( { version => $version } )->first;

    if( !$release ) {
        $c->res->code( 404 );
        $c->res->body( $dist->name . " version '$version' not found." );
        $c->detach;
    }

    $release->_process_meta_yml();

    $c->stash( release => $release, title => $release->name );
}


=head1 AUTHOR

Brian Cassidy,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
