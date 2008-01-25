use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
    if ( $ENV{AUTOMATED_TESTING} ) {
        warn "Can't run under automated testing\n";
        exit 0;
    }
WriteMakefile(
    'NAME'		=> 'Device::Davis',
    'VERSION_FROM'	=> 'Davis.pm', # finds $VERSION
    'PREREQ_PM'		=> {}, # e.g., Module::Name => 1.1
    'LIBS'		=> [''], # e.g., '-lm'
    'DEFINE'		=> '', # e.g., '-DHAVE_SOMETHING'
    'INC'		=> '', # e.g., '-I/usr/include/other'
);
