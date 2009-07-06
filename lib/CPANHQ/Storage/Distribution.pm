package CPANHQ::Storage::Distribution;

use strict;
use warnings;

use base qw( DBIx::Class );


=head1 NAME

CPANHQ::Storage::Distribution - a class representing a CPANHQ CPAN distribution

=head1 SYNOPSIS
      
    my $schema = CPANHQ->model("DB");

    my $releases_rs = $schema->resultset('Distribution');

    my $module_build = $distributions_rs->find({
            {
                name => "Module-Build",
            })->id(),
    );

    my $release = $module_build->latest_release();

=head1 DESCRIPTION

This is the distribution schema class for L<CPANHQ>.

=head1 METHODS

=cut

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

__PACKAGE__->has_many(
    author_keywords => 'CPANHQ::Storage::AuthorDistributionKeyword',
    'distribution_id'
);

__PACKAGE__->has_many(
    packages => 'CPANHQ::Storage::Package',
    'distribution_id'
);

=head2 $self->latest_release()

Returns the latest release.

=cut

sub latest_release {
    return shift->releases->first;
}

=head1 SEE ALSO

L<CPANHQ::Storage>, L<CPANHQ>, L<DBIx::Class>

=head1 AUTHOR

Brian Cassidy E<lt>bricas@cpan.orgE<gt>

Shlomi Fish L<http://www.shlomifish.org/> (who places all his contributions
and modifications under the public domain - 
L<http://creativecommons.org/license/zero> )

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
