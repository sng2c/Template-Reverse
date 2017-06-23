package Template::Reverse::Converter::Regexp;

# ABSTRACT: Convert parts to Regular Expression simply

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

		if( $pretxt eq '' || $posttxt eq '' ){
     	   push(@temps,qr!\Q$pretxt\E(.+)\Q$posttxt\E!);
		}
		else{
     	   push(@temps,qr!\Q$pretxt\E(.+?)\Q$posttxt\E!);
		}
	}

    return \@temps;
}


=pod


=head1 SYNOPSIS
    
    package Template::Reverse::Converter::Regexp;
    my $tt2 = Template::Reverse::Converter::Regexp->new;
    my $res = $tt2->Convert([{pre=>['The'],post=>['stuff']}]);
    "The cool stuff" =~ /$res->[0]/;
    print $1; # "cool"

=cut

1;
