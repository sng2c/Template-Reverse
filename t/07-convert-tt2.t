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
ok( eq_array( \@temps, ['A B [% value %] D E'] ));

@diff = qw(-A -B -C -D * );
$parts = detect(\@diff);
@temps = Template::Reverse::Converter::TT2::Convert($parts);
ok( eq_array( \@temps, ['A B C D [% value %]'] ));

@diff = qw(* -B -C -D -E);
$parts = detect(\@diff);
@temps = Template::Reverse::Converter::TT2::Convert($parts);
ok( eq_array( \@temps, ['[% value %] B C D E'] ));

@diff = qw(-A * -C * -E);
$parts = detect(\@diff);
@temps = Template::Reverse::Converter::TT2::Convert($parts);
ok( eq_array( \@temps, ['A [% value %] C','C [% value %] E'] ));

@diff = qw(-A -B -C * -G -H -I -J -K * -M -N);
$parts = detect(\@diff);
@temps = Template::Reverse::Converter::TT2::Convert($parts);
ok( eq_array( \@temps, ['A B C [% value %] G H I J K','G H I J K [% value %] M N'] ));

@diff = qw(* -A -B -C * -G -H -I -J -K * -M -N * );
$parts = detect(\@diff);
@temps = Template::Reverse::Converter::TT2::Convert($parts);
ok( eq_array( \@temps, ['[% value %] A B C','A B C [% value %] G H I J K','G H I J K [% value %] M N','M N [% value %]'] ));


@diff = qw(-I -went -to -the * -when -i -had -met -the * );
$parts = detect(\@diff);
@temps = Template::Reverse::Converter::TT2::Convert($parts);
ok( eq_array( \@temps, [
          'I went to the [% value %] when i had met the',
          'when i had met the [% value %]'
]));

done_testing();
