package NovusAccount;

use strict;
use warnings;
use feature ":5.14";

use base qw(Account);

use Carp;
use Scalar::Util qw(blessed);
use WWW::Mechanize;

use vars qw($DEBUG);

$DEBUG = 0;

use constant URL => 'https://my.novus.com.ua/login';

sub login {
    my $self = shift;
    foreach my $f (qw(url username password)) {
        croak "No $f stored" unless $self->{$f};
    }
    $self->mech->get( $self->{url} );
    my $form = $self->mech->form_id('aspnetForm');
    croak 'No login form found' unless $form;
    $self->mech->field( 'ctl00$cphMain$txtLogin' => $self->{username} );
    $self->mech->field( 'ctl00$cphMain$txtPass' => $self->{password} );
    $self->mech->click();

    # Find this link: <a href="/balance">Виписка по картці</a>
    my $link = $self->mech->find_link( url => '/balance' );

    if ( $link && blessed($link) && $link->[0] ) {
        return 1;
    }
    return 0;
}    ## --- end sub login

sub balance {
    my $self = shift;

    my $content = $self->mech->content( charset => 'UTF-8' );
    my $p = HTML::TokeParser->new( \$content );

    while ( my $token = $p->get_tag('div') ) {
        if ( $token->[1]{class} =~ /\bcontent-block\b/x ) {
            last;
        }
    }

    my $balance = '';
    while ( my $token = $p->get_tag('table') ) {
        if ( $token->[1]{class} =~ /\btable-bordered\b/x ) {
            $balance = $p->get_trimmed_text('/tbody');
            if ( $balance =~ /$self->{username}/ux ) {

                # Table with a ccard number and
                # a text "Баланс за карткою загальний"
                last;
            }
        }
    }

    if ($DEBUG) {
        if ( $balance =~ /\s([+-]?\d+\,\d+)\s+\*$/ux ) {
            say "BALANCE: " . $1;
        }
        else {
            say "BALANCE:\n" . $balance;
            say "CONTENT:\n" . $content;
        }
    }

    if ( $balance =~ /\s([+-]?\d+\,\d+)\s+\*$/ux ) {
        return $1;
    }

    return $balance;
}    ## --- end sub login

1;
