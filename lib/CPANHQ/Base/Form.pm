package CPANHQ::Base::Form;

use strict;
use warnings;

use parent 'Rose::HTML::Form';

sub COMPONENT {
    return shift->new;
}

sub ACCEPT_CONTEXT {
    my ( $self, $c, @args ) = @_;

    $self->reset;
    $self->app( $c );
    $self->params( $c->req->params );
    $self->init_fields();

    return $self;
}

sub is_valid {
    return shift->validate( @_ );
}

sub was_submitted {
    my $self = shift;
    return lc $self->app->req->method eq $self->method;
}

sub render {
    my $self   = shift;
    my $output = '';

    if ( $self->error ) {
        $output .= $self->xhtml_error;
    }

    $output .= $self->start_xhtml;

    for my $field ( map { $self->field( $_ ) } $self->field_names_by_rank ) {
        $output .= $field->xhtml_label . $field->xhtml;
    }

    $output .= $self->end_xhtml;
    return $output;
}

sub field_names_by_rank {
    my $self = shift;
    return map { $_->name }
        sort   { $a->rank <=> $b->rank } $self->fields;
}

1;
