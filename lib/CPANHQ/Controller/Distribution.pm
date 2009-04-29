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

sub show :Path :Args(1) {
    my( $self, $c, $distname ) = @_;
    my $dist = $c->model('DB::Distribution')->find( { name => $distname }, { key => 'distribution_name' } );

    if( !$dist ) {
        $c->res->code( 404 );
        $c->res->body( "Distribution '$distname' not found." );
        return;
    }

    $c->stash->{ dist } = $dist;
    my $latest = $dist->latest_release;
    $c->stash->{ latest_release } = $latest;
    $c->stash->{ title } = $latest->name;
}


=head1 AUTHOR

Brian Cassidy,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
