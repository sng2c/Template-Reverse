use strict;
use warnings;
package Template::Reverse;
use Moose;
use Module::Load;
use Carp;
use Data::Dumper;
our $VERSION = '0.001';


has 'splitter' => (
    is=>'rw', 
    isa => 'Str',
    default => 'Template::Reverse::Splitter::Whitespace'
);

has 'spacers' => (
    is=>'rw',
    isa=>'ArrayRef',
    default => sub{[]}
);

sub detect{
    my $self = shift;
    my @strs = @_;


    # apply Spacers
    for(my $i=0; $i<@strs; $i++){
        $strs[$i] = $self->space($strs[$i]);
    }
    
    my @res;
    my $splitter_class = $self->splitter;
    load $splitter_class;
    my $splitter = $splitter_class->new;
    foreach my $str (@strs){
        push(@res, [$splitter->Split($str)]);
    }
    undef $splitter;

    my $diff = _diff($res[0],$res[1]);

    my $pattern = _detect($diff);
    return $pattern;
}

sub space{
    my $self = shift;
    my $str = shift;
    foreach my $spacer_class (@{$self->spacers()}){
        load $spacer_class;
        my $spacer = $spacer_class->new;
        $str = $spacer->Space($str);
        undef($spacer);
    }
    return $str;
}

use Algorithm::Diff qw(LCS LCS_length LCSidx diff sdiff compact_diff traverse_sequences traverse_balanced);

sub _detect{
    my $diff = shift;
    my @d = @{$diff};
    my $lastStar = 0;
    my @res;
    for(my $i=0; $i<@d; $i++)
    {
        if( $d[$i] eq '*' )
        {
            my @pre = map{substr($_,1);}@d[$lastStar..$i-1];
            
            my $j = @d;
            if( $i+1 < @d ){
                for( $j=$i+1; $j<@d; $j++)
                {
                    if( $d[$j] eq '*' ){
                        last;
                    }
                }
            }
            my @post =  map{substr($_,1);}@d[($i+1)..($j-1)];

            push(@res,[\@pre,\@post]);
            $lastStar = $i+1;
        }
    }
    return \@res;
}

sub _diff{
    my ($a,$b) = @_;

    my @d = sdiff($a,$b);
    my @rr;
    my $before='';
    for my $r (@d){
        if( $r->[0] eq 'u' ){
            push(@rr,'-'.$r->[1]);
            $before = '';
        }
        else{
            push(@rr,'*') if( $before ne '*' );
            $before = '*';
        }
    }
    return \@rr;
}

sub _make_map{
    my @asc = qw(a b c d e f g h i j k l m n o p q r s t u v w x y z 0 1 2 3 4 5 6 7 8 9 );
    my $str = shift;
    my $spaced = _space($str);
    my @chunk = split(/\s+/,$spaced);

    my $out='';
    foreach my $c (@chunk)
    {
        my $sum=_checksum($c);
        $out.= $asc[$sum % @asc];
    }
    return $out;
}

sub _checksum{
    my $str = shift;
    my $sum = 0;
    map{$sum+=ord($_)}split(//,$str);
    return $sum;
}



=pod

=head1 NAME

Template::Reverse - A detector of different parts between pair of text.

=head1 SYNOPSIS

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
    my $parts = $rev->detect($str1, $str2);

    my $tt2 = Template::Reverse::Converter::TT2->new;
    my $temps = $tt2->Convert($parts); # equals ['I am [% value %] and','and [% value %]']


    # spacing text for normalization.
    my $str3 = "I am king of the world and a richest man";
    my $str3spaced = $rev->space($str3);

    # extract!!
    use Template::Extract;
    my $ext = Template::Extract->new;
    my $value = $ext->extract($temps->[0], $str3spaced);
    print Dumper($value); # output : {'value'=>'king of the world'}

    my $value = $ext->extract($temps->[1], $str3spaced);
    print Dumper($value); # output : {'value'=>'a richest man'}

=head1 DESCRIPTION

Template::Reverse detects different parts between pair of similar text as merged texts from same template.
And it can makes an output marked differences, encodes to TT2 format for being use by Template::Extract module.

=head1 FUNCTIONS

=head3 new({spacers=>[$spacer_package1, ...], splitter=>$splitter_package})

Spacers have order.


=head3 detect($text1, $text2)

Get changable part list from two texts.
It returns like below

    $rev->detect('A B C','A D C');
    # [ [ ['A'],['C'] ] ]
    #     ~~~~~         pre texts
    #           ~~~~~   post texts
    #   ~~~~~~~~~~~~~~~ part1

    $rev->detect('A B C D E','A D C F E');
    # [ [ ['A'],['C'] ], [ ['C'], ['E'] ] ]
    #   ~~~~~~~~~~~~~~~                     part1
    #                    ~~~~~~~~~~~~~~~~   part2

    $rev->detect('A1 A2 B C1 C2 D E1 E2','A1 A2 D C1 C2 F E1 E2');
    # [ [ ['A1','A2'],['C2','C2'] ], [ ['C1','C2'], ['E2','E2'] ] ]

Returned arrayRef is list of changable parts.

    1. At first, $text1 and $text2 is normalized by Spacers.
    2. 'pre texts' and 'post texts' are splited by Splitter. In this case, by Whitespace.
    3. You can get a changing value, just finding 'pre' and 'post' in a normalized text.

=head3 space($text)

It returns a normalized text same as in detect().
Text are processed by Spacers in order.
Finding parts in texts, you must use this function with the texts.

=cut
1;
