#!/usr/bin/perl
print "---------------------\nSolve grid-81\n---------------------\n";

$symbols = "123456789";

@startgrid = (
   [ " "," "," "," "," "," "," "," "," " ],
   [ " "," "," "," "," "," "," "," "," " ],
   [ " "," "," "," "," "," "," "," "," " ],
   [ " "," "," "," "," "," "," "," "," " ],
   [ " "," "," "," "," "," "," "," "," " ],
   [ " "," "," "," "," "," "," "," "," " ],
   [ " "," "," "," "," "," "," "," "," " ],
   [ " "," "," "," "," "," "," "," "," " ],
   [ " "," "," "," "," "," "," "," "," " ],
);

$count_puts = 0;
$count_runs = 0;
@runlog = (); 

@units = (
   # 3x3blocks (left to right, top to bottom)
   [ [0,0],[0,1],[0,2],[1,0],[1,1],[1,2],[2,0],[2,1],[2,2] ],
   [ [0,3],[0,4],[0,5],[1,3],[1,4],[1,5],[2,3],[2,4],[2,5] ],
   [ [0,6],[0,7],[0,8],[1,6],[1,7],[1,8],[2,6],[2,7],[2,8] ],
   [ [3,0],[3,1],[3,2],[4,0],[4,1],[4,2],[5,0],[5,1],[5,2] ],
   [ [3,3],[3,4],[3,5],[4,3],[4,4],[4,5],[5,3],[5,4],[5,5] ],
   [ [3,6],[3,7],[3,8],[4,6],[4,7],[4,8],[5,6],[5,7],[5,8] ],
   [ [6,0],[6,1],[6,2],[7,0],[7,1],[7,2],[8,0],[8,1],[8,2] ],
   [ [6,3],[6,4],[6,5],[7,3],[7,4],[7,5],[8,3],[8,4],[8,5] ],
   [ [6,6],[6,7],[6,8],[7,6],[7,7],[7,8],[8,6],[8,7],[8,8] ],
   # columns (left to right)
   [ [0,0],[1,0],[2,0],[3,0],[4,0],[5,0],[6,0],[7,0],[8,0] ],
   [ [0,1],[1,1],[2,1],[3,1],[4,1],[5,1],[6,1],[7,1],[8,1] ],
   [ [0,2],[1,2],[2,2],[3,2],[4,2],[5,2],[6,2],[7,2],[8,2] ],
   [ [0,3],[1,3],[2,3],[3,3],[4,3],[5,3],[6,3],[7,3],[8,3] ],
   [ [0,4],[1,4],[2,4],[3,4],[4,4],[5,4],[6,4],[7,4],[8,4] ],
   [ [0,5],[1,5],[2,5],[3,5],[4,5],[5,5],[6,5],[7,5],[8,5] ],
   [ [0,6],[1,6],[2,6],[3,6],[4,6],[5,6],[6,6],[7,6],[8,6] ],
   [ [0,7],[1,7],[2,7],[3,7],[4,7],[5,7],[6,7],[7,7],[8,7] ],
   [ [0,8],[1,8],[2,8],[3,8],[4,8],[5,8],[6,8],[7,8],[8,8] ],
   # rows (top to bottom)
   [ [0,0],[0,1],[0,2],[0,3],[0,4],[0,5],[0,6],[0,7],[0,8] ],
   [ [1,0],[1,1],[1,2],[1,3],[1,4],[1,5],[1,6],[1,7],[1,8] ],
   [ [2,0],[2,1],[2,2],[2,3],[2,4],[2,5],[2,6],[2,7],[2,8] ],
   [ [3,0],[3,1],[3,2],[3,3],[3,4],[3,5],[3,6],[3,7],[3,8] ],
   [ [4,0],[4,1],[4,2],[4,3],[4,4],[4,5],[4,6],[4,7],[4,8] ],
   [ [5,0],[5,1],[5,2],[5,3],[5,4],[5,5],[5,6],[5,7],[5,8] ],
   [ [6,0],[6,1],[6,2],[6,3],[6,4],[6,5],[6,6],[6,7],[6,8] ],
   [ [7,0],[7,1],[7,2],[7,3],[7,4],[7,5],[7,6],[7,7],[7,8] ],
   [ [8,0],[8,1],[8,2],[8,3],[8,4],[8,5],[8,6],[8,7],[8,8] ],
   # custom/special units not yet implemented (diagonal and other overlaps)
);

sub solved_cells {
   my($x,$y,$count);
   $count = 0;
   for ($x = 0; $x < 9; $x++) {
      for ($y = 0; $y < 9; $y++) {
         if ( index($symbols,$startgrid[$x][$y]) >= 0 ) { $count++ }
      }
   }
   return $count;
}

sub get_grid {
   my($x,$y) = @_;
   return $startgrid[$x][$y];
}

sub put_grid {
   my($x,$y,$value) = @_;
   $startgrid[$x][$y] = $value;
}

sub coord_in_unit {
   my($x,$y,$i) = @_;
   my($result,$p);
   $result = 0; # not for now
   for ($p = 0; $p < 9; $p++) {
      if ( $units[$i][$p][0] == $x and $units[$i][$p][1] == $y ) { $result = 1 } # ja wel
   }
   return $result;
}

sub unused_symbol {
   my($i) = @_;
   my($result,$s,$kan,$symbool,$p,$x_pos,$y_pos);
   $result = "?";
   for ($s = 0; $s < 9; $s++) {
      $kan = 1;
      $symbool = substr($symbols,$s,1);
      for ($p = 0; $p < 9; $p++) {
         $x_pos = $units[$i][$p][0];
         $y_pos = $units[$i][$p][1];
         if ($startgrid[$x_pos][$y_pos] eq $symbool) { $kan = 0 }
      }
      if ($kan) { $result = $symbool }
   }
   return $result;
}

sub can {
   my($xx,$yy,$sym) = @_;
   my($u,$p,$ux,$uy);
   if ($startgrid[$xx][$yy] ne " ") { return 0 } # can not
   for ($u = 0; $u <= $#units; $u++) {
      if ( coord_in_unit($xx,$yy,$u) ) {
         for ($p = 0; $p < 9; $p++) {
            $ux = $units[$u][$p][0];
            $uy = $units[$u][$p][1];
            if ($startgrid[$ux][$uy] eq $sym) { return 0 } # can not
         }
      }
   }
   return 1; # can
}

sub print_units{
   print " 0,0 .. 0,8\n";
   print "   :    :           0-8:3x3-blocks  9-17:columns  18-26:rows\n";
   print " 8,0 .. 8,8\n";
   print "Nr :  ---- Nine-unit positions (row,column) -----\n";
   for ($unit_index = 0; $unit_index <= $#units; $unit_index++) {
      printf ("%2s :",$unit_index);
      for ($p = 0; $p < 9; $p++) {
         print "  ",$units[$unit_index][$p][0],",",$units[$unit_index][$p][1];
      }
      print "\n";
   }
}

sub print_unit{
   my($unit_index) = @_;
   print "\n  - - - - - - - - - - - -\n";
   for ($xstart = 0; $xstart < 9; $xstart = $xstart + 3) {
      for ($x = $xstart; $x < $xstart + 3; $x++) {
         for ($ystart = 0; $ystart < 9; $ystart = $ystart + 3) {
            print " |";
            for ($y = $ystart; $y < $ystart + 3; $y++) {
               if ( coord_in_unit($x,$y,$unit_index) ) { print " #"; } else { print "  "; }
            }
         }
         print " |\n";
      }
      print "  - - - - - - - - - - - -\n";
   }
}

sub load_grid {
   my($f,$filename,$x,$y,$namechar,$line);
   opendir(DIR,".") or die "can't opendir $dirname: $!";
   @savedgrids = grep { /^grid\..*\.txt$/ } readdir(DIR);
   closedir(DIR);
   for ($f = 0; $f <= $#savedgrids; $f++) {
      print "   ",$f,". ",$savedgrids[$f],"\n";
   }
   print "   99. Cancel    Select: "; $line = <STDIN>;
   if ( $line == 99 ) { return; }
   $filename = $savedgrids[$line];
   open( my $in, $filename )   or die "Couldn't read $filename: $!";
   $x = -1;
   while ( <$in> ) {
      $line = $_;
      if ($x < 0) {
         $symbols = substr($line,0,9);
      }
      if ($x >= 0) {
         for ($y = 0; $y < 9; $y++) {
            $startgrid[$x][$y] = substr($line,$y,1);
         }
      }
      $x++;
   }
   close $in;
   $count_puts = 0;
   $count_runs = 0;
   @runlog = (); 
   push(@runlog,"LOAD: $filename");
   print_grid;
}

sub readgrid {
   my($initline,$line);
   $initline = $symbols;
   print "   Enter symbol list : [",$initline,"] "; $line = <STDIN>;
   $line = substr($line,0,9); if ( length($line) == 9 ) { $symbols = $line }

   print "\n   Enter row data symbols ('-' for empty cells)\n\n";
   for ($x = 0; $x < 9; $x++) {
      $initline = "";
      for ($y = 0; $y < 9; $y++) { $initline .= $startgrid[$x][$y] }
      print "   Row ",$x+1,"  [",$initline,"] "; $line = <STDIN>;
      $line = substr($line,0,9);
      if ( length($line) == 9 ) {
         for ($y = 0; $y < 9; $y++) {
            if ( substr($line,$y,1) eq "-" ) {
               $startgrid[$x][$y] = " ";
            }
            else {
               $startgrid[$x][$y] = substr($line,$y,1);
            }
         }
      }
   }
}

sub save_grid {
   my($filename,$x,$y,$namechar);
   $filename = "grid.";
   $filename .= solved_cells();
   $filename .= ".";
   for ($y = 0; $y < 9; $y++) {
      $namechar = $startgrid[4][$y]; if ($namechar eq " ") { $namechar = "-" }
      $filename .= $namechar;
   }
   $filename .= ".txt";
   print "\nSaved file: ",$filename,"\n";
   open my $fh,">",$filename or die "Could not open $filename: $!";
   print $fh $symbols,"\n";
   for ($x = 0; $x < 9; $x++) {
      for ($y = 0; $y < 9; $y++) { print $fh $startgrid[$x][$y]; }
      print $fh "\n";
   }
   close $fh or die "$fh: $!";
}

sub print_grid {
   system("clear");
   print "Valid symbols: $symbols\n";
   print "Solved cells: ".solved_cells."\n";
   print "\n  - - - - - - - - - - - -\n";
   for ($xstart = 0; $xstart < 9; $xstart += 3) {
      for ($x = $xstart; $x < $xstart + 3; $x++) {
         for ($ystart = 0; $ystart < 9; $ystart += 3) {
            print " |";
            for ($y = $ystart; $y < $ystart + 3; $y++) { print " ",$startgrid[$x][$y] }
         }
         print " |\n";
      }
      print "  - - - - - - - - - - - -\n";
   }
   print "\n"; foreach (@runlog) { print ">> ","$_\n" }
}

sub try_exclude {
   $count_runs++;
   $count_puts = 0;
   my($c,$x,$y,$count,$symbol,$can_symbol);
   for ($x = 0; $x < 9; $x++) {
      for ($y = 0; $y < 9; $y++) {
         if ( index($symbols,$startgrid[$x][$y]) < 0 ) {
            $count = 0;
            for ($c = 0; $c < 9; $c++) {
               $symbol = substr($symbols,$c,1);
               if (can($x,$y,$symbol)) {
                  $count++;
                  $can_x = $x;
                  $can_y = $y;
                  $can_symbol = $symbol;
               }
            }
            if ($count == 1) {
               $count_puts++;
               put_grid($can_x,$can_y,$can_symbol);
               print_grid;
             # print " symbol '",$can_symbol,"' ";
             # print "on line ",$can_x+1,", column ",$can_y+1,"\n";
            }
         }
      }
   }
   push(@runlog,"Run:".$count_runs." -exclude- score=".$count_puts." total=".solved_cells());
   print_grid;
}

sub try_combine {
   $count_runs++;
   $count_puts = 0;
   for ($unit_index = 0; $unit_index <= $#units; $unit_index++) {
      for ($c = 0; $c < 9; $c++) {
         $symbol = substr($symbols,$c,1);
         if ($symbol ne "?") {
            $count = 0;
            for ($p = 0; $p < 9; $p++) {
               $x_pos = $units[$unit_index][$p][0];
               $y_pos = $units[$unit_index][$p][1];
               if (can($x_pos,$y_pos,$symbol)) {
                  $count++;
                  $can_x = $x_pos;
                  $can_y = $y_pos;
               }
            }
            if ($count == 1) {
               $count_puts++;
               put_grid($can_x,$can_y,$symbol);
               print_grid;
             # print " Er kan een '",$symbol,"' ";
             # print "op regel ",$can_x+1,", kolom ",$can_y+1,"\n";
            }
         }
      }
   }
   push(@runlog,"Run:".$count_runs." -combine- score=".$count_puts." total=".solved_cells());
   print_grid;
}

### MAIN ROUTINE ###
while ( 1 == 1 ) {
   print "\nGRID: 1.Load 2.New 3.Save 4.Show";
   print "  SOLVE: 5.Auto-solve 6.Combine 7.Exclude";
   print "  UNITS: 8.Print";
   print "  9.EXIT    Select: ";
   $line = <STDIN>;
   if (substr($line,0,1) eq "1") { load_grid }
   if (substr($line,0,1) eq "5") {
      $count_so_far = solved_cells(); $more_to_solve = "yes";
      push(@runlog,"Start auto-loop");
      print_grid;
      while ( $more_to_solve eq "yes" ) {
         if (solved_cells() < 81) { try_combine }
         if (solved_cells() < 81) { try_combine }
         if (solved_cells() < 81) { try_exclude }
         if (solved_cells() == $count_so_far) { $more_to_solve = "no" }
         $count_so_far = solved_cells();
      }
      push(@runlog,"Ready auto-loop");
      print_grid;
   }
   if (substr($line,0,1) eq "2") { readgrid }
   if (substr($line,0,1) eq "3") { save_grid }
   if (substr($line,0,1) eq "4") { print_grid }
   if (substr($line,0,1) eq "6") { if (solved_cells() < 81) { try_combine } }
   if (substr($line,0,1) eq "7") { if (solved_cells() < 81) { try_exclude  } }
   if (substr($line,0,1) eq "8") { print_units }
   if (substr($line,0,1) eq "9") { exit }
}


#
# reference grid positions x,y
#   - - - - - - - - - - - - - - - - - - - - - - - - - - -
#  |  0,0  0,1  0,2  |  0,3  0,4  0,5  |  0,6  0,7  0,8  |
#  |  1,0  1,1  1,2  |  1,3  1,4  1,5  |  1,6  1,7  1,8  |
#  |  2,0  2,1  2,2  |  2,3  2,4  2,5  |  2,6  2,7  2,8  |
#   - - - - - - - - - - - - - - - - - - - - - - - - - - -
#  |  3,0  3,1  3,2  |  3,3  3,4  3,5  |  3,6  3,7  3,8  |
#  |  4,0  4,1  4,2  |  4,3  4,4  4,5  |  4,6  4,7  4,8  |
#  |  5,0  5,1  5,2  |  5,3  5,4  5,5  |  5,6  5,7  5,8  |
#   - - - - - - - - - - - - - - - - - - - - - - - - - - -
#  |  6,0  6,1  6,2  |  6,3  6,4  6,5  |  6,6  6,7  6,8  |
#  |  7,0  7,1  7,2  |  7,3  7,4  7,5  |  7,6  7,7  7,8  |
#  |  8,0  8,1  8,2  |  8,3  8,4  8,5  |  8,6  8,7  8,8  |
#   - - - - - - - - - - - - - - - - - - - - - - - - - - -
