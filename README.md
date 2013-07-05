# NAME

Template::Reverse - A template generator getting different parts between pair of text

# VERSION

version 0.9

# SYNOPSIS

    use Template::Reverse;
    my $rev = Template::Reverse->new();

    my $parts = $rev->detect($arr_ref1, $arr_ref2); # returns [ [[PRE],[POST]], ... ]

    use Template::Reverse::Converter::TT2;
    my @templates = Template::Reverse::TT2Converter::Convert($parts); # named 'value1','value2',...

more

    # try this!!
    use Template::Reverse;
    use Template::Reverse::Converter::TT2;
    use Data::Dumper;

    my $rev = Template::Reverse->new;

    # generating patterns automatically!!
    my $str1 = [qw(I am perl and smart)];
    my $str2 = [qw(I am khs and a perlmania)];
    my $parts = $rev->detect($str1, $str2);

    my $tt2 = Template::Reverse::Converter::TT2->new;
    my $temps = $tt2->Convert($parts); # equals ['I am [% value %] and','and [% value %]']



    my $str3 = "I am king of the world and a richest man";

    # extract!!
    use Template::Extract;
    my $ext = Template::Extract->new;
    my $value = $ext->extract($temps->[0], $str3);
    print Dumper($value); # output : {'value'=>'king of the world'}

    my $value = $ext->extract($temps->[1], $str3);
    print Dumper($value); # output : {'value'=>'a richest man'}

# DESCRIPTION

Template::Reverse detects different parts between pair of similar text as merged texts from same template.
And it can makes an output marked differences, encodes to TT2 format for being use by Template::Extract module.

# FUNCTIONS

### new(OPTION\_HASH\_REF)

#### sidelen=>$max\_length\_of\_each\_side

sidelen is a short of "side character's each max length".
the default value is 10. Setting 0 means full-length.

If you set it as 3, you get max 3 length pre-text and post-text array each part.

This is needed for more faster performance.

### detect($text1, $text2)

Get changable part list from two texts.
It returns like below

    $rev->detect([qw(A b C)], [qw(A d C)]);
    #
    # [ [ ['A'],['C'] ] ]
    #   : :...: :...: :     
    #   :  pre  post  :
    #   :.............:  
    #       part 1
    #

    $rev->detect([qw(A b C d E)],[qw(A f C g E)]);
    #
    # [ [ ['A'], ['C'] ], [ ['C'], ['E'] ] ]
    #   : :...:  :...: :  : :...:  :...: :
    #   :  pre   post  :  :  pre   post  :
    #   :..............:  :..............:
    #        part 1            part 2
    #

    $rev->detect([qw(A1 A2 B C1 C2 D E1 E2)],[qw(A1 A2 D C1 C2 F E1 E2)]);
    #
    # [ [ ['A1','A2'],['C2','C2'] ], [ ['C1','C2'], ['E2','E2'] ] ]
    #

    my $str1 = "I am perl and smart";
    my $str2 = "I am KHS and a perlmania";
    my $parts = $rev->detect($str1, $str2);
    #
    # [ [ ['I','am'], ['and'] ] , [ ['and'],[] ] ]
    #   : :........:  :.....: :   :            :
    #   :    pre       post   :   :            :
    #   :.....................:   :............:
    #           part 1                part 2
    #

Returned arrayRef is list of changable parts.

    1. At first, $text1 and $text2 is normalized by Spacers.
    2. 'pre texts' and 'post texts' are splited by Splitter. In this case, by Whitespace.
    3. You can get a changing value, just finding 'pre' and 'post' in a normalized text.

# SEE ALSO

- [Template::Extract](http://search.cpan.org/perldoc?Template::Extract)

# SOURCE

[https://github.com/sng2c/Template-Reverse](https://github.com/sng2c/Template-Reverse)

# THANKS TO

- https://metacpan.org/author/AMORETTE

This module is dedicated to AMORETTE.
He was interested in this module and was cheering me up.

# AUTHOR

HyeonSeung Kim <sng2nara@hanmail.net>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by HyeonSeung Kim.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
