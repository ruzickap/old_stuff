#!/usr/bin/perl
use Digest::MD5 qw(md5_hex);

#database location
$database="~/data2/_Photos_/digikam4.db";
$photos_directory='/home/ruzickap/data2/_Photos_';
#find all network albums and indclude also one containing pics from specific path
$sqlite3_where_condition="WHERE AlbumRoots.identifier LIKE '%networkshareid%' OR AlbumRoots.specificPath = \'$photos_directory\' ";

#database dump (useful for debugging problems): sqlite3 $DATABASE ".dump";
open(SQLITE3,"sqlite3 $database \"select AlbumRoots.identifier, AlbumRoots.specificPath, Albums.relativePath, Images.name from Albums inner join Images on Albums.id=Images.album inner join AlbumRoots on AlbumRoots.id=Albums.albumRoot $sqlite3_where_condition\" |");

$pictures_album_net_root=$mountpath_pictures_count=$pictures_album_root=$pictures=0;

while (<SQLITE3>) {
  chomp;
  @file=split(/\|/,$_);
#  print "@file\n";
  if ($file[0] =~ /networkshareid:\?mountpath=(.*)/) {
    $mountpath = $1;
    #fix the hex chars: %2Fmnt%2Fxvx_cz%2Fphotos
    $mountpath =~ s/%([a-fA-F0-9]{2,2})/chr(hex($1))/eg;;
    #fix for pictures in album root: networkshareid:?mountpath=%2Fmnt%2Fxvx_cz%2Fphotos / P1130279.JPG
    if ($file[2] eq "/") {
        $keep{"$ENV{'HOME'}/.thumbnails/large/" . md5_hex("file://$mountpath$file[2]/$file[3]") . ".png"}="file://$mountpath$file[2]/$file[3]";
        $pictures_album_net_root++;
    } else {
        $keep{"$ENV{'HOME'}/.thumbnails/large/" . md5_hex("file://$mountpath$file[2]/$file[3]") . ".png"}="file://$mountpath$file[2]/$file[3]";
        $mountpath_pictures_count++;
      }
  } elsif ($file[2] eq "/") {
      $delete{"$ENV{'HOME'}/.thumbnails/large/" . md5_hex("file://$file[1]/$file[3]") . ".png"}="file://$file[1]/$file[3]";
      $pictures_album_root++;
    } else {
        $delete{"$ENV{'HOME'}/.thumbnails/large/" . md5_hex("file://$file[1]$file[2]/$file[3]") . ".png"}="file://$file[1]$file[2]/$file[3]";
        $pictures++;
      }
}

close (SQLITE3);

#while (($key, $value) = each %keep) {
#  print "$key|$value\n";
#}

for $file (glob("$ENV{'HOME'}/.thumbnails/large/*")) {
  if (not exists $keep{$file}) {
    print "rm $file #" . $delete{"$file"} ."\n";
    $rm_file_size+=-s $file;
    $rm_thumbnail++;
  }
}

print "
#Pictures on network shares: $mountpath_pictures_count
#Pictures in album root of the network share: $pictures_album_net_root

#Pictures on the disk in album root ($photos_directory): $pictures_album_root
#Pictures on the disk: $pictures

#Thumbnails to delete: $rm_thumbnail (". int($rm_file_size/1048576) ." MB)
#Total: " . ($mountpath_count+$pictures_albumroot+$pictures) . "
";
