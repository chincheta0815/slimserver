package Slim::Utils::OS::Solaris;

# Logitech Media Server Copyright 2001-2011 Logitech.
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License,
# version 2.

use strict;
use File::Spec::Functions qw(:ALL);
use base qw(Slim::Utils::OS::Unix);

use Config;

sub initDetails {
	my $class = shift;

	$class->{osDetails}->{'os'} = 'Solaris';

	$class->{osDetails}->{osName} = getFlavor();
	$class->{osDetails}->{uid}    = getpwuid($>);
	$class->{osDetails}->{osArch} = $Config{'myarchname'};

        $class->{osDetails}->{isSolaris} = 1;

        if ( $class->{osDetails}->{'binArch'} =~ /^(?:i86pc-solaris).*/ ) {
                $class->{osDetails}->{'binArch'} = 'i86pc-solaris';
        }

	return $class->{osDetails};
}


sub getFlavor {
	if (-f '/etc/release') && (-f '/etc/os-release') {
                my $osName;
                open(my $fh, '<:encoding(UTF-8)', '/etc/os-release');
                while (my $row = <$fh>) {
		        if ( $row =~ /^NAME=\"(\w+)\"$/ ) {
                            $osName = $1;
                        }
                }
                close(fh);
                if ( $osName eq /omnios/i) {
                        return $osName;
                }
	}
        elsif (-f '/etc/release') {
                my $osName;
                open(my $fh, '<:encoding(UTF-8)', '/etc/release');
                while (my $row = <$fh>) {
                        if ( $row =~ /^\s+OpenIndiana\s.*$/ ) {
                            $osName = 'OpenIndiana';
                        }
                }
                close(fh);
                return $osName;
        }
        elsif (-f '/etc/release') {
                my $osName;
                open(my $fh, '<:encoding(UTF-8)', '/etc/release');
                while (my $row = <$fh>) {
                        if ( $row =~ /^\s+SmartOS\s.*$/ ) {
                            $osName = 'SmartOS';
                        }
                }
                close(fh);
                return $osName;
        }
        elsif (-f '/etc/release') {
                my $osName;
                open(my $fh, '<:encoding(UTF-8)', '/etc/release');
                while (my $row = <$fh>) {
                        if ( $row =~ /^\s+Oracle\ Solaris\s.*$/ ) {
                            $osName = 'Oracle Solaris';

                        }
                }
                close(fh);
                return $osName;
        }

	return 'Solaris';
}

sub initSearchPath {
        my $class = shift;
        my $baseDir = shift || $class->dirsFor('Bin');

        $class->SUPER::initSearchPath(@_);

        my @paths = ();
        push @paths, catdir($baseDir, $class->{osDetails}->{'binArch'});
        push @paths, catdir($baseDir, $^O);
        push @paths, $baseDir;

        Slim::Utils::Misc::addFindBinPaths(@paths);
}

1;
