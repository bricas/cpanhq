package CPANHQ::Form::Login;

use strict;
use warnings;

=head1 NAME

CPANHQ::Form::Login - the CPANHQ login form.

=head1 SYNOPSIS

None.

=head1 DESCRIPTION

This is the L<CPANHQ> login form.

=head1 METHODS

=cut

use parent qw( CPANHQ::Base::Form );

=head2 $self->build_form()

Builds the form.

=cut

sub build_form {
    my $self = shift;

    $self->add_fields( claimed_uri => { type => 'text', size => 40, required => 1 }, submit => { type => 'submit', value => 'Login' } );
    $self->method( 'post' );

    return $self;
}

1;

=head1 SEE ALSO

L<CPANHQ>, L<CPANHQ::Base::Form> .

=head1 AUTHOR

Brian Cassidy E<lt>bricas@cpan.orgE<gt>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

