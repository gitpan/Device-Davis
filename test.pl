# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $| = 1; print "1..4\n"; }
END {print "not ok 1\n" unless $loaded;}
use Device::Davis;
$loaded = 1;
print "ok 1\n";

######################### End of black magic.

# Insert your test code below (better if it prints "ok 13"
# (correspondingly "not ok 13") depending on the success of chunk 13
# of the test code):
#use POSIX;
#use POSIX qw(:errno_h :fcntl_h strftime);
#use Fcntl;
print "Enter the full path to the tty to use (i.e. /dev/tty??)  ";
my $tty = <>;
chomp($tty);
# Open the tty
$fd = station_open($tty);
$SIG{ALRM} = \&time_out; # set up timeout trap on serial port IO
sub time_out{
# Cause subroutine to die in response to alarm, which allows jumping back into
# script at line following close of eval block.
die "Time out reading serial port.";
};
$count = 0;
wake_up();
sub wake_up{
if($count > 3){
	print "not ok 2\n";
	$failed = 1;
};
put_string($fd, "\n");
eval{
alarm(2);  # 2 second timeout
$data[0] = get_char($fd);
$data[1] = get_char($fd);
alarm(0);  # reset timeout
}; # end eval
if($@ =~ /Time out reading serial port/){
        $count++;
        wake_up();
};
if($data[0] == 10 && $data[1] == 13){ # Test for valid responses
        print "ok 2\n";
}else{ # Response was not what was expected so try again
        wake_up();
};
};
put_string($fd, "TEST\n");
$data[0] = get_char($fd); # \n character
$data[1] = get_char($fd); # \r character
$data[2] = get_char($fd);
$data[3] = get_char($fd);
$data[4] = get_char($fd);
$data[5] = get_char($fd);
$data[6] = get_char($fd); # \n character
$data[7] = get_char($fd); # \r character
my $response = pack("C*", $data[2], $data[3], $data[4], $data[5]);
if($response eq 'TEST'){
	print "ok 3\n";
}else{ 
	print "not ok 3\n"; 
	$failed = 1; 
};
my $old_crc = 0;
my $crc = 0;
$crc = crc_accum($old_crc, 0xc6);
$old_crc = $crc;
$crc = crc_accum($old_crc, 0xce);
$old_crc = $crc;
$crc = crc_accum($old_crc, 0xa2);
$old_crc = $crc;
$crc = crc_accum($old_crc, 0x03);
$old_crc = $crc;
$crc = crc_accum($old_crc, 0xe2);
$old_crc = $crc;
$crc = crc_accum($old_crc, 0xb4);
if($crc == 0){
	print "ok 4\n";
}else{
	print "not ok 4\n";
	$failed = 1;
};
print "All Tests Successful\n" unless $failed; 
