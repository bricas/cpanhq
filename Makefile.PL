use inc::Module::Install;

name 'CPANHQ';
all_from 'lib/CPANHQ.pm';

requires 'Archive::Extract';
requires 'Catalyst::Action::RenderView' => '0.07';
requires 'Catalyst::Model::DBIC::Schema';
requires 'Catalyst::Plugin::Authentication' => '0.100091';
requires 'Catalyst::Plugin::Authorization::ACL';
requires 'Catalyst::Plugin::ConfigLoader' => '0.23';
requires 'Catalyst::Plugin::Session';
requires 'Catalyst::Plugin::Session::State::Cookie';
requires 'Catalyst::Plugin::Session::Store::File';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Runtime' => '5.80003';
requires 'Catalyst::View::TT';
requires 'Config::General';
requires 'CPAN::Mini';
requires 'DBIx::Class';
requires 'DBIx::Class::TimeStamp';
requires 'File::Spec';
requires 'File::Temp';
requires 'Graph::Easy';
requires 'List::Util';
requires 'LWPx::ParanoidAgent';
requires 'Net::OpenID::Consumer';
requires 'parent';
requires 'Rose::HTML::Form';
requires 'YAML::XS';

# for twitter feed
requires 'XML::RSS';
requires 'LWP::Simple';

homepage "http://github.com/bricas/cpanhq/tree/master";
bugtracker "http://github.com/bricas/cpanhq/issues";
repository "http://github.com/bricas/cpanhq/tree/master";
keywords(
    "catalyst",
    "community",
    "cpan",
    "cpanhq",
    "indexing",
    "modules",
    "perl",
    "search",
    "social",
    "social-web",
    "webapp",
    "web-interface",
);
catalyst;

install_script glob('script/*.pl');
postamble(<<'MAKE_FRAG');

runtest: pure_all
	$(PERLRUNINST) -Itestlib -MTest::Run::CmdLine::T_Files -e "run_t($(TEST_VERBOSE), '$(INST_LIB)', '$(INST_ARCHLIB)', $(TEST_LEVEL));"

distruntest: distdir
	cd $(DISTVNAME) && $(ABSPERLRUN) Makefile.PL
	cd $(DISTVNAME) && $(MAKE) $(PASTHRU)
	cd $(DISTVNAME) && $(MAKE) runtest $(PASTHRU)

MAKE_FRAG

WriteAll;
