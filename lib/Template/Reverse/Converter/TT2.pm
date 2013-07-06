package Template::Reverse::Converter::TT2;

# ABSTRACT: Convert parts to TT2 format simply

use Moo;
use Scalar::Util qw(blessed);
# VERSION

sub Convert{
    my $self = shift;
    my $parts = shift;
    my @temps;

    foreach my $pat (@{$parts}){
        my @pre = @{$pat->pre};
        my @post = @{$pat->post};

        @pre = map{blessed($_)?$_->as_string:$_}@pre;
        @post= map{blessed($_)?$_->as_string:$_}@post;
        my $pretxt = join ' ',@pre;
        my $posttxt = join ' ',@post;
        $pretxt .= ' ' if $pretxt;
        $posttxt = ' '.$posttxt if $posttxt;
        push(@temps,$pretxt."[\% value \%]".$posttxt);
    }

    return \@temps;
}


=pod


=head1 SYNOPSIS
    
    package Template::Reverse::Converter::TT2;
    my $tt2 = Template::Reverse::Converter::TT2->new;
    $tt2->Convert([[['pretext'],['posttext']]]);

=cut

1;
