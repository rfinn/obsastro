#!/usr/bin/perl -w
system("ls *.mag.1 > temp");
open(IN1,"temp") || die "can't open IN1 $!";
$i=0;
while ($line=<IN1>){
  $nstar=0;
  $k=0;
  chomp($line);
  open(IN2,"$line") || die "can't open IN2 $!";
  $j=0;
  while ($line2 = <IN2>){
    if ($line2 =~ /\#/){
      next;
    }
    $k++;
    if ($k == 5){
#    ($im,$x,$y,$id,$coord,$lid,$xc,$yc,$xshift,$yshift,$xerr,$yerr,$cier,$cerror,$msky,$stdev,$sskew,$nsky,$nsrej,$sier,$serror,$itime,$xairmass,$ifilter,$otime,$rapert, $sum,$area,$flux,$mag,$merr,$pier,$perror)=split "",(/\s+/,$line2);
      ($t,$rapert,$sum,$area,$flux,$mag,$merr,$pier,$perror)=split(/\s+/,$line2);
      $star[$i][$j]=$mag;
      $estar[$i][$j]=$merr;
      #if ($i < 1){
	#print "$line2 \n";
      #}
      #print "$i $j $star[$i][$j] $estar[$i][$j] \n";
      $j++;
      $k=0;
    }
  }
  $i++;
}
close(IN1);
close(IN2);
$nstar=$j;
$nim=$i;
$i=0;
$j=0;
$end=$nstar-1;
open(OUT1,">qphot_mag.dat") || die "can't open OUT1 $!";
while ($i < $nim){
  $j=0;
  while ($j < $nstar){
    if ($j == $end){
      print OUT1 "$star[$i][$j] $estar[$i][$j]\n";
    }else{
    print OUT1 "$star[$i][$j] $estar[$i][$j]\t";}
    $j++;
  }
  $i++;
}
close(OUT1);
