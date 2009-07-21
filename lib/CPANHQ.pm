package CPANHQ;

use strict;
use warnings;

use Catalyst::Runtime '5.80';

use parent qw(Catalyst);
use Catalyst qw(
    ConfigLoader
    Authentication
    Authorization::ACL
    Session
    Session::State::Cookie
    Session::Store::File
    Static::Simple
);

require LWP::Debug; # to satisfy LWPx::ParanoidAgent
our $VERSION = '0.01';

__PACKAGE__->config(
    name => 'CPANHQ',
    default_view => 'HTML',
    setup_components => { search_extra => [ '::Form' ] },
    authentication => {
        default_realm => 'openid',
        realms => {
            openid => {
                auto_create_user => 1,
                credential => {
                    class => 'OpenID',
                    extensions =>
                    {
                        'http://openid.net/extensions/sreg/1.1' => '1',
                    },
                    extension_args =>
                    [
                        "http://openid.net/extensions/sreg/1.1",
                        {
                            required => "email,timezone",
                            optional => "fullname,nickname,timezone",
                        },
                    ],
                    ua_class => "LWPx::ParanoidAgent",
                },
                store => {
                    class => 'DBIx::Class',
                    user_class => 'DB::Account',
                    id_field => 'id',
                    role_relation => 'roles',
                    role_field => 'name',
                },
            }
        }
    }
);

__PACKAGE__->setup();

__PACKAGE__->deny_access_unless( '/authenticate/login', sub { ! shift->user_exists } );
__PACKAGE__->deny_access_unless( '/authenticate/logout', sub { shift->user_exists } );

sub form {
    my ( $c, $name, @args ) = @_;

    return $c->_filter_component( $c->_comp_search_prefixes( $name, 'Form' ),
        @args );
}

=head1 NAME

CPANHQ - Perl from the trenches

=head1 SYNOPSIS

    script/cpanhq_server.pl

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 $self->form($name, @args)

Filter args for form components.

=head1 SEE ALSO

L<CPANHQ::Controller::Root>, L<Catalyst>

=head1 AUTHOR

Brian Cassidy E<lt>bricas@cpan.orgE<gt>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
