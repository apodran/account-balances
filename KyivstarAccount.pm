package KyivstarAccount;

use strict;
use warnings;
use feature ":5.14";

use base qw(Account);

use Carp;
use Scalar::Util qw(blessed);
use WWW::Mechanize;

use vars qw($DEBUG);

$DEBUG = 0;

use constant URL => 'https://account.kyivstar.ua/cas/login';

sub login {
    my $self = shift;
    foreach my $f (qw(url username password)) {
        croak "No $f stored" unless $self->{$f};
    }
    $self->mech->get( $self->{url} );
    my $form = $self->mech->form_id('auth-form');
    croak 'No login form found' unless $form;
    $self->mech->field( 'username' => $self->{username} );
    $self->mech->field( 'password' => $self->{password} );
    $self->mech->click();
    print $self->mech->content;
    my $link = $self->mech->find_link( url => '/ecare/' );

    if ( $link && blessed($link) && $link->[0] ) {
        return 1;
    }
    return 0;
}    ## --- end sub login
#
#sub balance {
#    my $self = shift;
#
#    my $content = $mech->content( charset => 'UTF-8' );
#    my $p       = HTML::TokeParser->new( \$content );
#    my $balance = '';
#    while ( my $token = $p->get_tag('div') ) {
#        if ( $token->[1]{class} =~ /^balance\s*$/x ) {
#            $balance = $p->get_text( '/div', 'br' );
#            last;
#        }
#    }
#
#    if ($DEBUG) {
#        if ( $balance =~ /^([+-]\d+\.\d*)\s+грн/ux ) {
#            say "BALANCE: " . $1;
#        }
#        else {
#            say "BALANCE:\n" . $balance;
#            say "CONTENT:\n" . $content;
#        }
#    }
#
#    if ( $balance =~ /^([+-]\d+\.\d*)\s/ux ) {
#        return $1;
#    }
#
#    return $balance;
#}    ## --- end sub login

1;
