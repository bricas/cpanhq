package CPANHQ::Storage::Distribution;

use strict;
use warnings;

use base qw( DBIx::Class );

__PACKAGE__->load_components( qw( Core ) );
__PACKAGE__->table( 'distribution' );
__PACKAGE__->add_columns(
    id => {
        data_type         => 'bigint',
        is_auto_increment => 1,
        is_nullable       => 0,
    },
    name => {
        data_type   => 'varchar',
        size        => 255,
        is_nullable => 0,
    },
);
__PACKAGE__->set_primary_key( qw( id ) );
__PACKAGE__->resultset_attributes( { order_by => [ 'name' ] } );
__PACKAGE__->has_many(
    releases => 'CPANHQ::Storage::Release',
    'distribution_id'
);
__PACKAGE__->many_to_many(
    authors => 'releases',
    'author_id', { distinct => 1 }
);
__PACKAGE__->add_unique_constraint( [ 'name' ] );

1;
