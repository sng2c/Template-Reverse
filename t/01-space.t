use Test::More;

use Template::Reverse;

sub space{
    my $str = shift;
    return Template::Reverse::space($str);
}

$m1 = space("ABC DEF HIJ");
$m2 = "ABC EF HIJ";
isnt $m1, $m2;

$m3 = space("123ABC");
$m4 = "123 ABC";
is $m3, $m4;

$m3 = space("1ABC");
$m4 = "1 ABC";
is $m3, $m4;

$m3 = space("1,123ABC");
$m4 = "1,123 ABC";
is $m3, $m4;

$m3 = space("1,123.2ABC");
$m4 = "1,123.2 ABC";
is $m3, $m4;

$m3 = space("1,123.2.ABC");
$m4 = "1,123.2 .ABC";
is $m3, $m4;

$m3 = space('<span value="1"> 1,000dollars</span>');
$m4 = '<span value=" 1 "> 1,000 dollars</span>';
is $m3, $m4;


$m3 = space('<span value="1" height=12px> 1,000dollars</span>');
$m4 = '<span value=" 1 " height= 12 px> 1,000 dollars</span>';
is $m3, $m4;


TODO:{
    local $TODO="Need more time to dig";
    $m3 = space("2.3.3.4");
    $m4 = "2.3.3.4";
    is $m3, $m4;
}
=pod
my ($f1,$f2) = @ARGV;

undef($/);
open(FILE,$f1);
my $s1 = <FILE>;
close(FILE);

my $map = makeMap($s1,50);
print $map."\n";
print length($s1) ." , " .length($map)."\n";

=cut
done_testing();
