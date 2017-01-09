package Account;

use strict;
use warnings;
use feature ":5.14";

use base qw(Exporter);

use Carp;
use Scalar::Util qw(blessed);
use WWW::Mechanize;

use vars qw($DEBUG);

$DEBUG = 0;

use constant URL => 'http://my.roe.vsei.ua';

sub new {
    ref( my $class = shift ) && croak 'class only';
    my $mech = WWW::Mechanize->new();
    my $self = {
        mech => $mech,
        url  => $class->URL,
    };
    bless $self, $class;
    return $self;
}

sub mech {
    my $self = shift;
    return $self->{mech};
}    ## --- end sub mech

sub url {
    my $self = shift;
    return $self->{url};
}    ## --- end sub url

sub set_url {
    my $self = shift;
    my $url  = shift;
    croak 'No URL given' unless $url;
    $self->{url} = $url;
    return $url;
}    ## --- end sub set_url

sub set_username {
    my $self     = shift;
    my $username = shift;
    croak 'No username given' unless $username;
    $self->{username} = $username;
    return $username;
}    ## --- end sub set_username

sub set_password {
    my $self     = shift;
    my $password = shift;
    croak 'No password given' unless $password;
    $self->{password} = $password;
    return $password;
}    ## --- end sub set_username

# Empty base class method
sub login {
    return 0;
}    ## --- end sub login

sub balance {
    return "Method is not implemented yet";
}    ## --- end sub login

1;
