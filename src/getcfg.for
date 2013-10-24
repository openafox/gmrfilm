c      
c     get analysis configuration 5/93 r.a. waldo
c
      subroutine getcfg(cfg,phipar,mode,macchang)
      character*1 cfg(10),phipar,mode,macchang,cdum
      print 18
18    format(' Print primary and secondary x-ray intensity data (def=N)?
     & ')
      read 990,cfg(9)
      if (cfg(9).eq.'y') cfg(9)='Y'
20    print 22
22    format(' This is a film (F) or bulk (B) analysis (def.=F)? ')
      read 990,mode
      if ((mode.eq.' ').or.(mode.eq.'f')) mode='F'
      if (mode.eq.'b') mode='B'
      if ((mode.ne.'F').and.(mode.ne.'B')) goto 20
      cdum=phipar
c32    if ((phipar.eq.'B').or.(phipar.eq.'P')) then
32      print 33
33      format(' Include continuum fluorescence correction? ',/,
     &' Note: Not recommended for Bastin Scanning''86 (B)',/,
     &' or Packwood (P) phi(z) models (def.=Y)--> ')
c      else
c        print 34
c34      format(' Include continuum fluorescence correction (def=N)? ')
c      endif
      read 990,cfg(8)
      if (cfg(8).eq.'n') cfg(8)='N'
      if ((cfg(8).eq.' ').or.(cfg(8).eq.'y')) cfg(8)='Y'
      if ((cfg(8).ne.'Y').and.(cfg(8).ne.'N')) goto 32
43    print 44
44    format(/' To calculate k-ratios    enter ''K'' or ''k''; '
     &,/,' To calculate compositions enter ''C'' or ''c'' (def=C): ')
      read 990,cfg(3)
      if ((cfg(3).eq.' ').or.(cfg(3).eq.'c')) cfg(3)='C'
      if (cfg(3).eq.'k') cfg(3)='K'
      if ((cfg(3).ne.'C').and.(cfg(3).ne.'K')) goto 43
      macchang='n'
131   print 132
132   format(' Observe or change mass absorption coefficients (n)? ')
      read 990,macchang
      if ((macchang.eq.'N').or.(macchang.eq.' ')) macchang='n'
      if (macchang.eq.'y') macchang='Y'
      if ((macchang.ne.'Y').and.(macchang.ne.'n')) goto 131
990   format(a1)
      return
      end
