# NAME

Template::Reverse - A template generator getting different parts between pair of text

# VERSION

version 0.150

# SYNOPSIS

    use Template::Reverse;
    my $rev = Template::Reverse->new();

    my $parts = $rev->detect($arr_ref1, $arr_ref2); # returns [ Template::Reverser::Part, ... ]

    use Template::Reverse::Converter::TT2;
    my $converter = Template::Reverse::Converter::TT2->new();
    my @templates = $converter->Convert($parts); 

more

    # try this!!
    use Template::Reverse;
    use Data::Dumper;

    my $rev = Template::Reverse->new;

    # generating patterns automatically!!
    my $str1 = ['I',' ','am',' ', 'perl',' ','and',' ','smart']; # White spaces should be explained explicity.
    my $str2 = ['I',' ','am',' ', 'khs' ,' ','and',' ','a',' ','perlmania']; # Use Parse::Lex or Parse::Token::Lite to make it easy.
    my $parts = $rev->detect($str1, $str2);

    my $str3 = "I am king of the world and a richest man";

    # extract with TT2
    use Template::Reverse::Converter::TT2;
    my $tt2 = Template::Reverse::Converter::TT2->new;
    my $templates = $tt2->Convert($parts); # equals to ['I am [% value %] and ',' and [% value %]']

    use Template::Extract;
    my $ext = Template::Extract->new;
    my $value = $ext->extract($templates->[0], $str3);
    print Dumper($value); # output : {'value'=>'king of the world'}

    my $value = $ext->extract($templates->[1], $str3);
    print Dumper($value); # output : {'value'=>'a richest man'}

    # extract with Regexp
    my $regexp_conv = Template::Reverse::Converter::Regexp->new;
    my $regexp_list = $regexp_conv->Convert($parts); 

    my $str3 = "I am king of the world and a richest man";
     
    # extract!!
    foreach my $regexp (@{$regexp_list}){
        if( $str3 =~ /$regexp/ ){
            print $1."\n";
        }
    }

    # When you need to get regexp as string.
    use re regexp_pattern;
    my($pat,$flag) = regexp_pattern( $regexp_list->[0] );
    print $pat; # Regexp generates regexps without flags. So you do not need to use $flag.

# DESCRIPTION

Template::Reverse detects different parts between pair of similar text as merged texts from same template.
And it can makes an output marked differences, encodes to TT2 format for being use by Template::Extract module.

# CI

<div>
    <a href="https://travis-ci.org/sng2c/Template-Reverse"><img src="https://travis-ci.org/sng2c/Template-Reverse.svg?branch=master"></a>
</div>

# FUNCTIONS

### new(OPTION\_HASH\_REF)

#### sidelen=>$max\_length\_of\_each\_side

sidelen is a short of "side character's each max length".
the default value is 10. Setting 0 means full-length.

If you set it as 3, you get max 3 length pre-text and post-text array each part.

This is needed for more faster performance.

### detect($arr\_ref1, $arr\_ref2)

Get an array-ref of [Template::Reverse::Part](https://metacpan.org/pod/Template::Reverse::Part) from two array-refs which contains text or object implements as\_string() method.
A [Template::Reverse::Part](https://metacpan.org/pod/Template::Reverse::Part) class means an one changable token.

It returns like below.

    $rev->detect([qw(A b C)], [qw(A d C)]);
    # 
    # [ { ['A'],['C'] } ] <- Please focus at data, not expression.
    #   : :...: :...: :     
    #   :  pre  post  :
    #   :.............:  
    #       Part #1
    #

    $rev->detect([qw(A b C d E)],[qw(A f C g E)]);
    #
    # [ { ['A'], ['C'] }, { ['C'], ['E'] } ]
    #   : :...:  :...: :  : :...:  :...: :
    #   :  pre   post  :  :  pre   post  :
    #   :..............:  :..............:
    #        Part #1          Part #2
    #

    $rev->detect([qw(A1 A2 B C1 C2 D E1 E2)],[qw(A1 A2 D C1 C2 F E1 E2)]);
    #
    # [ { ['A1','A2'],['C2','C2'] }, { ['C1','C2'], ['E2','E2'] } ]
    #

    my $str1 = [qw"I am perl and smart"];
    my $str2 = [qw"I am KHS and a perlmania"];
    my $parts = $rev->detect($str1, $str2);
    #
    # [ { ['I','am'], ['and'] } , { ['and'],[] } ]
    #   : :........:  :.....: :   :            :
    #   :    pre       post   :   :            :
    #   :.....................:   :............:
    #           Part #1               Part #2
    #

    # You can get same result for object arrays.
    my $objs1 = [$obj1, $obj2, $obj3];
    my $objs2 = [$obj1, $obj3];
    #
    # [ { [ $obj1 ], [ $obj3 ] } ]
    #   : :.......:  :.......: :
    #   :    pre       post    :
    #   :......................:
    #           Part #1

Returned arrayRef is list of changable parts.

You can get a changed token if you find just 'pre' and 'post' sequences on any other token array.

# SEE ALSO

- [Template::Extract](https://metacpan.org/pod/Template::Extract)
- [Parse::Token::Lite](https://metacpan.org/pod/Parse::Token::Lite)

# SOURCE

[https://github.com/sng2c/Template-Reverse](https://github.com/sng2c/Template-Reverse)

# THANKS TO

[https://metacpan.org/author/AMORETTE](https://metacpan.org/author/AMORETTE)

This module is dedicated to AMORETTE.
He was interested in this module and was cheering me up.

# AUTHOR

HyeonSeung Kim <sng2nara@hanmail.net>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by HyeonSeung Kim.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
