use strict;
use warnings;
use Test::More;
use Data::Dumper;
BEGIN{
use_ok('Template::Reverse');
};

my $rev = Template::Reverse->new({
    spacers=>['Template::Reverse::Spacer::Numeric'], # at first spacing/unspacing text by
});

is ref($rev),'Template::Reverse';

#print Dumper $rev->splitters;
#print Dumper $rev->spacers;

my ($str1,$str2,$res);

$str1 = "A B C D E F";
$str2 = "A B C D E F";
$res = $rev->space($str1);
is $res, $str2;

$str1 = "가격 1200 원";
$str2 = "가격 1200 원";
$res = $rev->space($str1);
is $res, $str2;

$str1 = "가격 1200원";
$str2 = "가격 1200 원";
$res = $rev->space($str1);
is $res, $str2;

done_testing();
