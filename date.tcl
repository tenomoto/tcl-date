package provide date 0.1

namespace eval date {

  namespace export is_leap_year days_in_month weekday day_of_year date pentad pentad_dates

  proc is_leap_year {year} {
  # returns the number of extra days in February in a given year

  # Return value
  #  0: not a leap year
  #  1: a leap year

    set m4 [expr {$year % 4}]
    set m100 [expr {$year % 100}]
    set m400 [expr {$year % 400}]

    if {$m4!=0} {
      return 0
    } elseif {$m100!=0} {
      return 1
    } elseif {$m400!=0} {
      return 0
    } else {
      return 1
    }
  }

  proc days_in_month {year month} {
  # returns the number of days in a given month

  # Return value
  #  the number of days

    if {$month==2} {
      return [expr {28 + [is_leap_year $year]}]
    } elseif {[lsearch {4 6 9 11} $month]!=-1} {
      return 30
    } else {
      return 31
    }
  }

  proc weekday {y m d} {
  # returns the day of the week

  # Zeller's algorithm
  # 0 Sunday 1 Monday ...

  # treat Jan and Feb as 13th and 14th month of the previous year
    if {$m<2} {
      set m [expr {$m + 12}]
      incr y -1
    }

    return [expr { ($d - 1 + (13*($m+1)/5) + $y + ($y/4) - ($y/100) + ($y/400)) % 7 } ]
  }

  proc day_of_year {y m d} {
  # returns the day of the year

    set i 1
    while {$i<$m} {
      set d [expr {$d+[days_in_month $y $i]}]
      incr i
    }
    return $d
  }

  proc date {y d} {
  # returns yyyymmdd from year and the day of the year

    set m 1
    set n [days_in_month $y $m]
    while {$d>$n} {
      set d [expr {$d-$n}]
      incr m
      set n [days_in_month $y $m]
    }
    return [list $y $m $d]
  }

  proc pentad {y m d} {
  # returns the pentad the date belongs to

  # 29 Feb
    set z 60
    
    set l [is_leap_year $y]
    set x [day_of_year $y $m $d]
    if {$x>$z} {
      set x [expr {$x-$l}]
    }
    return [expr {($x-1)/5+1}]
  }

  proc pentad_dates {p} {
  # returns beginning and ending dates of the pentad

    set y 1999
    set d [expr {($p-1)*5+1}]
    
    set b [date $y $d]
    set e [date $y [incr d 4]]
    return [list [lrange $b 1 2] [lrange $e 1 2]]
  }
}

