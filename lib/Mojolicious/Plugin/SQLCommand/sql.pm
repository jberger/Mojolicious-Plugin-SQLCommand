package Mojolicious::Plugin::SQLCommand::sql;

use Mojo::Base 'Mojolicious::Command';

use Getopt::Long qw(GetOptionsFromArray :config no_auto_abbrev no_ignore_case);

has description => q[Execute a SQL query against the app's database];
has usage => <<"END";
USAGE: $0 sql [OPTIONS] QUERY

OPTIONS:
  -all, -a     print multiple results (all)
  -do,  -d     execute the query as a do rather than select
END

sub run {
  my ($command, @args) = @_;

  GetOptionsFromArray(
    \@args,
    'a|all' => \my $all,
    'd|do'  => \my $do,
  );

  die 'No query given' unless my $query = shift @args;

  my $dbh = $command->app->sql_command->handle;

  my $res;
  if ($all) {
    $res = $dbh->selectall_arrayref($query, {Slice => {}});
  } elsif ($do) {
    $res = $dbh->do($query);
  } else {
    $res = $dbh->selectrow_hashref($query);
  }

  print $command->app->dumper($res);
}

1;

