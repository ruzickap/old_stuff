#!/usr/bin/perl -w
use DateTime;
use Digest::MD5;

#mplayer -vo null -ao null -frames 0 -dumpsrtsub -sub ./subtitles/tango.cash.\(1989\).cze.1cd.sub ./tmp/Tango.and.Cash.DVDRip.x264.avi
#mkvinfo Tango_and_Cash.DVDRip.x264-PeRu_1.mkv |grep -A 15 Attachments
#mkvextract attachments Tango_and_Cash.DVDRip.x264-PeRu_1.mkv  388305092:

#DVD source
$dvd_src=".";
#read dvd structure using lsdvd
eval `lsdvd -x -Op $dvd_src 2>/dev/null`;
#where to save all temporary data
$temp="./tmp/";
$movie_name="Tango & Cash";
$name="Tango_and_Cash.DVDRip.x264-PeRu";
$x264encopts="bitrate=1000:frameref=6:bframes=2:b_pyramid:direct_pred=auto:weight_b:partitions=all:8x8dct:me=umh:subq=7:mixed_refs:trellis=2:threads=auto"; #scale=640:352
$info_artist="Tango & Cash";
$info_genre="Action";
$info_copyright="Warner Bros. Pictures";
$info_srcfrom="DVD";
$info_comment="Created by PeRu";
#the source of attached picture
$pic_dest="./pic.jpg";
$touch=DateTime->today->epoch;
#the source directory where are the subtitles in format "tango.cash.(1989).cze.1cd.srt" (best download them from www.opensubtitles.org)
#the directory depend automatically on the track number: "directory_1" "directory_2"
$subtitles_dir="./subtitles";
#the minimal length of track which will be encoded (there is no sence to encode 1 second long track)
$min_track_length=10;
#if Enabled encodes only one track - the longest one
$only_longest_track=0;
#english language is put to the first "place"
$default_english=0;
#print used commands
$debug=1;

#corp detect function
#the output should return similar string: 
sub crop_detect {
  my $mplayer_params = shift(@_);
  if ($debug) {
    print "\n*xxx* mplayer -vo null -nosound -vf cropdetect $mplayer_params\n";
  }
  @mplayer_output=`mplayer -vo null -nosound -vf cropdetect $mplayer_params 2>/dev/null | tail`;
  foreach $line (@mplayer_output) {
#get corp parameters from example:
#
    if ($line =~ /\[CROP\]\ Crop\ area:\ X:\ .*\(-vf\ (.*)\)\./) {
       $crop=$1;
    }
  }
  if ($crop =~ /-/) { 
    warn "\nCrop detect failed...\n";
    return "";
  } else {
      return (",$crop");
    }
}

#every command should be run using this function to ensure debug output if it's required
sub run_command {
  my $command = shift(@_);
  if ($debug) { 
    print "\n*xxx* $command\n\n";
  }
  return system("$command");
}


########################## Main

#create basic directories 
mkdir("$name"); mkdir("$name/Sample");
foreach my $track (@{$lsdvd{'track'}}) {
  print "\nTrack: $$track{'ix'}\n";

#check if track is smaller than minimal track length
  if ($$track{'length'} < $min_track_length) { 
    print "\nSkipping track $$track{'ix'} - shorter than $min_track_length seconds...\n";
    next;
  }

#continue if track is the longest one and encoding of the only longest track is required
  if (($$track{'ix'} ne $lsdvd{'longest_track'}) and ($only_longest_track)) {
    print "\nSkipping track $$track{'ix'}/$lsdvd{'longest_track'}...\n";
    next;
  }

  $audio_tracks="";
  $subtitle_tracks="";

#different namig used when encoding of longest track is required "MY_NAME.mkv" and without it "MY_NAME_1.mkv"
  if (($#{$lsdvd{'track'}} > 0) and (not $only_longest_track)) { 
    $file_name="${name}_$$track{'ix'}";
  } else {
      $file_name=$name;
    }
  $file_name_lowercase=lc($file_name);

  print "File: $file_name\n";
#get chapter for track
  run_command("dvdxchap --title $$track{'ix'} '$dvd_src' > \"$temp/${file_name}.chapters\"");

  print "\n*** Video tracks [$$track{'ix'}/" . int($#{$lsdvd{'track'}}+1) . "]\n";
  print "\n*** Encoding to H264\n";

  print "Detecting crop...\n";
  $half_track_length=int($$track{'length'}/2);
#begin corp detect from the middle of the track and save it to the filter
  $vf="yadif=0,harddup" . crop_detect(" dvd://$$track{'ix'} -dvd-device '$dvd_src' -ss $half_track_length -frames 25 ") . " -noskip";

  print "\n*** Encoding to H264\n";
  print "\nMencoder PASS1...\n";
  print run_command("time mencoder -nosound -ovc x264 -vf $vf -x264encopts $x264encopts:pass=1:turbo=2 -passlogfile '$temp/${file_name_lowercase}.log' -info name='$name':artist='$info_artist':genre='$info_genre':copyright='$info_copyright':srcform='$info_srcfrom':comment='$info_comment' -o /dev/null -dvd-device '$dvd_src' dvd://$$track{'ix'} ");
  print "\nMencoder PASS2...\n\n";
  run_command("time mencoder -nosound -ovc x264 -vf $vf -x264encopts $x264encopts:pass=2         -passlogfile '$temp/${file_name_lowercase}.log' -info name='$name':artist='$info_artist':genre='$info_genre':copyright='$info_copyright':srcform='$info_srcfrom':comment='$info_comment' -o '$temp/${file_name}.avi' -dvd-device '$dvd_src' dvd://$$track{'ix'} ");
#remove log file produced by mencoder's first pass
  unlink("$temp/${file_name_lowercase}.log");
#set exact time/date for the final avi file 
  utime($touch,$touch,"$temp/${file_name}.avi");


  print "\n***Audio tracks:\n";
  $audio="";
  foreach $audio_track (@{$$track{"audio"}}) {

    print "\n$$audio_track{'language'} [$$audio_track{'ix'}/" . int($#{$$track{'audio'}}+1) . "]\n";
    run_command("time mplayer -dvd-device '$dvd_src' dvd://$$track{'ix'} -alang $$audio_track{'langcode'} -dumpaudio -dumpfile '$temp/${file_name}-audio-$$audio_track{'langcode'}-$$audio_track{'streamid'}.$$audio_track{'format'}'");
    utime($touch,$touch,"$temp/${file_name}-audio-$$audio_track{'langcode'}-$$audio_track{'streamid'}.$$audio_track{'format'}");
      if (($$audio_track{'langcode'} =~ /en/) and ($default_english eq 1)) {
        $audio_tracks=" --language 0:$$audio_track{'langcode'} --track-name 0:$$audio_track{'language'}_" . uc($$audio_track{'format'}) . "_$$audio_track{'channels'}ch_$$audio_track{'frequency'}  $temp/${file_name}-audio-$$audio_track{'langcode'}-$$audio_track{'streamid'}.$$audio_track{'format'} $audio_tracks";
        $audio="$$audio_track{'language'}, $audio";
      } else {
          $audio_tracks.=" --language 0:$$audio_track{'langcode'} --track-name 0:$$audio_track{'language'}_" . uc($$audio_track{'format'}) . "_$$audio_track{'channels'}ch_$$audio_track{'frequency'} $temp/${file_name}-audio-$$audio_track{'langcode'}-$$audio_track{'streamid'}.$$audio_track{'format'} ";
          $audio.="$$audio_track{'language'}, ";
        }
  }
  if ($audio) {
    $video_track=" --title \"$name\" --track-name 0:\"$movie_name\" --language 0:$$track{'audio'}[0]{'langcode'} --chapters '$temp/${file_name}.chapters' \"$temp/${file_name}.avi\" ";
    $audio =~ s/,\ $//;
    print "\n[$audio]\n";
  } else {
      print "\nNo audio tracks found...\n";
      $video_track=" --title \"$name\" --track-name 0:\"$movie_name\" --chapters '$temp/${file_name}.chapters' \"$temp/${file_name}.avi\" ";
      $audio= "None";
    }

  #Subtitles should looks like: tango.cash.(1989).cze.1cd.srt (best download them from www.opensubtitles.org)
  print "\n*** Subtitles:\n";
  $subtitles="";

  if ( -d "${subtitles_dir}_$$track{'ix'}" ) {
    while ($subtitle_file=glob("${subtitles_dir}_$$track{'ix'}/*.srt")){
      if ($subtitle_file=~/\.([a-z]{2,3})\.\w{3}\.[a-z]{3}$/) {
        $subtitle_langcode=$1;
        if ($subtitle_langcode =~ /eng/) {
          $subtitle_tracks=" --language $$track{'ix'}:$subtitle_langcode --track-name $$track{'ix'}:$subtitle_langcode '$subtitle_file' $subtitle_tracks";
          $subtitles="\u$subtitle_langcode, $subtitles";
        } else {
            $subtitle_tracks.=" --language $$track{'ix'}:$subtitle_langcode --track-name $$track{'ix'}:$subtitle_langcode '$subtitle_file' ";
            $subtitles.="\u$subtitle_langcode, ";
          }
        print "$subtitle_file - $subtitle_langcode\n";
      }
    }
    if (not defined($subtitle_langcode)) { 
      warn "No subtitles found in directory: ${subtitles_dir}_$$track{'ix'}, or doesn't have proper format (Ex: tango.cash.(1989).cze.1cd.sub)\n"; 
      $subtitles="None";
    } else {
        $subtitles =~ s/,\ $//;
        print "\n[$subtitles]\n";
      }
  } else {
      warn "Subtitles directory not found: ${subtitles_dir}_$$track{'ix'}\n"; 
      $subtitles="None";
    }

  open(MPLAYER_IDENTIFY, "mplayer -vo null -ao null -frames 0 -identify $temp/${file_name}.avi 2>&1 |") || warn "\nCouldn't do -identify via mplayer\n";
  while (<MPLAYER_IDENTIFY>) {
    if (/^VIDEO:\s*\[(\S*)\]\s*(\S*)\s*(\d*)bpp\s*(\S*)\ fps\s*(\S*)\ kbps.*/) {
      $codec="\u$1";
      $resolution=$2;
#      $color_depth=$3;
      $fps=$4;
      $bitrate=$5;
    }
    if (/^ID_CLIP_INFO_VALUE0=(.*)/) {
      $software=$1;
    }
   if (/^ID_VIDEO_ASPECT=(.*)/) {
     $aspect=$1;
   }
   if (/^ID_LENGTH=(.*)/) {
     @length_time=gmtime($1);
   }
  }

  open(NFO_INSIDE_MKV_FILE,">$temp/${file_name_lowercase}_mkv.nfo") || warn "\nCan't write nfo file $temp/${file_name_lowercase}_mkv.nfo: $?\n";
  printf NFO_INSIDE_MKV_FILE ("Release Name:   %s
Source:         %s
Genre:          %s
Release Date:   %s
Resolution:     %s
Aspect Ratio:   %1.2f:1
Framerate:      %i fps
Video Codec:    %s MPEG-4 AVC
Video Bitrate:  %i kbps
Software:       %s
Length:         %02i:%02i:%02i
Subtitles:      %s
Audio:          %s
URL:            http://www.imdb.com/title/tt0098439/
",$name,$info_srcfrom,$info_genre,DateTime->today->ymd,$resolution,$aspect,$fps,$codec,$bitrate,$software,$length_time[2],$length_time[1],$length_time[0],$subtitles,$audio);
  close (NFO_INSIDE_MKV_FILE);
  utime($touch,$touch,"$temp/${file_name_lowercase}_mkv.nfo");
  $nfo_attachment=" --attachment-mime-type text/plain --attachment-description '${file_name}' --attach-file '$temp/${file_name_lowercase}_mkv.nfo' ";

  print "\n*** Creating mkv...\n";
  run_command("mkvmerge --output '$name/${file_name}.mkv' $video_track $audio_tracks $subtitle_tracks $nfo_attachment --attachment-description '$movie_name' --attachment-mime-type image/jpeg --attach-file '$pic_dest' ");
  unlink(glob("$temp/${file_name}*"),glob("$temp/${file_name_lowercase}*")); 
  utime($touch,$touch,"$name/${file_name}.mkv");

  if (open(MKV_FILE,"$name/${file_name}.mkv")) { 
    open(NFO_FILE,">$name/${file_name_lowercase}.nfo") || warn "\nCan't write nfo file $name/${file_name_lowercase}.nfo: $?\n";
    printf NFO_FILE ("Release Name:   %s
Source:         %s
Genre:          %s
Release Date:   %s
Resolution:     %s
Aspect Ratio:   %1.2f:1
Framerate:      %i fps
Video Codec:    %s MPEG-4 AVC
Video Bitrate:  %i kbps
Software:       %s
Length:         %02i:%02i:%02i
Subtitles:      %s
Audio:          %s
Size:           %u MB
MD5:            %s
URL:            http://www.imdb.com/title/tt0098439/
",$name,$info_srcfrom,$info_genre,DateTime->today->ymd,$resolution,$aspect,$fps,$codec,$bitrate,$software,$length_time[2],$length_time[1],$length_time[0],$subtitles,$audio,int((-s "$name/${file_name}.mkv")/1000000),Digest::MD5->new->addfile(*MKV_FILE)->hexdigest);
    close (NFO_FILE);
    close (MKV_FILE);
    utime($touch,$touch,"$name/${file_name_lowercase}.nfo");
  } else {
      warn "\nCan't open final file $name/${file_name}.mkv: $?\n";
    }
}

$track=$lsdvd{'track'}[$lsdvd{'longest_track'}-1];
$audio_track=(@{$$track{"audio"}}[0]);
$file_name=$name;
$file_name_lowercase=lc($file_name);

print "\nWorking on Sample... (track: $$track{'ix'})\n";
print "File: $file_name\n";

print "Detecting crop\n";
$half_track_length=int($$track{'length'}/2);
$vf="yadif=0,harddup" . crop_detect(" dvd://$$track{'ix'} -dvd-device '$dvd_src' -ss $half_track_length -frames 25 ") . " -noskip";

print "\n***Audio track:\n";
run_command(" mplayer -ss $half_track_length -endpos 60 -vc null -vo null -dvd-device '$dvd_src' dvd://$$track{'ix'} -alang $$audio_track{'langcode'} -ao pcm:fast:file='$temp/${file_name_lowercase}-audio-$$audio_track{'langcode'}-$$audio_track{'streamid'}.sample.wav' ");
run_command(" oggenc --bitrate=128 --artist '$info_artist' --genre '$info_genre' --date " . DateTime->today->ymd . " --title '$name' --album $name -o '$temp/${file_name_lowercase}-audio-$$audio_track{'langcode'}-$$audio_track{'streamid'}.sample.ogg' '$temp/${file_name_lowercase}-audio-$$audio_track{'langcode'}-$$audio_track{'streamid'}.sample.wav' ");
unlink("$temp/${file_name_lowercase}-audio-$$audio_track{'langcode'}-$$audio_track{'streamid'}.sample.wav");
utime($touch,$touch,"$temp/${file_name_lowercase}-audio-$$audio_track{'langcode'}-$$audio_track{'streamid'}.sample.ogg");

print "\n*** Video track: [$$track{'ix'}]\n";
print "\n*** Encoding to H264\n";

print "\n*** Mencoder SAMPLE PASS1...\n\n";
run_command("time mencoder -ss $half_track_length -endpos 60 -nosound -ovc x264 -vf $vf -x264encopts $x264encopts:pass=1:turbo=2 -passlogfile '$temp/${file_name_lowercase}.sample.log' -info name='$name':artist='$info_artist':genre='$info_genre':copyright='$info_copyright':srcform='$info_srcfrom':comment='$info_comment' -o /dev/null -dvd-device '$dvd_src' dvd://$$track{'ix'} ");
print "\n*** Mencoder SAMPLE PASS2...\n\n";
run_command("time mencoder -ss $half_track_length -endpos 60 -nosound -ovc x264 -vf $vf -x264encopts $x264encopts:pass=2         -passlogfile '$temp/${file_name_lowercase}.sample.log' -info name='$name':artist='$info_artist':genre='$info_genre':copyright='$info_copyright':srcform='$info_srcfrom':comment='$info_comment' -o '$temp/${file_name_lowercase}.sample.avi' -dvd-device '$dvd_src' dvd://$$track{'ix'} ");
unlink("$temp/${file_name_lowercase}.sample.log");
utime($touch,$touch,"$temp/${file_name_lowercase}.sample.avi");


#run_command("mkvmerge --output '$name/Sample/${file_name_lowercase}.sample.mkv' --title '$name' --track-name '0:$name' --language 0:$$track{'audio'}[0]{'langcode'} '$temp/${file_name_lowercase}.sample.avi' --language 0:$$audio_track{'langcode'} --track-name '0:$$audio_track{'language'}_" . uc($$audio_track{'format'}) . "_$$audio_track{'channels'}ch_$$audio_track{'frequency'}' '$temp/${file_name_lowercase}-audio-$$audio_track{'langcode'}-$$audio_track{'streamid'}.sample.$$audio_track{'format'}' --attachment-mime-type text/plain --attachment-description '$name' --attach-file '$temp/${file_name_lowercase}_mkv.nfo'");
run_command("mkvmerge --output '$name/Sample/${file_name_lowercase}.sample.mkv' --title '$name' --track-name '0:$name' --language 0:$$track{'audio'}[0]{'langcode'} '$temp/${file_name_lowercase}.sample.avi' --language 0:$$audio_track{'langcode'} --track-name '0:$$audio_track{'language'}_$$audio_track{'frequency'}' '$temp/${file_name_lowercase}-audio-$$audio_track{'langcode'}-$$audio_track{'streamid'}.sample.ogg'");
#--attachment-mime-type text/plain --attachment-description '$name' --attach-file '$temp/${file_name_lowercase}_mkv.nfo'
utime($touch,$touch,"$name/Sample/${file_name_lowercase}.sample.mkv");

unlink("$temp/${file_name_lowercase}-audio-$$audio_track{'langcode'}-$$audio_track{'streamid'}.sample.ogg","$temp/${file_name_lowercase}.sample.avi","$temp/${file_name_lowercase}_mkv.nfo");

utime($touch,$touch,"$name","$name/Sample");
