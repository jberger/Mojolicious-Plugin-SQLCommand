use Mojolicious::Lite;

use DBI;

helper 'dbh' => sub { state $dbh = DBI->connect('dbi:SQLite:dbname=:memory:', '', '') };

plugin 'SQLCommand';

app->dbh->do('CREATE TABLE people (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)');
app->dbh->do('INSERT INTO people (name) VALUES ("Bender")');

use Test::More;

open my $fh, '>', \my $out or die "$!";
local *STDOUT = $fh;
app->commands->run(sql => 'SELECT * FROM people');
like $out, qr/Bender/;

done_testing;

