package Mojolicious::Plugin::SQLCommand;

use Mojo::Base 'Mojolicious::Plugin';

sub register {
  my ($plugin, $app, $config) = @_;

  my $handle = $config->{handle} || 'dbh';
  $app->helper('sql_command.handle' => sub { shift->app->$handle });

  push @{$app->commands->namespaces}, __PACKAGE__;
}

1;

