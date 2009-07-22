use strict;
use warnings;
use Test::More tests => 2;

use Test::WWW::Mechanize::Catalyst 'CPANHQ';

{
    my $mech = Test::WWW::Mechanize::Catalyst->new;

    # TEST
    $mech->get_ok("http://localhost/status/");

    # TEST
    $mech->follow_link_ok(
        {
            text_regex => qr{Specific version of a release},
        },
        "Following the link to the release works."
    );
}

=head1 AUTHOR

Shlomi Fish L<http://www.shlomifish.org/> .

=head1 LICENSE

This module is free software, available under the MIT X11 Licence:

L<http://www.opensource.org/licenses/mit-license.php>

Copyright by Shlomi Fish, 2009.

=cut

