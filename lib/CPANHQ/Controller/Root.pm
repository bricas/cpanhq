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

    # Hello World
    $c->response->body( $c->welcome_message );
}

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
   
}

=head2 end

Attempt to render a view, if needed.

=cut 

sub end : ActionClass('RenderView') {}

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
