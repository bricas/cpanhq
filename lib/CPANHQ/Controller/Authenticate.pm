package CPANHQ::Controller::Authenticate;

use strict;
use warnings;

use parent qw(  Catalyst::Controller );

use Net::OpenID::Consumer;
use LWPx::ParanoidAgent;

sub login : Path('/login') Args(0) {
    my ( $self, $c ) = @_;
    my $form = $c->form( 'Login' );
    $c->stash( form => $form );

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

sub logout : Path('/logout') Args(0) {
    my ( $self, $c ) = @_;

    $c->logout;
    $c->res->redirect( $c->uri_for( '/' ) );
}

1;
