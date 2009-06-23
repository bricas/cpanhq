package CPANHQ::Storage;

use strict;
use warnings;

use base qw( DBIx::Class::Schema );

__PACKAGE__->load_classes;

1;

__END__

=head1 NAME

CPANHQ::Storage - storage wrapper for CPANHQ

=head1 SYNOPSIS

    script/cpanhq_server.pl

=head1 DESCRIPTION

This is the storage wrapper for CPANHQ.

=head1 METHODS

None.

=head1 SEE ALSO

L<CPANHQ>, L<CPANHQ::Controller::Root>, L<Catalyst>, L<DBIx::Class::Schema>

=head1 AUTHOR

Brian Cassidy E<lt>bricas@cpan.orgE<gt>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

