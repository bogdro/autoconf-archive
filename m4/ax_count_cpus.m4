# ===========================================================================
#       http://www.gnu.org/software/autoconf-archive/ax_count_cpus.html
# ===========================================================================
#
# SYNOPSIS
#
#   AX_COUNT_CPUS([ACTION-IF-DETECTED],[ACTION-IF-NOT-DETECTED])
#
# DESCRIPTION
#
#   Attempt to count the number of processors present on the machine and
#   place detected value in CPU_COUNT variable. On successful detection,
#   ACTION-IF-DETECTED is executed if present. If the detection fails, then
#   ACTION-IF-NOT-DETECTED is triggered. The default ACTION-IF-NOT-DETECTED
#   is to set CPU_COUNT to 1.
#
# LICENSE
#
#   Copyright (c) 2014,2016 Karlson2k (Evgeny Grin) <k2k@narod.ru>
#   Copyright (c) 2012 Brian Aker <brian@tangent.org>
#   Copyright (c) 2008 Michael Paul Bailey <jinxidoru@byu.net>
#   Copyright (c) 2008 Christophe Tournayre <turn3r@users.sourceforge.net>
#
#   Copying and distribution of this file, with or without modification, are
#   permitted in any medium without royalty provided the copyright notice
#   and this notice are preserved. This file is offered as-is, without any
#   warranty.

#serial 12

  AC_DEFUN([AX_COUNT_CPUS],[
      AC_REQUIRE([AC_CANONICAL_HOST])
      AC_REQUIRE([AC_PROG_EGREP])
      AC_MSG_CHECKING([the number of available CPUs])
      CPU_COUNT="0"

      AS_CASE([$host_os],[
        *darwin*],[
        AS_IF([test -x /usr/sbin/sysctl],[
          sysctl_a=`/usr/sbin/sysctl -a 2>/dev/null| grep -c hw.cpu`
          AS_IF([test sysctl_a],[
            CPU_COUNT=`/usr/sbin/sysctl -n hw.ncpu`
            ])
          ])],[
        *linux*],[
        AS_IF([test "x$CPU_COUNT" = "x0" -a -e /proc/cpuinfo],[
          AS_IF([test "x$CPU_COUNT" = "x0" -a -e /proc/cpuinfo],[
            CPU_COUNT=`$EGREP -c '^processor' /proc/cpuinfo`
            ])
          ])],[
        *mingw*],[
        CPU_COUNT=`reg query HKLM\\\\Hardware\\\\Description\\\\System\\\\CentralProcessor 2>/dev/null | $EGREP -c '@<:@0-9@:>@+' -c` || CPU_COUNT="0"
        AS_IF([[test "$CPU_COUNT" -eq "0" && test "$NUMBER_OF_PROCESSORS" -gt "0" 2>/dev/null]],[dnl
          CPU_COUNT="$NUMBER_OF_PROCESSORS" # Fallback to simple method
          ])],[
        *cygwin*],[
        AS_IF([test -n "$NUMBER_OF_PROCESSORS"],[
          CPU_COUNT="$NUMBER_OF_PROCESSORS"
          ])
        ])

      AS_IF([[test "x$CPU_COUNT" != "x0" && test "$CPU_COUNT" -gt 0 2>/dev/null]],[dnl
          AC_MSG_RESULT([[$CPU_COUNT]])
          m4_ifvaln([$1],[$1],)dnl
        ],[dnl
          m4_ifval([$2],[dnl
            AS_UNSET([[CPU_COUNT]])
            AC_MSG_RESULT([[unable to detect]])
            $2
          ], [dnl
            CPU_COUNT="1"
            AC_MSG_RESULT([[unable to detect (assuming 1)]])
          ])dnl
        ])dnl
      ])dnl
