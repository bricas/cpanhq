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
    $c->stash( form => $form, title => 'Login' );

    return unless $form->was_submitted && $form->is_valid;

    my $consumer = Net::OpenID::Consumer->new(
        ua => LWPx::ParanoidAgent->new,
        args => $c->req->params,
        consumer_secret => sub { $_[0] },
    );

    my $identity = $consumer->claimed_identity( $form->field_value( 'claimed_uri' ) );
    my $url = $identity->check_url(
        return_to  => $c->uri_for('/authenticate/openid'),
        trust_root => $c->uri_for('/'),
        delayed_return => 1,
    );

    $c->res->redirect( $url );
}

=head2 $self->openid($c)

Login using OpenID.

=cut

sub openid : Path('openid') Args(0) {
    my( $self, $c ) = @_;

    if( !$c->req->params->{ 'openid.identity' } ) {
        $c->res->redirect( $c->uri_for( '/login' ) );
        return;
    }

    my $consumer = Net::OpenID::Consumer->new(
        ua => LWPx::ParanoidAgent->new,
        args => $c->req->params,
        consumer_secret => sub { $_[0] },
    );

    if ( my $setup = $consumer->user_setup_url ) {
        $c->res->redirect( $setup );
    }
    elsif ($consumer->user_cancel) {
        $c->res->redirect( $c->uri_for( '/login' ) );
    }
    elsif ( my $identity = $consumer->verified_identity ) {
        $c->authenticate( { enabled => 1, openid => $identity->url }, 'openid' );
        $c->res->redirect( $c->uri_for( '/' ) );
    }
    else {
        Catalyst::Exception->throw('Error validating identity: ' . $consumer->errtext);
    }
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
