c-----------------------------CHARFLR-------------------------------
c
c     This program controls the calculation of the CHARacteristic
c     x-ray FLuoRescence correction for thin film and bulk systems.
c     program completed on 6/88 by richard a. waldo
c
      subroutine charflr(na,nel,nels,mode,zx,ax,symb,
     &e0,cnc,delta,fchar,phipar,toa,mac,exciter,fmac)
      real zx(15),ax(15),cnc(15),mac(15,15),delta(7),
     &fcp(7),fcs(7),delta2(9),za(2),exciter(200,3),fmac(15,200)
      integer nel(7)
      logical ff
c ff overrides R(b/2a) warning message in subroutine prozbeta
      character*1 phipar,mode
      character*7 symb(15),symbol
      character*3 lines(12)
      data lines/'Kb ','Ka ','Lg2','Lb3','Lb4','Lg1',
     &           'Lb1','Lb2','La1','Mg ','Mb ','Ma '/
      fchar=0.
      nnsum=0
      csctheta=1/sin(toa/57.29578)
      ff=.true.
      delta(7)=1.
      rx=1.5*6.5*(e0**1.7)/1.e6
      temp=0.
      delta2(1)=0.
      do 100 kk=2,7
        temp=temp+delta(kk-1)
        delta2(kk)=temp
100   continue
      layera=layr(nel,na)
      do 320 ii=1,7
320     fcs(ii)=0.
      do 330 ik=1,nels
        layerc=layr(nel,ik)
330     fcs(layerc)=fcs(layerc)+mac(na,ik)*cnc(ik)*csctheta
      nn1=int(exciter(184+na,1))
      nn2=int(exciter(185+na,1))
      if (nn2-nn1.eq.0) return
      do 5000 nlb=nn1+1,nn2
        j=int((exciter(nlb,3)-1.)/12)+1
        lb=int(exciter(nlb,3)-12.*(j-1))
        xline=exciter(nlb,2)
        layerb=layr(nel,j)
        leb=nedge(lb)
        symbol(1:2)=symb(j)(1:2)
        symbol(3:5)=lines(lb)
        if (phipar.eq.'E') then
          call pap(delta,j,nel,nels,zx,ax,cnc,e0,xline,lb,
     &    toa,mac,mode,za,a1,a2,b1,rc2,rm,rx,symbol,mode,z)
        else
          call phirzeq(nel,nels,j,delta,alpha,beta,gamma,phi0
     &    ,zx,ax,cnc,e0,xline,phipar,lb,ff,z)
        endif
        do 410 ii=1,7
410       fcp(ii)=0.
        do 420 ik=1,nels
          layerc=layr(nel,ik)
420       fcp(layerc)=fcp(layerc)+cnc(ik)*fmac(ik,nlb)
        if (mode.eq.'B') then
          delta2(8)=0.
          delta2(9)=rx
          else if (mode.eq.'F') then
            if (layerb.eq.7) then
              delta2(8)=delta2(7)
              delta2(9)=rx
            else
              delta2(8)=delta2(layerb)
              delta2(9)=delta2(layerb+1)
            endif
            delta2(9)=amin1(delta2(9),rx)
            if (delta2(8).ge.delta2(9)) goto 5000
          endif
        if (phipar.eq.'E') then
          call papfluor(delta2,fcp,fcs(layera),layera,layerb,
     &    ffact,a1,a2,b1,rc2,rm,rx,mode)
        else
          call tripint(delta2,fcp,fcs(layera),layera,layerb,
     &    ffact,alpha,beta,gamma,phi0,mode)
        endif
        ffact1=ffact
        factor=0.
        if (mode.eq.'B') goto 771
        do 770 kk=2,7
          factor=factor+fcs(kk-1)*delta(kk-1)
          if (layera.eq.kk) ffact=ffact*exp(-1.*amin1(factor,88.))
770     continue
771     continue
        ffact=0.5*cnc(na)*cnc(j)*ffact*exciter(nlb,1)
        fchar=fchar+ffact
5000  continue
      return
10000 end
