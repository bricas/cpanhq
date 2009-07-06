package CPANHQ::Controller::Package;

use strict;
use warnings;
use base 'Catalyst::Controller';

=head1 NAME

CPANHQ::Controller::Package - Catalyst Controller for Packages

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

sub instance :Chained('/') :PathPart(package) :CaptureArgs(1)
{
    my ($self, $c, $package_name) = @_;

    my $package = $c->model('DB::Package')->find( { name => $package_name });

    if (!$package)
    {
        $c->res->code( 404 );
        $c->res->body( "Package '$package_name' not found." );
        $c->detach;
    }

    $c->stash( package => $package );
}

=head2 $self->show($c)

Showing a package.

=cut

sub show :Chained(instance) :PathPart('') :Args(0)
{
    my ($self, $c) = @_;

    my $package = $c->stash->{'package'};

    my $dist = $package->distribution();

    $c->stash(dist => $dist);

    return;
}

=head2 index 

=cut

sub index : Private {
    my ( $self, $c ) = @_;

    $c->response->body('Matched CPANHQ::Controller::Package in Package.');
}

=head1 AUTHOR

Shlomi Fish L<http://www.shlomifish.org/> .

=head1 LICENSE

This module is free software, available under the MIT X11 Licence:

L<http://www.opensource.org/licenses/mit-license.php>

Copyright by Shlomi Fish, 2009.

=cut

1;
