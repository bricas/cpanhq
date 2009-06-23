package CPANHQ::Storage::Release;

use strict;
use warnings;

use base qw( DBIx::Class );

use File::Spec;

use CPAN::Mini;

__PACKAGE__->load_components( qw( InflateColumn::DateTime Core ) );
__PACKAGE__->table( 'release' );
__PACKAGE__->add_columns(
    id => {
        data_type         => 'bigint',
        is_auto_increment => 1,
        is_nullable       => 0,
    },
    distribution_id => {
        data_type      => 'bigint',
        is_nullable    => 0,
        is_foreign_key => 1,
    },
    version => {
        data_type   => 'varchar',
        size        => 32,
        is_nullable => 1,
    },
    developer_release => {
        data_type     => 'boolean',
        default_value => 0,
        is_nullable   => 0,
    },
    path => {
        data_type   => 'varchar',
        size        => 255,
        is_nullable => 0,
    },
    size => {
        data_type   => 'bigint',
        is_nullable => 1,
    },
    author_id => {
        data_type      => 'bigint',
        is_nullable    => 0,
        is_foreign_key => 1,
    },
    release_date => {
        data_type   => 'datetime',
        is_nullable => 0,
    },
);
__PACKAGE__->set_primary_key( qw( id ) );
__PACKAGE__->resultset_attributes( { order_by => [ 'release_date DESC' ] } );
__PACKAGE__->belongs_to(
    distribution => 'CPANHQ::Storage::Distribution',
    'distribution_id'
);
__PACKAGE__->belongs_to( author => 'CPANHQ::Storage::Author', 'author_id' );
__PACKAGE__->add_unique_constraint( [ qw( distribution_id version ) ] );

sub name {
    my $self = shift;
    return join( ' ', $self->distribution->name, $self->version || '' );
}

sub _get_meta_yml {
    my $self = shift;

    my %config = CPAN::Mini->read_config;
    my $minicpan_path = 
        $config{'local'}
        ;

    my $fn_base = $self->distribution->name() . "-" . $self->version();
    my $author = $self->author->cpanid();

    my $arc_path =
        File::Spec->catfile(
            $minicpan_path,
            "authors",
            "id",
            substr($author, 0, 1),
            substr($author, 0, 2),
            $author,
            $fn_base . ".tar.gz",
        );

    if (! -e $arc_path)
    {
        die "Archive path '$arc_path' not found";
    }

    return 1;
}

1;
