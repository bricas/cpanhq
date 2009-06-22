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

sub distributions_rs {
    my $self = shift;

    my $ret =
        $self
            ->search_related(
                'releases',
                {},
                {
                    'select' => [
                        qw/me.id distribution_id distribution.name 
                        version MAX(release_date)/
                    ],
                    'as' => [qw(release_id dist_id dist_name
                        version date)
                    ],
                    join => 'distribution',
                    group_by => 'distribution.id',
                    'order_by' => "distribution.name",
                },
            )
            ;

    return $ret;
}

1;
