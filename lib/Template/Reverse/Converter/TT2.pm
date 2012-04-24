package Template::Reverse::Converter::TT2;

use Moose;
our $VERSION = '0.001';
sub Convert{
    my $self = shift;
    my $parts = shift;
    my @temps;

    foreach my $pat (@{$parts}){
        my @pre = @{$pat->[0]};
        my @post = @{$pat->[1]};
        my $pretxt = join ' ',@pre;
        my $posttxt = join ' ',@post;
        $pretxt .= ' ' if $pretxt;
        $posttxt = ' '.$posttxt if $posttxt;
        push(@temps,$pretxt."[\% value \%]".$posttxt);
    }

    return \@temps;
}


=pod

=head1 NAME

Template::Reverse::Convert::TT2 - Convert parts to TT2 format simply

=head1 SYNOPSIS
    
    package Template::Reverse::Converter::TT2;
    my $tt2 = Template::Reverse::Converter::TT2->new;
    $tt2->Convert([[['pretext'],['posttext']]]);

=cut

1;
