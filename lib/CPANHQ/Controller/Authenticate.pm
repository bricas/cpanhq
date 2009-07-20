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
    $form->action($c->uri_for('/authenticate/openid'));
    $c->stash( form => $form, title => 'Login' );

    return;

=begin Hello 
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
=end Hello

=cut

}

=head2 $self->openid($c)

Login using OpenID.

=cut

sub openid : Path('openid') Args(0) {
    my( $self, $c ) = @_;

    if ($c->authenticate({}, "openid"))
    {
        $c->persist_user();
        $c->flash(message => "You signed in with OpenID!");
        $c->res->redirect( $c->uri_for('/') );
    }
    else
    {
        $c->flash(message => "Could not authenticate with OpenID");
        $c->response->body( "Could not authenticate with OpenID" );        
        # $c->flash(message => "Could not authenticate with OpenID");
        # $c->response->body( "Could not authenticate with OpenID" );
        # Catalyst::Exception->throw(
        #    'Error validating identity: '
        # );
    }
    return;
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
