#!/usr/bin/perl -w
# With some other Unix Os, first line may be
#!/usr/local/bin/perl -w
##########################
## Copyright(c) 2002 Petr Ruzicka
## ruzickap@volny.cz
## version 0.6
##########################

# CDextra - neni
# pri volbe -a=. -nejede ! musim dat -a=* - a nevim jak je to s info


use Getopt::Long;
use locale;

my $publisher_id="PetrR";
my $preparer_id="PetrR";
my $app_id="CDRecord-LINUX";

# Print debugging info (if uncommented)
$DEBUG="";

$argv=$#ARGV;

# Initialization ...
GetOptions(
  'multi|m' => \$multi,
  'blank|b=s' => \$blank,
  'dev_rw|rw=s' => \$dev_rw,
  'dev_read|r=s' => \$dev_read,
  'dev_read_scsi|rs=s' => \$dev_read_scsi,
  'speed|s=i' => \$speed,
  'opt_cdrecord|oc=s' => \$opt_cdrecord,
  'opt_mkisofs|om=s' => \$opt_mkisofs,
  'help|h|?' => \$help,
  'audio|a=s' => \$audio,
  'iso|i=s' => \$iso,
  'mp3|3=s' => \$mp3,
  'ogg|o=s' => \$ogg,
  'data|d=s' => \$data,
  'copy_data|cd' => \$copy_data,
  'volume|v=s' => \$volume,
  'tmp|t=s' => \$tmp,
  'bin|bi=s' => \$bin_cue,
  'eject|e' => \$eject,
  'copy_audio|ca' => \$copy_audio,
  'playlist|l=s' => \$playlist,
  'extra|x=s' => \$cd_extra,
  'copy_mix|cx' => \$copy_mix
);

if (defined($help)) { help(); exit(0); }
# See cdrecord -scanbus
if (! defined($dev_rw)) { $dev_rw="0,0,0" }
if (! defined($dev_read_scsi)) { $dev_read_scsi="0,1,0" }
if (! defined($dev_read)) { $dev_read="/dev/cdrom" }
if (! defined($speed)) { $speed=48 }

# Print menu or work in command mode
if ($argv > -1) { main_program(); }
 else { print_menu(); }


sub main_program {
 if (defined($DEBUG)) { print "
  'multi|m' =>  $multi,
  'blank|b=s' =>  $blank,
  'dev_rw|rw=s' =>  $dev_rw,
  'dev_read|r=s' =>  $dev_read,
  'dev_read_scsi|rs=s' =>  $dev_read_scsi,
  'speed|s=i' =>  $speed,
  'opt_cdrecord|oc=s' =>  $opt_cdrecord,
  'opt_mkisofs|om=s' =>  $opt_mkisofs,
  'help|h|?' =>  $help,
  'audio|a=s' =>  $audio,
  'iso|i=s' =>  $iso,
  'mp3|3=s' =>  $mp3,
  'ogg|o=s' =>  $ogg,
  'data|d=s' =>  $data,
  'copy_data|cd' =>  $copy_data,
  'volume|v|V=s' =>  $volume,
  'tmp|t=s' =>  $tmp,
  'bin|bi=s' =>  $bin_cue,
  'eject|e' =>  $eject,
  'copy_audio|ca' =>  $copy_audio,
  'playlist|l=s' =>  $playlist,
  'extra|x=s' =>  $cd_extra,
  'copy_mix|cx' =>  $copy_mix\n";
 }

 if (! defined($tmp)) { $tmp="/tmp" }

 my $cdrecord_param = "cdrecord driveropts=burnproof dev=ATAPI:$dev_rw speed=$speed -v -overburn";

# It's better to eject CD-RW after burning, becauese Cache...
# if (defined($eject)) { $cdrecord_param .= " -eject "; }
 if (! defined($eject)) { $cdrecord_param .= " -eject "; }
 
 if ($audio eq ".") { $audio=$ENV{"PWD"}; }
 
 if (defined($opt_cdrecord)) { $cdrecord_param .= " $opt_cdrecord "; }

 my $mkisofs_param = "mkisofs -r -J -input-charset iso8859-2 -output-charset iso8859-2 -l -q -R -A \"$app_id\" -p \"$preparer_id\" -P \"$publisher_id\" ";
 if (defined($opt_mkisofs)) { $mkisofs_param .= " $opt_mkisofs "; }

 if (defined($volume)) { 
  if (length($volume) >16) { print "Volume name ($volume) is too long (max 16) !!!\n"; exit(8); }
  $mkisofs_param .= " -V \"$volume\" "; 
 }
 if (defined($multi)) { $cdrecord_param .= " -multi "; }

 if (defined($DEBUG)) { print "\nCDRECORD_PARAM:{$cdrecord_param}\n"; }
 if (defined($DEBUG)) { print "\nMKISOFS_PARAM:{$mkisofs_param}\n"; }

 # Blank
 if (defined($blank)) { return blank($blank,$cdrecord_param); }

 # Copy Data CD
 if (defined($copy_data)) { 
  if (defined($DEBUG)) { print "COPY_DATA:{$cdrecord_param -isosize $dev_read}\n"; }
  if (system("$cdrecord_param -isosize $dev_read") == 0) { print "\n\nCopying COMPLETE\n\n"; }
   else { print STDERR "\nCopying UNSUCCESSFULL !!!\n\n"; return 1; }
  system("eject $dev_read");
  return 0;
 }

 # Audio
 if (defined($audio)) { return errors(audio(" $audio/*.wav ",$cdrecord_param)); }

 #Audio playlist
 if (defined($playlist)) { 
  my $audio="";
  open (PLAYLIST,$playlist) or die "There is problem to open file: $copy_audio";
  while (<PLAYLIST>) {
   next if /^#/;
   next if ($_ eq "");
   chomp;
   $audio.=" \"$_\" ";
  }
  close(PLAYLIST);
  return errors(audio($audio,$cdrecord_param));
 }
  
 # Check if mulrisession
 if (defined($data) || defined($iso) || defined($bin_cue) || defined($cd_extra))  {
    
  if (defined($data) && check($data,"d")) { return errors(3); } 
  if (defined($iso) && check($iso,"f")) { return errors(3); } 
  if (defined($mp3) && check($mp3,"d")) { return errors(3); }
  if (defined($ogg) && check($ogg,"d")) { return errors(3); }
#neni cd extra - nevim zda f nebo d  
  if (defined($cd_extra) && check($cd_extra,"d")) { return errors(3); } 
  
  my $add_session = multi($cdrecord_param);
  if (($add_session =~ /,/) || ($add_session eq "")) { 
   if ($add_session ne "") { 
    print "\nI'll add a new session.\n"; 
    if (defined($cd_extra)) { $mkisofs_param .= " -C $add_session "; $data=$cd_extra; }
     else { $mkisofs_param .= " -C $add_session -M $dev_rw "; }
   }
   else { print "\nI'll create a new session.\n"; }
  } 
  else { errors($add_session); }
 }
   
 # Data
 if (defined($data)) { return errors(data($data,$cdrecord_param,$mkisofs_param)); }

 # Iso
 if (defined($iso)) { return errors(iso($iso,$cdrecord_param)); }

 # Check $tmp directory
 if (-d $tmp) {
  $tmp.="/burnpl_$$";
  if ((mkdir ($tmp)) == 0) { die "I cann't make directory: $tmp!\nCheck permissions\n"; }
  my @files=glob("$tmp/*.iso $tmp/*.wav $tmp/*.inf");
  if (@files != 0) {
   print "There is problem with tmp directory...\nThere are some files like *.wav, *.iso, *.inf int the temp directory ($tmp).\nIt can make some problems ... Should I delete these files? (Y/N)\n";
   chomp(my $choice=<>);
   if (uc($choice) eq "Y") { 
    if (! unlink(@files)) { print  STDERR "I cann't del tmp files: $tmp/* !\n"; }
     else { print "Deleting .... OK\n"; }
   } 
    else { print STDERR "\nI can't contionue .... Quting ....\n"; return 5; }
  }
 } 
 else { print STDERR "I can't open temp dir: $tmp\n"; }

 # Copy audio CD
 if (defined($copy_audio)) { $return=errors(audio_copy($cdrecord_param,$dev_read_scsi,$tmp,$speed)); }

 # Copy Mixed CD
 if (defined($copy_mix)) { $return=errors(copy_mixed_cd($cdrecord_param,$mkisofs_param,$dev_read,$dev_read_scsi,$tmp,$speed)); }
    
 # MP3s
 if (defined($mp3)) { $return=errors(mp3_burn($mp3,$tmp,$cdrecord_param)); }
 
 # OGGs
 if (defined($ogg)) { $return=errors(ogg_burn($ogg,$tmp,$cdrecord_param)); }
 
 # Bin Cue
 if (defined($bin_cue)) {
  my $bin= my $cue = $bin_cue;
  $cue =~ s/\.bin$/\.cue/;
  $return=burn_bin_cue($bin,$cue,"",$tmp,$cdrecord_param,$mkisofs_param);
 }

 if ( $tmp =~ /burnpl_$$/ ) { if (! rmdir $tmp) { print STDERR "I cann't del tmp dir: $tmp !\n"; }}
 return $return;


#-------------------------------------------------------
# Subs
#-------------------------------------------------------

 sub errors {
  my ($error) = @_;
  
  if (defined($DEBUG)) { print "ERRORS:ERROR{$error}\n"; }
  if ($error == 0) { print "\n\nBurning complete SUCCESSFULLY !!\n\n"; }
   elsif  ($error == 1) { print STDERR "\n\nCD-Writing finished UNSUCCESSFULLy !!\n\n"; }
    elsif  ($error == 2) { print STDERR "\n\nThere is Bad IMG size !!\n\n"; }
     elsif  ($error == 3) { print STDERR "\n\nDirectory or file: \"$file\" doesn't exist !!\n\n"; }
      elsif  ($error == 4) { print STDERR "\n\nThere is a problem with convertinf files (file: $file) !!\n\n"; }
       elsif  ($error == 9) { print STDERR "\n\nUnable to run cdrecord/mkisofs correctly !! \n\n"; }
        else { print STDERR "\n\nUnknown ERROR !!\n\n"; }
  return $error;
 }    
       
 sub check {
  my (@file) = @_;
  
  if (pop(@file) eq "f") { 
   print "\nKontrola souboru\n";
   foreach my $help (@file) {
    if (defined($DEBUG)) { print "CHECK:FILES:{$help}\n"; }
    if ( ! -e $help) { return 1; }
   }
  } 
  else { 
   if (defined($DEBUG)) { print "CHECK:DIR:{$file[0]}\n"; }
   if ( ! -d $file[0]) { return 1; } 
  }
  return 0;
 }
 
 sub blank {
  my ($type,$cdrecord_param) = @_;
  if (defined($DEBUG)) { print "BLANK:{$cdrecord_param blank=$type}\n"; }
  if (system("$cdrecord_param blank=$type") == 0) { print "\n\nBlank SUCCESFULL\n\n"; return 0; }
   else { print  STDERR "\n\nBlank UNSUCCESSFULL !!!\n\n"; return 1; }
 } 

 sub multi {
  my ($cdrecord_param) = @_;
  my $multi = "";
  ($cdrecord_param_help = $cdrecord_param) =~ s/-v//;
  $cdrecord_param_help =~ s/-eject//;
  if (defined($DEBUG)) { print "MULTI:{$cdrecord_param_help -msinfo 2>/dev/null}\n"; }
  open(MULTI,"$cdrecord_param_help -msinfo 2>/dev/null |") or return 9;
  while ($line = <MULTI>) { chomp($multi=$line); }
  return $multi;
 }
 
 sub data {
  my ($data,$cdrecord_param,$mkisofs_param) = @_;
  my ($img_size,$line) = ();
  if (defined($DEBUG)) { print "DATA:{$mkisofs_param -print-size $data}\n"; }
  open(IMG_SIZE,"$mkisofs_param -print-size $data 2>/dev/null | ") or return 9;
  while ($line = <IMG_SIZE>) { chomp($img_size=$line); }
  if ($img_size eq "") { return 2; }
 
  if (defined($DEBUG)) { print "DATA->IMG_SIZE={$img_size}:{$mkisofs_param $data | $cdrecord_param tsize=${img_size}s -data - }\n"; }
  if (system("$mkisofs_param $data | $cdrecord_param tsize=${img_size}s -data - ") == 0) {  return 0; }
   else { return 1; }
 }

 sub iso {
  my ($iso,$cdrecord_param) = @_; 
  if (defined($DEBUG)) { print "ISO:{$cdrecord_param \"$iso\"}\n"; }
  if (system("$cdrecord_param \"$iso\"") == 0) { return 0; }
   else { return 1;}
 }  

 sub audio {
  my ($audio,$cdrecord_param) = @_;
  if (defined($DEBUG)) { print "AUDIO:{$cdrecord_param -pad -dao -useinfo -audio $audio}\n"; }
  if (system("$cdrecord_param -pad -dao -useinfo -audio $audio") == 0) { return 0; }
   else { return 1;}
 }

 sub audio_copy {
  my ($cdrecord_param,$drv_read,$tmp,$speed) = @_;
   if (defined($DEBUG)) { print "AUDIO_COPY:{cdda2wav -D$drv_read -S$speed -x -v255 -B -L 1 -Owav $tmp/track}\n"; }
#  if (system("cdparanoia -B --") == 0) { print "\n\nCopying COMPLETE\n\n"; }
  if (system("cdda2wav  -D$drv_read -S$speed -x -v255 -B -L 1 -Owav $tmp/track") == 0) { print "\n\nCopying to (TMP) $tmp COMPLETE\n\n"; }
   else { print STDERR "\n\nThere was some error in CD copying !!\n\n"; return(7); }
  system("eject $dev_read &");
  errors(audio(" $tmp/*.wav ",$cdrecord_param));
#    my @files=glob("$tmp/*.iso $tmp/*.wav $tmp/*.inf");
  if (! (unlink(glob("$tmp/*.wav $tmp/*.inf")) && rmdir("$tmp"))) { print  STDERR "xI cann't del tmp wav files: $tmp/*.wav !\n"; }
     else { print "Deleting tmp wavs .... OK\n"; }  
 }

#xxx
 sub copy_mixed_cd {
  my $return = "";
  my ($cdrecord_param,$mkisofs_param,$dev_read,$dev_read_scsi,$tmp,$speed) = @_;
  if ($cdrecord_param =~ /-multi/) { $return=audio_copy($cdrecord_param,$dev_read_scsi,$tmp,$speed); }
   else { $return=audio_copy("$cdrecord_param -multi ",$dev_read_scsi,$tmp,$speed); }
  if ($return != 0) { return 1;}
#  if (! (unlink(glob("$tmp/*.wav $tmp/*.inf")))) { print  STDERR "I cann't del tmp wav files: $tmp/*.wav !\n"; }
#     else { print "Deleting tmp wavs .... OK\n"; }  
#  { my @files=glob("$tmp/*.wav $tmp/*.inf"); unlink(@files); print "Deleting tmp wavs .... OK\n"; }
  if (defined($DEBUG)) { print "MIXED_CD:{mount $dev_read}\n"; } 
  if (system("mount $dev_read") == 0) { print "\n\nMounting CD ($dev_read) .... OK\n\n"; }
   else { print STDERR "\n\nMounting CD ($dev_read).... Failed !!\n\n"; }
  my $add_session = multi($cdrecord_param);
  if ($add_session =~ /,/) { $mkisofs_param .= " -C $add_session "; }
   else { errors($add_session); }
  $return = errors(data("/mnt/cdrom",$cdrecord_param,$mkisofs_param));
  if (defined($DEBUG)) { print "MIXED_CD2:{eject $dev_read}\n"; } 
  if (system("eject $dev_read") == 0) { print "\n\nEjecting CD ($dev_read) .... OK\n\n"; }
   else { print STDERR "\n\nEjecting CD ($dev_read) .... FAILED\n\n"; }
  return $return;
 }

 sub mp3 {
  my ($mp3,$tmp,$cdrecord_param) = @_;
  my (@mp3_tmp_files,$file,$file2) = ();
  
  foreach $file (glob("$mp3/*.mp3")) {
   # Delete ./
   $file2=substr($file,rindex($file,"/"),length($file));
   $file2=~ s/\.mp3$/\.wav/;
   $file =~ s/\.\///;
   if (defined($DEBUG)) { print "MP3:{lame --decode \"$file\" \"$tmp$file2\"}\n"; }
   push(@mp3_tmp_files,"$tmp/$file2");
   if (system("lame --decode \"$file\" \"$tmp$file2\"") == 0) { print "\n\nDeconding of file $file is succesfully completed.\n\n"; }
    else { return 4; }
  }    
  return @mp3_tmp_files;
 }

 sub mp3_burn {
  my ($mp3,$tmp,$cdrecord_param) = @_;
  my (@mp3_tmp_files,$return) = ();
  
  @mp3_tmp_files=mp3($mp3,$tmp,$cdrecord_param);
  if (@mp3_tmp_files==4) { return 4; }
  $return = errors(audio(" $tmp/*.wav ",$cdrecord_param));
  unlink(@mp3_tmp_files);
  return $return;
 }

 sub ogg {
  my ($ogg,$tmp,$cdrecord_param) = @_;
  my (@ogg_tmp_files,$file,$file2) = ();
  
  foreach $file (glob("$ogg/*.ogg")) {
   # Delete ./
   $file =~ s/\.\///;
   $file2=$file;
   $file2=~ s/\.ogg$/\.wav/;
   if (defined($DEBUG)) { print "OGG:{ogg123 -d wav -f $tmp/$file2 $ogg/$file}\n"; }
   push(@ogg_tmp_files,"$tmp/$file2");
   if (system("ogg123 -d wav -f  $tmp/$file2 $ogg/$file") == 0) { print "\n\nDeconding of file $file is succesfully completed.\n\n"; }
    else { return 4; }
  }    
  return @ogg_tmp_files;
 }

 sub ogg_burn {
  my ($ogg,$tmp,$cdrecord_param) = @_;
  my (@ogg_tmp_files,$return) = ();
  
  @ogg_tmp_files=ogg($ogg,$tmp,$cdrecord_param);
  if (@ogg_tmp_files==4) { return 4; }
  $return = errors(audio(" $tmp/*.wav ",$cdrecord_param));
  unlink(@ogg_tmp_files);
  return $return;
 }

 sub bin_cue {
  my ($bin,$cue,$psx_mode,$tmp) = @_;
  my $iso_file=$bin;
  $iso_file=~ s/\.bin//;
  if (defined($DEBUG)) {
   if (defined($psx_mode)) { 
    print "BIN_CUE:{bchunk -w $psx_mode $bin $cue $tmp/$iso_file}\n"; 
    if (system("bchunk -w $psx_mode $bin $cue $tmp/$iso_file") == 0) { print "\n\nTransformation from .bin to .iso (.wav) was succesfull.\n\n"; }
     else { return 4;}   
   }
   else {
    print "BIN_CUE:{bchunk -w $bin $cue $tmp/$iso_file}\n"; 
    if (system("bchunk -w $bin $cue $tmp/$iso_file") == 0) { print "\n\nTransformation from .bin to .iso (.wav) was succesfull.\n\n"; }
     else { return 4;}   
   }
  }
  $iso_file.="01.iso";
  return "$tmp/$iso_file";
 }

 sub burn_bin_cue {
  my ($bin,$cue,$psx_mode,$tmp,$cdrecord_param,$mkisofs_param) = @_;
  my $return = "";
  if (check($bin) && check($cue)) { return 3; }
  my $iso=bin_cue($bin,$cue,$psx_mode,$tmp);
  if (! check("$tmp/*.wav","f")) {
   if ($cdrecord_param =~ /-multi/) { $return=errors(audio(" $tmp/*.wav ",$cdrecord_param)); }
    else { $return=errors(audio(" $tmp/*.wav ","$cdrecord_param -multi ")); }
   if ($return != 0) { return 1;}
  } 

  my $add_session = multi($cdrecord_param);
  if ($add_session =~ /,/) { $mkisofs_param .= " -C $add_session "; }
   else { errors($add_session); }
   
  my $errors=errors(iso($iso,$cdrecord_param)); 
  if (! unlink $iso) { print  STDERR "I cann't del tmp iso file: $iso !\n"; }
  return $errors;
 }
}


sub print_menu {
 my $choice = "";
 while ($choice !~ /^6$/) {
  print "\n*********************
\tMENU
*********************\n
1. Create Data session
2. Create Audio session
X. Mixed CD - Burn Audio tracks in multisession mode and then add Data session
3. Copy CD
4. Blank a CDRW
5. Burn Image (.iso, .bin files)
6. Quit
 
Your choice? ";
 

  $choice = <>; printf "\n";
  if ($choice =~ /^1$/) { 
   print "Would you like to create: 
1. Single session Data disc
2. Start or continue Multisession Data disc
3. Add Data session after Audio session 
4. Add Data session after Audio session and don't close the CD
5. Back

Your choice? ";

   $choice = <>;
   if ($choice =~ /^[1-4]$/) {
    if (defined($DEBUG)) { print "DATA SECTION\n"; }
    print "\nEnter the Volume name: "; chomp($volume = <>);
    print "\nEnter the source directory: "; chomp($read_dir = <>);
    if ($choice =~ /^1$/) { ($data,$eject) = ($read_dir,1); return main_program(); }
     elsif ($choice =~ /^2$/) { ($data,$multi) = ($read_dir,1); return main_program(); }
      elsif ($choice =~ /^3$/) { ($cd_extra,$eject) = ($read_dir,1); return main_program(); }  
       elsif ($choice =~ /^4$/) { ($cd_extra,$multi) = ($read_dir,1); return main_program(); }
   }
  } 
  elsif ($choice =~ /^2$/) { 
   print "Would you like to create: \n
1. Single session Audio CD from WAVes
2. Start or continue Multisession Audio disc
3. Create an Audio CD from MP3 files
4. Start or continue Multisession Audio CD from MP3 files
5. Create an Audio CD from OGG files
6. Start or continue Multisession Audio CD from OGG files
7. Create an Audio CD from a Playlist
8. Start or continue Multisession Audio CD from a Playlist
9. Back

Your choice? ";

   $choice = <>;
   if ($choice =~ /^[1-8]$/) {
    if (defined($DEBUG)) { print "AUDIO SECTION\n"; }
    if ($choice =~ /^[5,8]$/) { print "\nGive me the playlist file: "; chomp($playlist = <>); }
     elsif ($choice =~ /^[1-6]$/) { print "\nEnter the source directory: "; chomp($read_dir = <>); }
    if ($choice =~ /^1$/) { ($audio,$eject) = ($read_dir,1);  return main_program(); }
     elsif ($choice =~ /^2$/) { ($audio,$multi)=($read_dir,1); return main_program(); }
      elsif ($choice =~ /^3$/) { ($mp3,$eject)=($read_dir,1); return main_program(); }
       elsif ($choice =~ /^4$/) { ($mp3,$multi)=($read_dir,1); return main_program(); }
        elsif ($choice =~ /^5$/) { ($ogg,$eject)=($read_dir,1); return main_program(); }
         elsif ($choice =~ /^6$/) { ($ogg,$multi)=($read_dir,1); return main_program(); }
          elsif ($choice =~ /^7$/) { ($playlist,$eject)=($read_dir,1); return main_program(); }
           elsif ($choice =~ /^8$/) { ($playlist,$multi)=($read_dir,1); return main_program(); }
   }	   
  } 

  elsif ($choice =~ /^3$/) { 
   print "Would you like to do: 
1. Copy an Data CD
#2. Copy an Data CD and don't closte the CD
3. Copy an Audio CD
4. Copy an Audio CD and don't closte the CD
5. Copy an Mixed CD (Audio + Data CD)
6. Copy an Mixed CD (Audio + Data CD) and don't closte the CD
7. Back

Your choice? ";

   $choice = <>;
   if ($choice =~ /^[1-6]$/) {
    if (defined($DEBUG)) { print "COPY SECTION\n"; }
    if ($choice =~ /^1$/) { ($copy_data,$eject) = (1,1); return main_program(); }
     elsif ($choice =~ /^2$/) { ($copy_data,$multi) = (1,1); return main_program(); }
      elsif ($choice =~ /^3$/) { ($copy_audio,$eject) = (1,1); return main_program(); } 
       elsif ($choice =~ /^4$/) { ($copy_audio,$multi) = (1,1); return main_program(); } 
        elsif ($choice =~ /^5$/) { $copy_mix = 1; return main_program(); } 
         elsif ($choice =~ /^6$/) { ($copy_mix,$multi) = (1,1); return main_program(); } 
   } 
  } 
  elsif ($choice =~ /^4$/) { 
   print "Which type of Blank will I use:
1. Fast, Minimal - minimally blank the entire disk (PMA, TOC, pregap)
2. Unclose - unclose last session
3. Session - blank last session
4. Trtail - blank a track tail
5. Track - blank a track
6. Unreserve - unreserve a trac
7. All,Disc,Disk - blank the entire disk, this may take a long time.
8. Back

Your choice? ";

   $choice = <>;
   if ($choice =~ /^[1-7]$/) {
    if (defined($DEBUG)) { print "BLANK SECTION\n"; }
    if ($choice =~ /^1$/) { ($blank) = ("fast"); return main_program(); }
     elsif ($choice =~ /^2$/) { ($blank) = ("unclose"); return main_program(); }
      elsif ($choice =~ /^3$/) { ($blank) = ("session"); return main_program(); }
       elsif ($choice =~ /^4$/) { ($blank) = ("trtail"); return main_program(); }
        elsif ($choice =~ /^5$/) { ($blank) = ("track"); return main_program(); }
         elsif ($choice =~ /^6$/) { ($blank) = ("unreserve"); return main_program(); }
          elsif ($choice =~ /^7$/) { ($blank) = ("all"); return main_program(); }
   }	  
  }
 
  elsif ($choice =~ /^5$/) { 
   print "Would you like to do: 
1. Burn ISO file
2. Burn ISO file and don't close the CD
3. Burn BIN/CUE file
4. Burn BIN/CUE file and don't close the CD
5. Back

Your choice? ";

   $choice = <>;
   if ($choice =~ /^[1-4]$/) {
    print "Current directory: \n";
    if (defined($DEBUG)) { print "ISO/BIN SECTION\n"; }
    if ($choice =~ /^[1,2]$/) { print "\nEnter the ISO file: "; }
     elsif ($choice =~ /^[3,4]$/) { print "\nEnter the BIN file (the CUE file, which have the same name as BIN file is needed): "; }
    chomp($read_img = <>); 
    if ($choice =~ /^1$/) { ($iso,$eject) = ($read_img,1); return main_program(); }
     elsif ($choice =~ /^2$/) { ($iso,$multi) = ($read_img,1); return main_program(); }
      elsif ($choice =~ /^3$/) { ($bin_cue,$eject) = ($read_img,1); return main_program(); }
       elsif ($choice =~ /^4$/) { ($iso,$multi) = ($read_img,1); return main_program(); }
   }       
  } 
 
  if ($choice =~ /^9$/) { print "Quitting ...\n\n"; return 0; }
 }
}

sub help {
 print "
  Usage: burn < options >
  Options needed params
    -m  --multi		Create multisession CD
    -l  --playlist	Create Audio CD from given playlist <file>
    -b  --blank		Blank CD (for blanking  options see man cdrecord)
    -x  --extra		Create Data session after Audio session (CDextra)
    -rw --dev_rw	CD-RW device (0,0,0)
    -r  --dev_read	CD-ROM device (/dev/cdrom) only with -c parameter
    -rs --dev_read_scsi	CD-ROM device (/dev/cdrom) only with -c parameter    
    -s  --speed		CD-RW speed 
    -oc --opt_cdrecord	Options to cdrecord
    -om --opt_mkisofs	Options to mkisofs
    -a  --audio		Burn music CD
    -3  --mp3		Burn MP3s (as audio) (your MP3s shuld end with .mp3!)
    -o  --ogg		Burn OGGs (as audio) (your OGGs shuld end with .ogg!)
    -d  --data		Burn directory and it's subdirectories
    -cd --copy_data	Copy data cd (On-The-Fly) (read CDROM - /dev/cdrom)
    -cx --copy_mix	Copy mixed CD (Music+Data CD)	
    -v  --volume	Volume 
    -i  --iso		Burn ISO image
    -t  --tmp		Directory fo temorary files (/tmp)
    -bi --bin		Burn .bin and .cue image file (must be bchunk installed)
  			Files .cue and .bin should have to the same name 
			Example: iso.bin, iso.cue
  
  Options without parameters:
    -ca --copy_audio	Copy an audio CD
    -cd --copy_data	Copy an data CD
    -h  --help		Help
    -e  --eject		Don't eject CDRW after finishung operation			
    
  Examples: 
  
    ./burn.pl -s=4 -d=. -m -v=\"This Directory\"    
    - Burn current directory with volume \"This Directory\" with 4x speed and 
      multisession (you can add data to this CD). 

    ./burn.pl -b=fast 
    - Blank CD as the fastest way

    ./burn.pl -rw=/dev/cdrw -a=*.wav -m
    - Burn all WAVs in current directory to device /dev/cdrw and don't close the CD
         
  "; 
}
