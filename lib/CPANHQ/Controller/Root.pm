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

=head2 auto

=cut

sub auto : Private {
    my( $self, $c ) = @_;

    my $content;

    # We cache the tweets.html-portion. It should be updated using
    # tmp/gen-twitter-feed.pl using a cron job.
    {
        local $/;
        open my $in, "<", "root/static/tweets.html-portion";
        binmode $in, ":utf8";
        $content = <$in>;
        close($in);
    }
    $c->stash( tweets_html => $content );
    return 1;
}

=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
    return;
}

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

sub recent :Path('recent') {
    my ( $self, $c ) = @_;
    $c->stash->{ releases } = $c->model( 'DB::Release' )->search( {}, { rows => 50 } );
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
