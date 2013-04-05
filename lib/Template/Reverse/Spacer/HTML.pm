package Template::Reverse::Spacer::HTML;

# ABSTRACT: Insert spaces around html tags and attrs

use Any::Moose;
use namespace::autoclean;

# VERSION

sub Space{
    my $self = shift;
    my $str = shift;
    my $spaced = _space($str);
	return $spaced;
}


sub _space{
    my $str = shift;
	
	# around html 
	$str =~ s/<.+?>/ $& /g;
	# around attr
	$str =~ s/=\s*(["']?)([^>\1]+)\1/=$1 $2 $1/g;

    $str =~ s/\s+/ /g;
    $str =~ s/^\s//g;
    $str =~ s/\s$//g;
    return $str;
}

=pod

=head1 SYNOPSIS
    
    package Template::Reverse::Spacer::HTML;
    my $num = Template::Reverse::Spacer::HTML->new;
    $num->Space('<a href="http://test.com">TEST</a>'); # '<a href=" http://test.com "> TEST </a>'

=cut

__PACKAGE__->meta->make_immutable;
1;
