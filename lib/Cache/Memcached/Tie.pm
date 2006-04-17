package Cache::Memcached::Tie;

use strict;
use warnings;

use AutoLoader qw(AUTOLOAD);

use base 'Cache::Memcached';
use vars qw($VERSION);
$VERSION = '0.01';

sub TIEHASH{
    my $package=shift;
    my @params=@_;
    my $self=$package->new(@params);
    return $self;
}

sub STORE{
    my $self=shift;
    my $key=shift;
    my $value=shift;
    $self->{cache}->set($key=>$value);    
}

sub FETCH{ # Returns value or hashref (key=>$value)
    my $self=shift;
    my @keys=split "\x1C", shift; # Some hack for multiple keys
    if (@keys==1){
        return $self->get($keys[0]);
    } else {
        return $self->get_multi(@keys);
    }
}

sub DELETE{
    my $self=shift;
    my $key=shift;
    $self->delete($key);
}

sub UNTIE{
    my $self=shift;
    $self->disconnect_all();
}

1;
__END__

=head1 NAME

Cache::Memcached::Tie - Using Cache::Memcached as hash

=head1 SYNOPSIS

    #!/usr/bin/perl -w
    use strict;
    use Cache::Memcached::Tie;
    
    my %hash;
    my $memd=tie %hash,'Cache::Memcached::Tie', {servers=>['192.168.0.77:11211']};
    $hash{b}=['a',{b=>'a'}];
    print $hash{'a'};
    print $memd->get('b');

=head1 DESCRIPTION

Tie for memcached.
Read `perldoc perltie`

=head1 AUTHOR

Andrew Kostenko E<lt>gugu@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

GNU GPL

=cut
