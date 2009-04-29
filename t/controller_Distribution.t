use strict;
use warnings;
use Test::More tests => 3;

BEGIN { use_ok 'Catalyst::Test', 'CPANHQ' }
BEGIN { use_ok 'CPANHQ::Controller::Distribution' }

ok( request('/dist/WWW-Wikipedia')->is_success, 'Request should succeed' );


