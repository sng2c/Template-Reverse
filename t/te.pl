use Template::Extract;
use Data::Dumper;

my $obj = Template::Extract->new;
my $template = << '.';
<ul>[% FOREACH record %]
<li><A HREF="[% url %]">[% title %]</A>: [% rate %] - [% comment %].
[% ... %]
[% END %]</ul>
.

my $document = << '.';
<html><head><title>Great links</title></head><body>
<ul><li><A HREF="http://slashdot.org">News for nerds.</A>: A+ - nice.
this text is ignored.</li>
<li><A HREF="http://microsoft.com">Where do you want...</A>: Z! - yeah.
this text is ignored, too.</li></ul>
.

print Data::Dumper::Dumper(
    $obj->extract($template, $document)
);
