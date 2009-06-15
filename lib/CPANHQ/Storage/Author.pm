package CPANHQ::Storage::Author;

use strict;
use warnings;

use base qw( DBIx::Class );

use List::MoreUtils qw(uniq);

__PACKAGE__->load_components( qw( Core ) );
__PACKAGE__->table( 'author' );
__PACKAGE__->add_columns(
    id => {
        data_type         => 'bigint',
        is_auto_increment => 1,
        is_nullable       => 0,
    },
    cpanid => {
        data_type   => 'varchar',
        size        => 16,
        is_nullable => 0,
    },
    name => {
        data_type   => 'varchar',
        size        => 255,
        is_nullable => 0,
    },
    email => {
        data_type   => 'varchar',
        size        => 255,
        is_nullable => 0,
    },
    homepage => {
        data_type   => 'varchar',
        size        => 255,
        is_nullable => 1,
    },
);

__PACKAGE__->set_primary_key( qw( id ) );
__PACKAGE__->resultset_attributes( { order_by => [ 'cpanid' ] } );
__PACKAGE__->add_unique_constraint( [ 'cpanid' ] );
__PACKAGE__->has_many(
    releases => 'CPANHQ::Storage::Release', 'author_id'
);

sub display_name {
    my $self = shift;
    return sprintf '%s <%s>', $self->name, $self->email;
}

sub distributions {
    my $self = shift;

    my $ret =
        $self
            ->related_resultset('releases')
            ->related_resultset('distribution')
            ->search(undef,
                { 
                    distinct => 1, 
                    'select' => [qw/distribution.id distribution.name/], 
                    'as' => [qw/id name/],
                    order_by => 'name'
                }
            )
        ;

    return $ret;
}

1;
