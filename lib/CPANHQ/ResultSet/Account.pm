package CPANHQ::ResultSet::Account;

use strict;
use warnings;

use base qw( DBIx::Class::ResultSet );

sub auto_create {
    my ( $self, $authinfo ) = @_;
    $self->create( { openid => $authinfo->{ openid }, } );
}

1;
