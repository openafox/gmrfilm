c      
c     get beam voltage(s) 5/93 r.a. waldo
c
      subroutine getvolt(cvolt,e0,voltages)
      real e0(15)
      character*5 tempkv
      character*1 cvolt
      integer voltages
      print 1201
1201  format(' Is this a one condition (voltage) analysis (y)? ')
      read 990,cvolt
      if ((cvolt.eq.'n').or.(cvolt.eq.'N')) then
        cvolt='N'
        voltages=2
      else
        cvolt='Y'
        voltages=1
1212    print 1213
1213    format (' Enter the beam voltage (Eo) in kV (def.=15): ')
        read 991,tempkv
        if (tempkv .ne.' ') then
          do 1214 i=1,5
            if (tempkv(i:i).eq.'.') goto 1216
            if (tempkv(i:i).eq.' ') then
              tempkv(i:i)='.'
              goto 1216
            endif
1214      continue
1216      read(tempkv,fmt='(f5.2)')e00
        else
          e00=15.
        endif
        if (e00.le.0.) goto 1212
        do 1218 j=1,15
          e0(j)=e00
1218    continue
      endif
990   format(a1)
991   format(a5)
      return
      end
