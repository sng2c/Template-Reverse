package Template::Reverse::Converter::TT2;



sub Convert{
    my $parts = shift;
    my @temps;

    my $dataidx = 1;
    foreach my $pat (@{$parts}){
        my @pre = @{$pat->[0]};
        my @post = @{$pat->[1]};
        my $pretxt = join ' ',@pre;
        my $posttxt = join ' ',@post;
        $pretxt .= ' ' if $pretxt;
        $posttxt = ' '.$posttxt if $posttxt;
        push(@temps,$pretxt."[\% data$dataidx \%]".$posttxt);
        $dataidx++;
    }

    return @temps;
}

1;
