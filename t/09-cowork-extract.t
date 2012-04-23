use strict;
use warnings;
use Test::More;
use Data::Dumper;
BEGIN{
};
eval "use Template::Extract;";
if($@){
    plan skip_all => "Template::Extract required for testing compilation";
    done_testing();
}

use Template::Reverse;
use Template::Reverse::Converter::TT2;
my $rev = Template::Reverse->new({
    spacers=>['Template::Reverse::Spacer::Numeric'], # at first spacing/unspacing text by
});

is ref($rev),'Template::Reverse';

my $ext = Template::Extract->new;
my ($temp,$extres);
my ($str1,$str2,$parts,@temps);

$str1 = "A B C D E F";
$str2 = "A B C E F";
$parts = $rev->detect($str1,$str2);
@temps = Template::Reverse::Converter::TT2::Convert($parts);
ok( eq_array( \@temps, ['A B C [% data1 %] E F'] ));

$temp = $temps[0];
$extres = $ext->extract($temp,$str1);
is $extres->{'data1'}, 'D';
$extres = $ext->extract($temp,$str2);
is $extres->{'data1'}, undef;





$str1 = "가격 1200 원";
$str2 = "가격 1300 원";
$parts = $rev->detect($str1,$str2);
@temps = Template::Reverse::Converter::TT2::Convert($parts);
ok( eq_array( \@temps, ['가격 [% data1 %] 원'] ));

$temp = $temps[0];
$extres = $ext->extract($temp,$str1);
is $extres->{'data1'}, '1200';
$extres = $ext->extract($temp,$str2);
is $extres->{'data1'}, '1300';




$str1 = "가격 1200원";
$str2 = "가격 1300원";
$parts = $rev->detect($str1,$str2);
@temps = Template::Reverse::Converter::TT2::Convert($parts);
ok( eq_array( \@temps, ['가격 [% data1 %] 원'] ));

$temp = $temps[0];
$extres = $ext->extract($temp,$rev->space($str1));
is $extres->{'data1'}, '1200';
$extres = $ext->extract($temp,$rev->space($str2));
is $extres->{'data1'}, '1300';


$str1 = "I am perl, and I am smart";
$str2 = "I am khs, and I am a perlmania";
my $str3 = "I am king of the world, and I am a richest man";
$parts = $rev->detect($str1, $str2);
print Dumper $parts;
@temps = Template::Reverse::Converter::TT2::Convert($parts);
print Dumper \@temps;

my $r = $ext->extract($temps[0],$rev->space($str3));
TODO:{
    local $TODO="need to sigil spacer";
    is $r->{'data1'},'king of the world';
}

$r = $ext->extract($temps[1],$rev->space($str3));
is $r->{'data2'},'a richest man';


done_testing();
