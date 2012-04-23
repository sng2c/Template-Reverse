# Template::Reverse

Template::Reverse detects different parts between pair of similar text as merged texts from same template.

And it can makes an output marked differences, encodes to TT2 format for being use by Template::Extract module.

    use Template::Reverse;
    my $rev = Template::Reverse->new({
            spacers=>['Template::Reverse::Spacer::Number'],         # put spaces around Numbers. [OPTIONAL]
            splitter=>'Template::Reverse::Splitter::Whitespace',    # and splitting text by white spaces. [DEFAULT]
    });

    my $parts = $rev->detect($output1, $output2); # returns [ [[PRE],[POST]], ... ]

    use Template::Reverse::Converter::TT2;
    my @templates = Template::Reverse::TT2Converter::Convert($parts); # named 'value1','value2',...

more

    # try this!!
    use Template::Reverse;
    use Template::Reverse::Converter::TT2;
    use Data::Dumper;

    my $rev = Template::Reverse->new;

    # generating patterns automatically!!
    my $str1 = "I am perl and smart";
    my $str2 = "I am khs and a perlmania";
    $parts = $rev->detect($str1, $str2);
    @temps = Template::Reverse::Converter::TT2::Convert($parts);

    # spacing text for normalization.
    my $str3 = "I am king of the world and a richest man";
    my $str3spaced = $rev->space($str3);

    # extract!!
    use Template::Extract;
    my $ext = Template::Extract->new;
    my $data1 = $ext->extract($temps[0], $str3spaced));
    print Dumper($data1);
    my $data2 = $ext->extract($temps[1], $str3spaced));
    print Dumper($data2);


