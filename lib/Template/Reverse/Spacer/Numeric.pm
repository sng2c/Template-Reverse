package Template::Reverse::Spacer::Numeric;

sub Space{
    shift;
    my $str = shift;
    return _space($str);
}

sub _space{
    my $str = shift;
    $str =~ s/(\d[\d,]*(\.\d+)?)(\D)/$1 $3/gm;
    $str =~ s/([^,.\d])(\d[\d,]*(\.\d+)?)/$1 $2/gm;
    $str =~ s/\s+/ /g;
    $str =~ s/^\s//g;
    $str =~ s/\s$//g;
    return $str;
}


1;
