@rem = '--*-Perl-*--
@echo off
perl -x -S %0 %*
goto endofperl
@rem '
#!perl
#line 7
print "INC:\n";
foreach(@INC) {
    print "\t\"$_\"\n";
}
exit 0;

__END__
:endofperl
