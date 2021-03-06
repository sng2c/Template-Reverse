package Template::Reverse::Util;

# ABSTRACT: Utils

require Exporter;
our @ISA='Exporter';
our @EXPORT = qw(partition partition_by);
# VERSION

# port from Clojure
sub partition{
    my($len, $step, @list) = @_;
    my @ret;
    for(my $i=0; $i<@list-$len+1; $i+=$step){
        my @sublist = @list[$i..$i+$len-1];
        push(@ret, \@sublist);
    }
    return @ret;
}

# port from Clojure
sub partition_by{
    my($funcref, @list) = @_;
    my @ret;
    my $curarr;
    foreach my $item (@list){
        if( $funcref->($item) ){
            if($curarr){
                push(@ret, $curarr);
            }
            push(@ret, [$item]);   
            $curarr = [];
        }
        else{
            push(@{$curarr}, $item);
        }
    }
    push(@ret, $curarr) if @{$curarr} > 0;
    return @ret;
}

1;