package CPANHQ::Controller::Distribution;

use strict;
use warnings;

use parent 'Catalyst::Controller';
use File::Path;
use File::Basename;
use File::Slurp;

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

sub instance :Chained('/') :PathPart('dist') :CaptureArgs(1) {
    my( $self, $c, $distname ) = @_;
    my $dist = $c->model('DB::Distribution')->find( { name => $distname }, { key => 'distribution_name' } );

    if( !$dist ) {
        $c->res->code( 404 );
        $c->res->body( "Distribution '$distname' not found." );
        $c->detach;
    }

    my $latest = $dist->latest_release;
    $latest->_process_meta_yml();

    my $uses = $dist->uses;
    my $dist_uses;
    my $graph        = Graph::Easy->new();
    while ( my $use = $uses->next ) {
        my $name = $use->dist_to->name;
        push @$dist_uses, $name;
        $graph->add_edge( $latest->distribution->name, $name, );
    }

    $c->stash(
        dist => $dist,
        release => $latest,
        title   => $latest->name,
        uses    => $dist_uses,
        graph => $graph,
    );
}

=head2 $self->show($c)

The L<Catalyst> show method.

=cut

sub show : Chained('instance') : PathPart('') :Args(0) {
    my ( $self, $c ) = @_;
    my $dist   = $c->stash->{dist};
}

sub release : Chained('instance') :PathPart('release') :CaptureArgs(1) {
    my ($self, $c, $version) = @_;

    my $dist = $c->stash->{'dist'};

    my $release = $dist->releases( { version => $version } )->first;

    $c->stash(release => $release);

    return;
}

sub graph :Chained('release') :PathPart("graph.png") :Args(0) {
    my ($self, $c) = @_;

    my $dist   = $c->stash->{dist};
    my $latest = $dist->latest_release;
    my $graph  = $c->stash->{graph};

    my $graph_output = File::Spec->catfile(
        $c->config->{'Controller::Distribution'}->{graph_path},
        $dist->name . '-' . $latest->version . '.png'
    );
    mkpath(dirname($graph_output));

    if ( !-f $graph_output ) {
        if ( open( my $png, '|-', qw(dot -Tpng -o), $graph_output ) ) {
            print $png $graph->as_graphviz;
            close($png);
        }
    }
    
    $c->serve_static_file($graph_output);

    return;
}

=head2 $self->version($c, $version)

Handles the distribution of version $version.

=cut


=begin  BlockComment

sub version :Chained('instance') :PathPart('') :Args(1) {
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

=end    BlockComment

=cut


=head1 AUTHOR

Brian Cassidy,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
