use strict;
use warnings;
use Test::More tests => 3;

BEGIN { use_ok 'Catalyst::Test', 'CPANHQ' }
BEGIN { use_ok 'CPANHQ::Controller::Author' }

ok( request('/author/BRICAS')->is_success, 'Request should succeed' );


