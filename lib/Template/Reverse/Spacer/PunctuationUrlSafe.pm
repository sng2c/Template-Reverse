package Template::Reverse::Spacer::PunctuationUrlSafe;

# ABSTRACT: Insert spaces around punctuations.

use Any::Moose;
use namespace::autoclean;

# VERSION

sub Space{
    my $self = shift;
    my $str = shift;
    my $spaced = _space($str);
	return _recover_url($spaced);
}

sub _recover_url{
	my $str = shift;
	$str=~s/(href =['"] )([^'"]+)( ['"])/$1._removeSpace($2).$3/gse;
	$str=~s/(src =['"] )([^'"]+)( ['"])/$1._removeSpace($2).$3/gse;
	return $str;
}

sub _removeSpace{
	my $str = shift;
	$str =~ s/\s+//g;
	return $str;
}

sub _space{
    my $str = shift;
	#$str =~ s/([`!\@\$^*()\[\]{}'",<>\|\\]+)/_punc($`,$1,$')/ge;
	$str =~ s/([~`!\@#\$\%^&*()_+\-=\[\]{};:'",<\.>\/\?\|\\]+)/_punc($`,$1,$')/ge;

    $str =~ s/\s+/ /g;
    $str =~ s/^\s//g;
    $str =~ s/\s$//g;
    return $str;
}
sub _punc{
    my ($p,$m,$n) = @_;

    if( $m =~/[\.,]/ && $p =~ /\d$/ && $n =~ /^\d/  ){
        return $m;
    }
    else{
        return " $m ";
    }
}

=pod

=head1 SYNOPSIS
    
    package Template::Reverse::Spacer::PunctuationUrlSafe;
    my $num = Template::Reverse::Spacer::Punctuation->new;
    $num->Space('aaa http://test.com aaa'); # 'aaa http://test.com aaa'

=cut

__PACKAGE__->meta->make_immutable;
1;
