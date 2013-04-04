use Test::More;
use lib '../lib';
BEGIN{
use_ok("Template::Reverse::Spacer::PunctuationUrlSafe");
};

sub space{
    my $str = shift;
    return Template::Reverse::Spacer::PunctuationUrlSafe->Space($str);
}

$m1 = space("ABC DEF HIJ");
$m2 = "ABC EF HIJ";
isnt $m1, $m2;

$m3 = space(".,:ABC");
$m4 = ".,: ABC";
is $m3, $m4;

$m3 = space(".ABC");
$m4 = ". ABC";
is $m3, $m4;

$m3 = space("1,123");
$m4 = "1,123";
is $m3, $m4;

$m3 = space("1,123.2ABC");
$m4 = "1,123.2ABC";
is $m3, $m4;

$m3 = space("1,123.2.ABC");
$m4 = "1,123.2 . ABC";
is $m3, $m4;

$m3 = space('<span value="1"> 1,000dollars</span>');
$m4 = '< span value =" 1 "> 1,000dollars </ span >';
is $m3, $m4;


$m3 = space('<span value="1" height=12px> 1,000dollars</span>');
$m4 = '< span value =" 1 " height = 12px > 1,000dollars </ span >';
is $m3, $m4;

$m3 = space('<a href="http://metacpan.org">GOGO!!</a>');
$m4 = '< a href =" http://metacpan.org "> GOGO !!</ a >';
is $m3, $m4;

$m3 = space('<a href="https://metacpan.org/module/Template::Reverse">GOGO!!</a>');
$m4 = '< a href =" https://metacpan.org/module/Template::Reverse "> GOGO !!</ a >';
is $m3, $m4;

$m3 = space('<a href="https://metacpan.org/module/Template::Reverse?a=123&name=%20">GOGO!!</a>');
$m4 = '< a href =" https://metacpan.org/module/Template::Reverse?a=123&name=%20 "> GOGO !!</ a >';
is $m3, $m4;

$m3 = space("2.3.3.4");
$m4 = "2.3.3.4";
is $m3, $m4;

$m3 = space("2,3,3,4");
$m4 = "2,3,3,4";
is $m3, $m4;

$m3 = space("2.3,3.4");
$m4 = "2.3,3.4";
is $m3, $m4;

$m3 = space("2,300.3.4");
$m4 = "2,300.3.4";
is $m3, $m4;

$m3 = space("Hello,world!!");
$m4 = "Hello , world !!";
is $m3, $m4;


done_testing();
