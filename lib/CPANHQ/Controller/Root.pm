package CPANHQ::Controller::Root;

use strict;
use warnings;

use parent 'Catalyst::Controller';

__PACKAGE__->config->{namespace} = '';

=head1 NAME

CPANHQ::Controller::Root - Root Controller for CPANHQ

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=cut

=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
    return;
}

=head2 $self->default($c, @path)

The default handler for paths.

=cut

sub default :Path {
    my ( $self, $c, @args ) = @_;

    $args[ -1 ] .= '.tt';
    if( -e $c->path_to( 'root', @args ) ) {
        $c->stash( template => join( '/', @args ) );
        return;
    }

    $c->response->body( 'Page not found' );
    $c->response->status(404);
   
}

=head2 $self->recent($c)

Handles the recent releases.

=cut

sub recent :Path('recent') {
    my ( $self, $c ) = @_;
    $c->stash->{ releases } = $c->model( 'DB::Release' )->search( {}, { rows => 50 } );
}

=head2 end

Attempt to render a view, if needed.

=cut 

sub end : ActionClass('RenderView') {}

=head2 $self->access_denied($c, $action)

Returns an access denied page.

=cut

sub access_denied : Private {
    my( $self, $c, $action ) = @_;

    if( !$c->user_exists ) {
        $c->redirect( '/login' );
        return;
    }

    # non-fatal
    if ( $action eq $c->controller('Authenticate')->action_for('login') ) {
        $c->res->redirect( '/' );
        return;
    }

    die 'access denied'; # TODO
}

=head1 AUTHOR

Brian Cassidy E<lt>bricas@cpan.orgE<gt>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
