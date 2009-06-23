package CPANHQ::Storage::Author;

use strict;
use warnings;

=head1 NAME

CPANHQ::Storage::Author - a class representing a CPANHQ author

=head1 SYNOPSIS

To be written.

=head1 DESCRIPTION

This is the author's schema class for L<CPANHQ>.

=head1 METHODS

=cut

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

=head2 $author->display_name()

Returns a nicely formatted display name - name + email.

=cut

sub display_name {
    my $self = shift;
    return sprintf '%s <%s>', $self->name, $self->email;
}

=head2 $self->distributions_rs()

Returns a result set for the author's most recent distributions and releases
of them.

Each element of the result set (accessible via next() ) contains the following
accessors:

=over 4

=item * release_id

The database ID of the release.

=item * dist_id

The database ID of distribution.

=item * dist_name

The name of the distribution.

=item * version

The version of the distribution (a string).

=item * date

The date of the distribution.

=back

=cut

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
