package CPANHQ::Model::DB;

use strict;
use warnings;

use base qw( Catalyst::Model::DBIC::Schema );

__PACKAGE__->config(
    schema_class => 'CPANHQ::Storage'
);

1;

__END__

=head1 NAME

CPANHQ::Model::DB - the database model of CPANHQ

=head1 SYNOPSIS

None.

=head1 DESCRIPTION

This is the database model class of CPANHQ. It uses L<CPANHQ::Storage> as
its model.

=head1 METHODS

None.

=head1 SEE ALSO

L<CPANHQ>, L<Catalyst::Model::DBIC::Schema>, L<Catalyst>

=head1 AUTHOR

Brian Cassidy E<lt>bricas@cpan.orgE<gt>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

