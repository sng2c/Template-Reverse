use Test::More;

BEGIN{
use_ok('Template::Reverse');
}
use Data::Dumper;
sub detect{
    my $diff= shift;
    return Template::Reverse::_detect($diff);
}

@diff = qw(-A -B -C -D -E);
$patt = detect(\@diff);
ok( eq_array($patt, [] ) );

@diff = qw(-A -B * -D -E);
$patt = detect(\@diff);
ok( eq_array($patt, [ [[qw(A B)],[qw(D E)]] ] ) );

@diff = qw(-A -B -C -D * );
$patt = detect(\@diff);
ok( eq_array($patt, [ [[qw(A B C D)],[]] ] ) );

@diff = qw(* -B -C -D -E);
$patt = detect(\@diff);
ok( eq_array($patt, [ [[],[qw(B C D E)]] ] ) );

@diff = qw(-A * -C * -E);
$patt = detect(\@diff);
ok( eq_array($patt, [ [[qw(A)],[qw(C)]], [[qw(C)],[qw(E)]]] ) );


@diff = qw(-A -B -C * -G -H -I -J -K * -M -N);
$patt = detect(\@diff);
ok( eq_array($patt, [ [[qw(A B C)],[qw(G H I J K)]], [[qw(G H I J K)],[qw(M N)]]] ) );

@diff = qw(* -A -B -C * -G -H -I -J -K * -M -N * );
$patt = detect(\@diff);
ok( eq_array($patt, [ [[],[qw(A B C)]],[[qw(A B C)],[qw(G H I J K)]], [[qw(G H I J K)],[qw(M N)]], [[qw(M N)],[]]] ) );


@diff = qw(-I -went -to -the * -when -i -had -met -the * );
$patt = detect(\@diff);
ok( eq_array($patt, 
        [
          [
            [
              'I',
              'went',
              'to',
              'the'
            ],
            [
              'when',
              'i',
              'had',
              'met',
              'the'
            ]
          ],
          [
            [
              'when',
              'i',
              'had',
              'met',
              'the'
            ],
            []
          ]
        ]));

done_testing();
