package CPANHQ::Storage::Requires;

use strict;
use warnings;

use base qw( DBIx::Class );

=head1 NAME

CPANHQ::Storage::Requires - a class representing a CPAN dependencies

=head1 SYNOPSIS

    my $schema = CPANHQ->model("DB");

    my $keywords_rs = $schema->resultset('Requires');

    my $keyword = $keywords_rs->find({
        dist_from => 1234,
        });

    print $keyword->dist_to->name();

=head1 DESCRIPTION

This is the requires schema class for L<CPANHQ>.

=head1 METHODS

=cut
__PACKAGE__->load_components( qw( Core ) );
__PACKAGE__->table( 'requires' );

__PACKAGE__->add_columns(
    id => {
        data_type         => 'bigint',
        is_auto_increment => 1,
        is_nullable       => 0,
    },
    dist_from => {
        data_type   => 'bigint',
        is_nullable => 0,
    },
    dist_to => {
        data_type   => 'bigint',
        is_nullable => 0,
    },
);

__PACKAGE__->set_primary_key( 'id' );
__PACKAGE__->belongs_to( dist_from => 'CPANHQ::Storage::Distribution' );
__PACKAGE__->belongs_to( dist_to   => 'CPANHQ::Storage::Distribution' );

=head1 SEE ALSO

L<CPANHQ::Storage>, L<CPANHQ>, L<DBIx::Class>

=head1 AUTHOR

Franck Cuny E<lt>franck@lumberjaph.netE<gt>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
