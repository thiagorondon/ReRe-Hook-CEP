package ReRe::Hook::CEP;
use strict;
use Moose::Role;

# VERSION
# ABSTRACT: ReRe::Hook::CEP for http://cep.opendatabr.org/

sub _hook {
    my $self = shift;
    my $args = $self->args;
    my $method = $self->method;
    my $ret;

    if ($method eq 'set') {
        my ($cep, $key, $value) = @{$args};
        $self->conn->hdel($cep, $value) if $self->conn->hexists($cep, $value);
        $ret = $self->conn->hset("$cep", "$key", "$value");
    } elsif ($method eq 'get') {
        my ($cep) = @{$args};
        my $keys = $self->conn->hgetall("$cep");
        my %data;
        for ( my $loop = 0 ; $loop < scalar(@{$keys})/2; $loop++ ) {
            my $x = $keys->[$loop*2];
            my $y = $keys->[($loop*2)+1];
            $data{$x} = $y;
        }
        $ret = \%data;
    } else {
        $ret = { cep => undef };
    }

    return $ret;
}

1;
