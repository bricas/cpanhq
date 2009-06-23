package CPANHQ::Storage::License;

use strict;
use warnings;

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

1;
