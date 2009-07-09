package CPANHQ::Storage::Requires;

use strict;
use warnings;

use base qw( DBIx::Class );

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

1;
