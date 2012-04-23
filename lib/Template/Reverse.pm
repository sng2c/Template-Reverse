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
    foreach my $str (@strs){
        push(@res, [$splitter_class->Split($str)]);
    }

    my $diff = _diff($res[0],$res[1]);

    my $pattern = _detect($diff);
    return $pattern;
}

sub space{
    my $self = shift;
    my $str = shift;
    foreach my $spacer_class (@{$self->spacers()}){
        load $spacer_class;
        $str = $spacer_class->Space($str);
    }
    return $str;
}

# ABSTRACT: turns baubles into trinkets
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

=cut
1;
