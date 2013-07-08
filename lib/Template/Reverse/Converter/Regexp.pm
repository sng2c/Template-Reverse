package Template::Reverse::Converter::Regexp;

# ABSTRACT: Convert parts to Regular Expression simply

use Moo;
use Scalar::Util qw(blessed);
use utf8;
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
        my $pretxt = join '',@pre;
        my $posttxt = join '',@post;
        $pretxt .= '' if $pretxt;
        $posttxt = ''.$posttxt if $posttxt;

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
    my $res = $tt2->Convert([[['pretext'],['posttext']]]);
	"Some text" =~ /$res/;
	print $1;

=cut

1;
