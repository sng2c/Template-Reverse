package Template::Reverse;
use Any::Moose;
use namespace::autoclean;
use Module::Load;
use Carp;
our $VERSION = '0.005';


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

has 'sidelen' => (
    is=>'rw',
    isa=>'Int',
    default => 10
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

    my $pattern = _detect($diff,$self->sidelen());
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
    my $sidelen = shift;
    $sidelen = 0 unless $sidelen;

    my @d = @{$diff};
    my $lastStar = 0;
    my @res;
    for(my $i=0; $i<@d; $i++)
    {
        if( $d[$i] eq '*' )
        {
            my $from = $lastStar;
            my $to = $i-1;
            my @pre = map{substr($_,1);}@d[$from..$to];
            
            my $j = @d;
            if( $i+1 < @d ){
                for( $j=$i+1; $j<@d; $j++)
                {
                    if( $d[$j] eq '*' ){
                        last;
                    }
                }
            }
            $from = $i+1;
            $to = $j-1;
            my @post =  map{substr($_,1);}@d[$from..$to];

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

Template::Reverse - A template generator getting different parts between pair of text

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

=head4 spacers=>[$spacer_pakcage, ...]

=head4 splitter=>$splitter_package

=head4 sidelen=>$max_length_of_each_side

=head3 detect($text1, $text2)

Get changable part list from two texts.
It returns like below

    $rev->detect('A b C','A d C');
    #
    # [ [ ['A'],['C'] ] ]
    #   : :...: :...: :     
    #   :  pre  post  :
    #   :.............:  
    #       part 1
    #

    $rev->detect('A b C d E','A f C g E');
    #
    # [ [ ['A'], ['C'] ], [ ['C'], ['E'] ] ]
    #   : :...:  :...: :  : :...:  :...: :
    #   :  pre   post  :  :  pre   post  :
    #   :..............:  :..............:
    #        part 1            part 2
    #

    $rev->detect('A1 A2 B C1 C2 D E1 E2','A1 A2 D C1 C2 F E1 E2');
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

=head3 space($text)

It returns a normalized text same as in detect().
Text are processed by Spacers in order.
Finding parts in texts, you must use this function with the texts.

=cut

__PACKAGE__->meta->make_immutable;
1;
