package Template::Reverse::Spacer::Punctuation;
use Any::Moose;
use namespace::autoclean;

# VERSION

sub Space{
    my $self = shift;
    my $str = shift;
    return _space($str);
}

sub _space{
    my $str = shift;
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

=head1 NAME

Template::Reverse::Spacer::Punctuation - Insert spaces around punctuations.

=head1 SYNOPSIS
    
    package Template::Reverse::Spacer::Punctuation;
    my $num = Template::Reverse::Spacer::Punctuation->new;
    $num->Space('hello,world!!'); # 'hello , world !!'

=cut

__PACKAGE__->meta->make_immutable;
1;
