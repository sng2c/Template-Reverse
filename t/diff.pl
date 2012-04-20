#!/usr/bin/perl


sub makeMap{
    my @asc = qw(a b c d e f g h i j k l m n o p q r s t u v w x y z 0 1 2 3 4 5 6 7 8 9 );
    my $str = shift;
    my $len = shift;
    my $cnt = $len;
    my $sum=0;
    my $out='';
    my @chunk = split(/\s+/,$str);
    for(my $i=0; $i<@chunk; $i++ )
    {
        my @c = split(//,$chunk[$i]);
        $sum=0;
        map{$sum+=ord($_);}@c;

        
        $out.= $asc[$sum % @asc]."\n";
    }
    return $out;
}



my ($f1,$f2) = @ARGV;

undef($/);
open(FILE,$f1);
my $s1 = <FILE>;
close(FILE);

my $map = makeMap($s1,50);
print $map."\n";
print length($s1) ." , " .length($map)."\n";
