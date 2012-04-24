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

my ($str1,$str2,$parts);

$str1 = "A B C D E F";
$str2 = "A B C E F";
$parts = $rev->detect($str1,$str2);
print Dumper $parts;
ok( scalar(@{$parts}) == 1 );
ok( eq_array( $parts->[0]->[0], [qw'A B C']), 'Pre-Patthen');
ok( eq_array( $parts->[0]->[1], [qw'E F']), 'Post-Pattern');

$str1 = "가격 1200 원";
$str2 = "가격 1300 원";
$parts = $rev->detect($str1,$str2);
print Dumper $parts;
ok( scalar(@{$parts}) == 1 );
ok( eq_array( $parts->[0]->[0], [qw'가격']), 'Pre-Patthen');
ok( eq_array( $parts->[0]->[1], [qw'원']), 'Post-Pattern');


$str1 = "가격 1200원";
$str2 = "가격 1300원";
$parts = $rev->detect($str1,$str2);
print Dumper $parts;
ok( scalar(@{$parts}) == 1 );
ok( eq_array( $parts->[0]->[0], [qw'가격']), 'Pre-Patthen');
ok( eq_array( $parts->[0]->[1], [qw'원']), 'Post-Pattern');


done_testing();
