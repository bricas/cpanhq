package CPANHQ::Storage::AuthorDistributionKeyword;

use strict;
use warnings;

=head1 NAME

CPANHQ::Storage::AuthorDistributionKeyword - an author's distribution <-> 
keyword association

=head1 SYNOPSIS
      
    To be written.

=head1 DESCRIPTION

This table/class associates distributions with keywords/labels/tags, if the
authors added those keywords to their META.yml. See 'keywords' in the
META.yml-Spec:

L<http://module-build.sourceforge.net/META-spec.html>

=head1 METHODS

=cut

use base qw( DBIx::Class );

__PACKAGE__->load_components( qw( Core ) );
__PACKAGE__->table( 'authors_distro_keyword_assoc' );
__PACKAGE__->add_columns(
    distribution_id => {
        data_type         => 'bigint',
        is_nullable       => 0,
    },
    keyword_id => {
        data_type   => 'bigint',
        is_nullable => 0,
    },
);

__PACKAGE__->set_primary_key( qw( distribution_id keyword_id ) );
__PACKAGE__->resultset_attributes( { order_by => [ 'distribution_id', 'keyword_id' ] } );
__PACKAGE__->belongs_to(
    distribution => 'CPANHQ::Storage::Distribution',
    'distribution_id',
);
__PACKAGE__->belongs_to(
    keyword => 'CPANHQ::Storage::Keyword',
    'keyword_id',
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
