package CPANHQ::Controller::Tag;

use strict;
use warnings;
use base 'Catalyst::Controller';

=head1 NAME

CPANHQ::Controller::Tag - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

sub instance :Chained('/') :PathPart(tag) :CaptureArgs(1)
{
    my ($self, $c, $tag_name) = @_;

    my $tag = $c->model('DB::Keyword')->find( { string_id => $tag_name });

    if (!$tag)
    {
        $c->res->code( 404 );
        $c->res->body( "Tag '$tag_name' not found." );
        $c->detach;
    }

    $c->stash( tag => $tag );
}

=head2 $self->show($c)

Showing a tag.

=cut

sub show :Chained(instance) :PathPart('') :Args(0)
{
    my ($self, $c) = @_;

    my $tag = $c->stash->{'tag'};

    my $distros =
        $tag->author_distros()->related_resultset('distribution');

    $c->stash(distros => $distros);

    return;
}
=head2 index 

=cut

sub index : Private {
    my ( $self, $c ) = @_;

    $c->response->body('Matched CPANHQ::Controller::Tag in Tag.');
}

=head1 AUTHOR

Shlomi Fish L<http://www.shlomifish.org/> .

=head1 LICENSE

This module is free software, available under the MIT X11 Licence:

L<http://www.opensource.org/licenses/mit-license.php>

Copyright by Shlomi Fish, 2009.

=cut

1;
