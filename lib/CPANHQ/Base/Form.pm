package CPANHQ::Base::Form;

use strict;
use warnings;

=head1 NAME

CPANHQ::Base::Form - a form component of CPANHQ

=head1 SYNOPSIS

None.

=head1 DESCRIPTION

This is a form component for L<CPANHQ> inheriting from L<Rose::HTML::Form>.

=head1 METHODS

=cut

use parent 'Rose::HTML::Form';

=head2 __PACKAGE__->COMPONENT()

Initialize a new component.

=cut

sub COMPONENT {
    return shift->new;
}

=head2 $self->ACCEPT_CONTEXT($c)

Initializes the instance.

=cut

sub ACCEPT_CONTEXT {
    my ( $self, $c, @args ) = @_;

    $self->reset;
    $self->app( $c );
    $self->params( $c->req->params );
    $self->init_fields();

    return $self;
}

=head2 $self->is_valid( %params )

Calls L<Rose::HTML::Form> 's validate().

=cut

sub is_valid {
    return shift->validate( @_ );
}

=head2 $self->was_submitted()

Determines if the form was submitted.
`
=cut

sub was_submitted {
    my $self = shift;
    return lc $self->app->req->method eq $self->method;
}

=head2 $self->render()

Renders the form.

=cut

sub render {
    my $self   = shift;
    my $output = '';

    if ( $self->error ) {
        $output .= $self->xhtml_error;
    }

    $output .= $self->start_xhtml;

    for my $field ( map { $self->field( $_ ) } $self->field_names_by_rank ) {
        $output .= $field->xhtml_label . $field->xhtml;
    }

    $output .= $self->end_xhtml;
    return $output;
}

=head2 $self->field_names_by_rank()

Return the names of the fields ordered by their ->rank().

=cut

sub field_names_by_rank {
    my $self = shift;
    return map { $_->name }
        sort   { $a->rank <=> $b->rank } $self->fields;
}

1;

=head1 SEE ALSO

L<CPANHQ>, L<Rose::HTML::Form>, L<Catalyst>

=head1 AUTHOR

Brian Cassidy E<lt>bricas@cpan.orgE<gt>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

