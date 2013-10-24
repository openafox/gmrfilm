c      
c     Bookkeeping for the next calculation.
c     What will the next calculation be? More k-ratios, same system?
c     A different system? Other?
c     5/93 r.a. waldo 
c
      subroutine nextcalc(cfg,mode)
      character*1 cfg(10),mode,chgEo,chgModel,cfg8temp
      character*3 newcfg
      cfg(10)='N'
      if (cfg(3).eq.'C') then
        print 976
976     format (' More k-ratios? (y): ')
        read 990,cfg(1)
        if ((cfg(1).eq.'n').or.(cfg(1).eq.'N')) then
          cfg(1)='N'
        else
          cfg(1)='Y'
          return
        endif
      else if (cfg(3).eq.'K') then
        print 978
978     format (' Another calculation? (y): ')
        read 990,cfg(2)
        if ((cfg(2).eq.'n').or.(cfg(2).eq.'N')) then
          cfg(2)='N'
        else
          cfg(2)='Y'
          return
        endif
      endif
      if ((cfg(8).eq.'Y').and.(mode.eq.'F')) then
        print 982
982     format(' Change Eo (E), Model (M), and/or Remove Continuum corre
     &ction (R); ',/,' Enter any combination (examples:  M  rm  REM ); o
     &therwise <CR> : ')
      else if ((cfg(8).ne.'Y').and.(mode.eq.'F')) then
        print 984
984     format(' Change Eo (E), Model (M), and/or Include Continuum corr
     &ection (I); ',/,' Enter any combination (examples:  M  ei  IEM ); 
     &otherwise <CR> : ')
      else
        print 985
985     format(' Change Eo (E) and/or Model (M) ',/,
     &' Enter any combination (examples:  M  e  em); otherwise <CR> : ')
      endif
      read 991,newcfg
      chgEo=' '
      chgModel=' '
      cfg8temp=cfg(8)
      do 988 k=1,3
        if ((newcfg(k:k).eq.'I').or.(newcfg(k:k).eq.'i')) cfg(8)='Y'
        if ((newcfg(k:k).eq.'R').or.(newcfg(k:k).eq.'r')) cfg(8)='N'
        if ((newcfg(k:k).eq.'E').or.(newcfg(k:k).eq.'e')) chgEo='E'
        if ((newcfg(k:k).eq.'M').or.(newcfg(k:k).eq.'m')) chgModel='M'
988   continue
      if (chgEo.eq.'E') cfg(10)='E'
      if (chgModel.eq.'M') cfg(10)='M'
      if ((chgEo.eq.'E').and.(chgModel.eq.'M')) cfg(10)='B'
      if (cfg8temp.ne.cfg(8)) cfg(10)='C'
      if ((cfg(10).ne.'E').and.(cfg(10).ne.'M').and.(cfg(10).ne.'B')
     &.and.(cfg(10).ne.'C')) then
        cfg(10)='N'
      else
        cfg(4)='Y'
        return
      endif
      print 989
989   format (' New Specimen? (n=exit): ')
      read 990,cfg(4)
      if ((cfg(4).eq.'y').or.(cfg(4).eq.'Y')) then
        cfg(4)='Y'
      else
        cfg(4)='N'
      endif
990   format (a1)
991   format (a3)
      return
      end
