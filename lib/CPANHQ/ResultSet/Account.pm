package CPANHQ::ResultSet::Account;

use strict;
use warnings;

use base qw( DBIx::Class::ResultSet );

sub auto_create {
    my ( $self, $authinfo ) = @_;
    $self->create( { openid => $authinfo->{ openid }, } );
}

1;

__END__

=head1 NAME

CPANHQ::ResultSet::Account - an account result-set.

=head1 SYNOPSIS

None.

=head1 DESCRIPTION

This is L<CPANHQ>'s account result-set.

=head1 METHODS

=head2 $self->auto_create( { openid => $openid })

Creates an account automatically based on the $openid OpenID credentials.

=head1 SEE ALSO

L<CPANHQ>, L<DBIx::Class::ResultSet>

=head1 AUTHOR

Brian Cassidy E<lt>bricas@cpan.orgE<gt>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

