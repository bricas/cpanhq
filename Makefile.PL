use inc::Module::Install;

name 'CPANHQ';
all_from 'lib/CPANHQ.pm';

requires 'Catalyst::Runtime' => '5.80003';
requires 'Catalyst::Action::RenderView' => '0.07';
requires 'Catalyst::Model::DBIC::Schema';
requires 'Catalyst::Plugin::Authentication' => '0.100091';
requires 'Catalyst::Plugin::Authorization::ACL';
requires 'Catalyst::Plugin::ConfigLoader' => '0.23';
requires 'Catalyst::Plugin::Session';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Plugin::Session::State::Cookie';
requires 'Catalyst::Plugin::Session::Store::File';
requires 'Catalyst::View::TT';
requires 'parent';
requires 'Config::General';
requires 'Net::OpenID::Consumer';
requires 'LWPx::ParanoidAgent';
requires 'Rose::HTML::Form';

catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;
