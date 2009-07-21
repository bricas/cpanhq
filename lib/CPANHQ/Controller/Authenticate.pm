package CPANHQ::Controller::Authenticate;

use strict;
use warnings;

use parent qw(  Catalyst::Controller );

use Net::OpenID::Consumer;
use LWPx::ParanoidAgent;


=head1 NAME

CPANHQ::Controller::Authenticate - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=head2 $self->login($c)

Login using OpenID.

=cut

sub login : Path('/login') Args(0) {
    my ( $self, $c ) = @_;
    my $form = $c->form( 'Login' );

    if( $c->authenticate ) {
        $c->res->redirect( $c->uri_for('/') );
        return;
    }

    $c->stash( form => $form, title => 'Login' );
}

=head2 $self->logout($c)

Logout from the system.

=cut

sub logout : Path('/logout') Args(0) {
    my ( $self, $c ) = @_;

    $c->logout;
    $c->res->redirect( $c->uri_for( '/' ) );
}

=head1 AUTHOR

Brian Cassidy,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
