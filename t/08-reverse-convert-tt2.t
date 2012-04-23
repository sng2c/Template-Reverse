use strict;
use warnings;
use Test::More;
use Data::Dumper;
BEGIN{
use_ok('Template::Reverse');
use_ok('Template::Reverse::Converter::TT2');
};

my $rev = Template::Reverse->new({
    spacers=>['Template::Reverse::Spacer::Numeric'], # at first spacing/unspacing text by
});

is ref($rev),'Template::Reverse';

#print Dumper $rev->splitters;
#print Dumper $rev->spacers;

my ($str1,$str2,$parts,@temps);

$str1 = "A B C D E F";
$str2 = "A B C E F";
$parts = $rev->detect($str1,$str2);
@temps = Template::Reverse::Converter::TT2::Convert($parts);
print Dumper $parts;
print Dumper(@temps);
ok( eq_array( \@temps, ['A B C [% data1 %] E F'] ));

$str1 = "가격 1200 원";
$str2 = "가격 1300 원";
$parts = $rev->detect($str1,$str2);
print Dumper $parts;
@temps = Template::Reverse::Converter::TT2::Convert($parts);
print Dumper $parts;
print Dumper(@temps);
ok( eq_array( \@temps, ['가격 [% data1 %] 원'] ));


$str1 = "가격 1200원";
$str2 = "가격 1300원";
$parts = $rev->detect($str1,$str2);
print Dumper $parts;
@temps = Template::Reverse::Converter::TT2::Convert($parts);
print Dumper $parts;
print Dumper(@temps);
ok( eq_array( \@temps, ['가격 [% data1 %] 원'] ));


done_testing();
