use strict;
use warnings;
package Template::Reverse;
# ABSTRACT: turns baubles into trinkets
use Algorithm::Diff qw(LCS LCS_length LCSidx diff sdiff compact_diff traverse_sequences traverse_balanced);
sub dd{
    my ($a,$b) = @_;

    my @d = sdiff($a,$b);
    my @rr;
    my $before='';
    for my $r (@d){
        if( $r->[0] eq 'u' ){
            push(@rr,$r->[1]);
            $before = '';
        }
        else{
            push(@rr,'*') if( $before ne '*' );
            $before = '*';
        }
    }
    return \@rr;
}

sub makeMap{
    my @asc = qw(a b c d e f g h i j k l m n o p q r s t u v w x y z 0 1 2 3 4 5 6 7 8 9 );
    my $str = shift;
    my $spaced = space($str);
    my @chunk = split(/\s+/,$spaced);

    my $out='';
    foreach my $c (@chunk)
    {
        my $sum=checksum($c);
        $out.= $asc[$sum % @asc];
    }
    return $out;
}

sub space{
    my $str = shift;
    $str =~ s/(\d[\d,]*(\.\d+)?)(\D)/$1 $3/gm;
    $str =~ s/([^,.\d])(\d[\d,]*(\.\d+)?)/$1 $2/gm;
    $str =~ s/\s+/ /g;
    $str =~ s/^\s//g;
    $str =~ s/\s$//g;
    return $str;
}

sub checksum{
    my $str = shift;
    my $sum = 0;
    map{$sum+=ord($_)}split(//,$str);
    return $sum;
}


1;
