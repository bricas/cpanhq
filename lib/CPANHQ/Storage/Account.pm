package CPANHQ::Storage::Account;

use strict;
use warnings;


=head1 NAME

CPANHQ::Storage::Account - a class representing a CPANHQ account

=head1 SYNOPSIS
      
    my $schema = CPANHQ->model("DB");

    my $accounts_rs = $schema->resultset('Account');

=head1 DESCRIPTION

This is the account schema class for L<CPANHQ>.

=head1 METHODS

=cut

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

=head2 $self->display_name()

Returns a display name for the account.

=cut

sub display_name {
    my $self = shift;
    return $self->username || $self->openid;
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
