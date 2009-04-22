package CPANHQ::Storage::Account;

use strict;
use warnings;

use base qw( DBIx::Class );

__PACKAGE__->load_components( qw( TimeStamp Core ) );
__PACKAGE__->table( 'account' );
__PACKAGE__->resultset_class( 'CPANHQ::ResultSet::Account' );
__PACKAGE__->add_columns(
    id => {
        data_type         => 'bigint',
        is_auto_increment => 1,
        is_nullable       => 0,
    },
    openid => {
        data_type   => 'varchar',
        size        => 512,
        is_nullable => 0,
    },
    username => {
        data_type   => 'varchar',
        size        => 50,
        is_nullable => 1,
    },
    ctime => {
        data_type     => 'datetime',
        is_nullable   => 0,
        set_on_create => 1,
    },
    mtime => {
        data_type     => 'datetime',
        is_nullable   => 0,
        set_on_create => 1,
        set_on_update => 1,
    },
);
__PACKAGE__->set_primary_key( 'id' );

__PACKAGE__->add_unique_constraint( [ 'openid' ] );

sub display_name {
    my $self = shift;
    return $self->username || $self->openid;
}

1;
