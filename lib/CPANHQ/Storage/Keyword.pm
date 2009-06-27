package CPANHQ::Storage::Keyword;

use strict;
use warnings;

=head1 NAME

CPANHQ::Storage::Keyword - a class representing a CPAN license

=head1 SYNOPSIS
      
    my $schema = CPANHQ->model("DB");

    my $keywords_rs = $schema->resultset('Keyword');

    my $keyword = $keywords_rs->find({
        string_id => "games",
        });

    print $keyword->id();

=head1 DESCRIPTION

This is the keyword schema class for L<CPANHQ>.

=head1 METHODS

=cut

use base qw( DBIx::Class );

__PACKAGE__->load_components( qw( Core ) );
__PACKAGE__->table( 'keyword' );
__PACKAGE__->add_columns(
    id => {
        data_type         => 'bigint',
        is_auto_increment => 1,
        is_nullable       => 0,
    },
    string_id => {
        data_type   => 'varchar',
        size        => 80,
        is_nullable => 0,
    },
);

__PACKAGE__->set_primary_key( qw( id ) );
__PACKAGE__->resultset_attributes( { order_by => [ 'string_id' ] } );
__PACKAGE__->add_unique_constraint( [ 'string_id' ] );
__PACKAGE__->has_many(
    author_distros => 'CPANHQ::Storage::AuthorDistributionKeyword',
    'keyword_id'
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
