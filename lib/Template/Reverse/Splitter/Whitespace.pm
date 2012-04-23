package Template::Reverse::Splitter::Whitespace;

sub Split{
    shift;
    my $str = shift;
    return split(/\s+/,$str);
}
1;
