#!/usr/bin/perl -w
# With some other Unix Os, first line may be
#!/usr/local/bin/perl -w
##########################
## t_mobile_to_1rstwap
## Copyright(c) 2002 Petr Ruzicka
## ruzickap@volny.cz
## Version 0.1
##########################

# Skript pro preformatovani vsech T-Mobilovych kontaktu na kontakty typu 
# 1rstwap v programu KySMS

use Getopt::Long;

#-------------------------------------------------------
# Main
#-------------------------------------------------------

my ($help,$mounted,$mounted_all) = (0,0,0);

GetOptions(
  'login|l=s' => \$login,
  'passwd|p=s' => \$passwd,
  'help|h' => \$help
);

if (($help == 1)  or ($#ARGV != 0)) { print "
Usage: t_mobile_to_1rstwap.pl < options >

  -l, --login	Login pok kterym je uzivatel zaregistrovan na 1rstwap.com
  -p, --passwp	Heslo pro regisrovaneho uzivatele na 1rstwap.com
  
  -h, --help	Help
    
"; exit(1);}  

 $file=$ARGV[0];

 open(FILE,$file) or die "\nCann't find file: $file!\n";
 open (FILE_NEW,"> $file.new") or die "\nCann't create file: $file.new!\n";
 while ($line = <FILE>) {
  if ($line =~ "Operator=/usr/share/smssend/t-mobile.sms") {
   print FILE_NEW "Operator=/usr/share/smssend/1rstwap.sms\n";
   $line = <FILE>;
   print FILE_NEW $line;
   $line = <FILE>;
   if ($line =~ "NumberOfParameters=3") { print FILE_NEW "NumberOfParameters=5\n"; }
    else { die "\nWrong File!\n"; }
   $line = <FILE>;
   if ($line =~ "Param000=t-mobile") { print FILE_NEW "Param000=1rstwap\n"; }
    else { die "\nWrong File!\n"; }
   $line = <FILE>;
   chomp $line;
   if ($line =~ "Param001=") { 
    my $cislo = ("42");
    $cislo .= substr($line,rindex($line,"=")+1,length($line));
    $line = <FILE>;
    $cislo .= substr($line,rindex($line,"=")+1,length($line));
    print FILE_NEW "Param001=$login\nParam002=$passwd\nParam003=0\nParam004=$cislo";
   }
   else { die "\nWrong File!\n"; }
  }
  else { print FILE_NEW $line; }
 }
 
close (FILE); close (FILE_NEW);

print "\nDone....\n";
