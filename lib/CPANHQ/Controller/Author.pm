package CPANHQ::Controller::Author;

use strict;
use warnings;
use parent 'Catalyst::Controller';

=head1 NAME

CPANHQ::Controller::Author - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=head2 $self->show($c, $cpanid)

The L<Catalyst> show() method.

=cut

sub show :Path :Args(1) {
    my ( $self, $c, $cpanid ) = @_;

    my $author = $c->model('DB::Author')->find( { cpanid => uc $cpanid }, { key => 'author_cpanid' } );

    if( !$author ) {
        $c->res->code( 404 );
        $c->res->body( "Author '$cpanid' not found." );
    }

    $c->stash( author => $author );
}


=head1 AUTHOR

Brian Cassidy,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
