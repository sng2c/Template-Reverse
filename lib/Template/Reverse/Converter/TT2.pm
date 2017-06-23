package Template::Reverse::Converter::TT2;

# ABSTRACT: Convert parts to TT2 format simply

use Moo;
use utf8;
# VERSION

sub Convert{
    my $self = shift;
    my $parts = shift;
    my @temps;

    foreach my $pat (@{$parts}){
        my @pre = @{$pat->{pre}};
        my @post = @{$pat->{post}};

        @pre = grep{!ref($_)}@pre;
        @post= grep{!ref($_)}@post;
        my $pretxt = join '',@pre;
        my $posttxt = join '',@post;
        $pretxt .= '' if $pretxt;
        $posttxt = ''.$posttxt if $posttxt;
        push(@temps,$pretxt."[\% value \%]".$posttxt);
    }

    return \@temps;
}


=pod


=head1 SYNOPSIS
    
    use Data::Dumper;
    use Template::Reverse::Converter::TT2;
    my $tt2 = Template::Reverse::Converter::TT2->new;
    my $templates = $tt2->Convert([{pre=>['The'],post=>['stuff']}]);
    print Dumper $templates; # [ 'The[% value %]stuff' ];

=cut

1;
