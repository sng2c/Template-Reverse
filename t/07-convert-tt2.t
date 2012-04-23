use Test::More;

use Data::Dumper;
sub detect{
    my $diff= shift;
    return Template::Reverse::_detect($diff);
}
BEGIN{
use_ok("Template::Reverse");
use_ok('Template::Reverse::Converter::TT2');
};

@diff = qw(-A -B -C -D -E);
$parts = detect(\@diff);
@temps = Template::Reverse::Converter::TT2::Convert($parts);
ok( eq_array( \@temps, [] ));

@diff = qw(-A -B * -D -E);
$parts = detect(\@diff);
@temps = Template::Reverse::Converter::TT2::Convert($parts);
ok( eq_array( \@temps, ['A B [% data1 %] D E'] ));

@diff = qw(-A -B -C -D * );
$parts = detect(\@diff);
@temps = Template::Reverse::Converter::TT2::Convert($parts);
ok( eq_array( \@temps, ['A B C D [% data1 %]'] ));

@diff = qw(* -B -C -D -E);
$parts = detect(\@diff);
@temps = Template::Reverse::Converter::TT2::Convert($parts);
ok( eq_array( \@temps, ['[% data1 %] B C D E'] ));

@diff = qw(-A * -C * -E);
$parts = detect(\@diff);
@temps = Template::Reverse::Converter::TT2::Convert($parts);
ok( eq_array( \@temps, ['A [% data1 %] C','C [% data2 %] E'] ));

@diff = qw(-A -B -C * -G -H -I -J -K * -M -N);
$parts = detect(\@diff);
@temps = Template::Reverse::Converter::TT2::Convert($parts);
ok( eq_array( \@temps, ['A B C [% data1 %] G H I J K','G H I J K [% data2 %] M N'] ));

@diff = qw(* -A -B -C * -G -H -I -J -K * -M -N * );
$parts = detect(\@diff);
@temps = Template::Reverse::Converter::TT2::Convert($parts);
ok( eq_array( \@temps, ['[% data1 %] A B C','A B C [% data2 %] G H I J K','G H I J K [% data3 %] M N','M N [% data4 %]'] ));


@diff = qw(-I -went -to -the * -when -i -had -met -the * );
$parts = detect(\@diff);
@temps = Template::Reverse::Converter::TT2::Convert($parts);
ok( eq_array( \@temps, [
          'I went to the [% data1 %] when i had met the',
          'when i had met the [% data2 %]'
]));

done_testing();
