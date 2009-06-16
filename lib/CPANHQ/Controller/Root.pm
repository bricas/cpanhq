package CPANHQ::Controller::Root;

use strict;
use warnings;

use parent 'Catalyst::Controller';
use XML::RSS;
use LWP::Simple qw(get);

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

    my $rss = XML::RSS->new;

=begin TwitterElimination
    # Getting rid of the Twitter feed, because:
    #
    # 1. Twitter is down at the moment.
    #
    # 2. It returns an HTTP error code of 200 ("OK") with a weirdo XML
    # instead of 4xx/5xx.
    #
    # 3. It makes the CPANHQ server slow.
    #
    # 4. It emits a warning.

    my $content = get(
        'http://twitter.com/statuses/user_timeline/36758099.rss'
    );

    if (defined($content)) {
        $rss->parse( $content );
    }

=end TwitterElimination

=cut

    $c->stash( tweets => $rss );
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
