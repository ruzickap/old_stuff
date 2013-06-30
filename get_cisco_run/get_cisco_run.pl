#!/usr/bin/perl
# With some other Unix Os, first line may be
# #!/usr/local/bin/perl -w

#-------------------------------------------------------
# Main
#-------------------------------------------------------

if ($#ARGV != 0) { print "
Usage: get_cisco_run.pl file

Thi file should contain:

<hostname>#sh run

"; exit(1); }


open(FILE, "$ARGV[0]") or die "Can't open file: $ARGV[0]\n";
while ($line = <FILE>) {
  if ($line =~ /([^#]*)#\s*sh\s+run.*/) {
    $hostname=$1;
  }  
  if (($line =~ /Building configuration.../) or ($line =~ /^!Generated on/)) {
    my @output_array = ();
    do {
      push(@output_array,$line);
      if ($line =~ /^\s*hostname\s+(\S+)/) { $hostname=$1; }
    } while (($line = <FILE>) and ($line !~ /^end/) and ($line !~ /^${hostname}#/));
    
    if ($line !~ /^${hostname}#/)  { 
      push(@output_array,$line);
    }
    mkdir("$hostname");
    print "$hostname\n";
    open(FILEW, ">./$hostname/running_config") or die "Can't open/write file: $hostname/running_config\n";
    foreach (@output_array) { printf (FILEW "$_"); }
    close (FILEW);
  }  
}

close(FILE);
