#!/usr/bin/perl
# With some other Unix Os, first line may be
# #!/usr/local/bin/perl -w

use  Net::Telnet::Cisco;

$logs_dir="./logs/";
$debug_dir="./debug/";
$timeout=10;

#-------------------------------------------------------
# Main
#-------------------------------------------------------

if ($#ARGV != 0) { print "
Usage: ciscoconf.pl file

Thi file should look like this:

password;enable_password;ip_address

"; exit(1); }

if ( ! -d $logs_dir ) { 
  mkdir ($logs_dir,0755) or die "I can't create logs directory $logs_dir!\n";
}
if ( ! -d $debug_dir ) {
  mkdir ($debug_dir,0755) or die "I can't create logs directory $debug_dir!\n";
}

open(FILE, "$ARGV[0]") or die "Can't open file: $ARGV[0]\n";
while ($line = <FILE>) {
  if ($line =~ /^#/) { next; }
  chomp($line);
  ($password, $enable_password, $host) = split(/;/,$line);
  
  print "\nHost: $host\n";
  my $session = Net::Telnet::Cisco->new(
    Host => "$host",
    Input_log => "$debug_dir/$host.log",
    Timeout => $timeout,
    Errmode => "return",
  );
 
  if (not defined($session)) {
    warn "\nCouldn't connect to host: $host\n";
    next;
  }
 
  print "passwrod: $password ; enable_password: $enable_password ; host: $host\n";
  if (not $session->login( Password => "$password", Timeout => 5, )) { 
    warn "\nBad Password: " . $session->errmsg . "\n";
    next;
  }
  
  my @output = $session->cmd('show version');
  open (LOGFILE, ">$logs_dir/$host-version");
  print (LOGFILE @output);
  close (LOGFILE);

  # Enable mode
  if (not $session->enable("$enable_password")) {
    warn "\nCan't enable: " . $session->errmsg . "\n";
  }
  
  @output = $session->cmd("sh run");
  open (LOGFILE, ">$logs_dir/$host-config");
  print (LOGFILE @output);
  close (LOGFILE);
  $session->close;  
}
