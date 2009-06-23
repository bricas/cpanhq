package CPANHQ::Storage::License;

use strict;
use warnings;

=head1 NAME

CPANHQ::Storage::License - a class representing a CPAN license

=head1 SYNOPSIS
      
    my $schema = CPANHQ->model("DB");

    my $licenses_rs = $schema->resultset('License');

    my $perl_license = $license_rs->find({
        string_id => "perl",
        });

    print $perl_license->id();

=head1 DESCRIPTION

This is the license schema class for L<CPANHQ>.

=head1 METHODS

=cut

use base qw( DBIx::Class );

use List::MoreUtils qw(uniq);

__PACKAGE__->load_components( qw( Core ) );
__PACKAGE__->table( 'license' );
__PACKAGE__->add_columns(
    id => {
        data_type         => 'bigint',
        is_auto_increment => 1,
        is_nullable       => 0,
    },
    string_id => {
        data_type   => 'varchar',
        size        => 40,
        is_nullable => 0,
    },
    name => {
        data_type   => 'varchar',
        size        => 255,
        is_nullable => 0,
    },
    url => {
        data_type   => 'varchar',
        size        => 255,
        is_nullable => 0,
    },
);

__PACKAGE__->set_primary_key( qw( id ) );
__PACKAGE__->resultset_attributes( { order_by => [ 'string_id' ] } );
__PACKAGE__->add_unique_constraint( [ 'string_id' ] );
__PACKAGE__->has_many(
    releases => 'CPANHQ::Storage::Release', 'license_id'
);

=head1 SEE ALSO

L<CPANHQ::Storage>, L<CPANHQ>, L<DBIx::Class>

=head1 AUTHOR

Shlomi Fish L<http://www.shlomifish.org/> .

=head1 LICENSE

This module is free software, available under the MIT X11 Licence:

L<http://www.opensource.org/licenses/mit-license.php>

Copyright by Shlomi Fish, 2009.

=cut

1;
