# Template::Reverse

Template::Reverse detects different parts between pair of similar text as merged texts from same template.

And it can makes an output marked differences, encodes to TT2 format for being use by Template::Extract module.

    use Template::Reverse;
    my $rev = Template::Reverse->new({
            spacers=>['Template::Reverse::Spacer::Number'],         # at first spacing/unspacing text by
            splitter=>'Template::Reverse::Splitter::Whitespace',    # and splitting text by
    });

    my $parts = $rev->detect($output1, $output2); # returns [ [[PRE],[POST]], ... ]

    use Template::Reverse::TT2Converter;
    my @templates = Template::Reverse::TT2Converter::Convert($parts); # named 'value1','value2',...



