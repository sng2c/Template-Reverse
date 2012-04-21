use Test::More ;
use Data::Dumper;

BEGIN{
};

use Template::Reverse;

sub dd{
    my ($a,$b) = @_;
    return Template::Reverse::_diff($a,$b);
}

my (@seq1,@seq2,@exp,$diff);

@seq1 = qw( A B C D E F );
@seq2 = qw( A B C D E F );
@exp  = qw( A B C D E F );
$diff = dd(\@seq1,\@seq2);
print Dumper($diff);
ok eq_array($diff, \@exp), 'sdiff test';

@seq1 = qw( A B C D E F );
@seq2 = qw( A B C   E F );
@exp  = qw( A B C * E F );
$diff = dd(\@seq1,\@seq2);
print Dumper($diff);
ok eq_array($diff, \@exp), 'sdiff test';

@seq1 = qw( A B C D E F );
@seq2 = qw( A B     E F );
@exp  = qw( A B * E F );
$diff = dd(\@seq1,\@seq2);
print Dumper($diff);
ok eq_array($diff, \@exp), 'sdiff test';

@seq1 = qw( A B C D E F );
@seq2 = qw( B     E F );
@exp  = qw( * B * E F );
$diff = dd(\@seq1,\@seq2);
print Dumper($diff);
ok eq_array($diff, \@exp), 'sdiff test';

@seq1 = qw( A B C D E F );
@seq2 = qw(   B C D E );
@exp  = qw( * B C D E * );
$diff = dd(\@seq1,\@seq2);
print Dumper($diff);
ok eq_array($diff, \@exp), 'sdiff test';

done_testing();
