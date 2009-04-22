package CPANHQ::Form::Login;

use strict;
use warnings;

use parent qw( CPANHQ::Base::Form );

sub build_form {
    my $self = shift;

    $self->add_fields( claimed_uri => { type => 'text', size => 40, required => 1 }, submit => { type => 'submit', value => 'Login' } );
    $self->method( 'post' );

    return $self;
}

1;
