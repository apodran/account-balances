#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use feature ":5.14";

#use feature 'unicode_strings';
use open ':std', ':encoding(UTF-8)';

use Carp;
use Encode;
use Getopt::Long;

use KyivstarAccount;
use NovusAccount;
use ROEnergoAccount;

my $debug = 0;

my ( $use_roe, $use_novus, $username, $password );

GetOptions(
    'roe|energo' => \$use_roe,
    'novus'      => \$use_novus,
    'username=s' => \$username,
    'password=s' => \$password,
    'debug'      => \$debug,
) or usage();

$Account::DEBUG = 1 if $debug;

usage("Choose an account!") unless $use_roe || $use_novus;

usage("Set username and password!") unless $username && $password;

my $account;

if ($use_novus) {
    $account = NovusAccount->new();
} elsif ($use_roe) {
    $account = ROEnergoAccount->new();
} else {
    usage();
}

$account->set_username($username);
$account->set_password($password);
say $account->url;
my $logged_in = $account->login;

my $balance = '';
if ($logged_in) {
    $balance = $account->balance;
}

say "Balance from site: $balance";

exit;

sub usage {
    my ($text) = @_;

    say $text. "\n" if $text;

    die "Usage: $0 [--debug] --<roe|energo|novus> --username <name> --password <password>\n";
}
