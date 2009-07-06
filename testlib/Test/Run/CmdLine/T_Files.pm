package Test::Run::CmdLine::T_Files;

use strict;
use warnings;

use File::Spec;
use base 'Exporter';

use vars qw(@EXPORT);

@EXPORT = (qw(run_t));

sub run_t
{
    require Test::Run::CmdLine::Iface;
    my ($test_verbose, $inst_lib, $inst_archlib, $test_level) = @_;
    local @INC = @INC;
    unshift @INC, map { File::Spec->rel2abs($_) } ($inst_lib, $inst_archlib); 
    
    my $test_iface = Test::Run::CmdLine::Iface->new({
            test_files => [glob("t/*.t")]
        }
    );
    
    return $test_iface->run();
}

1;
