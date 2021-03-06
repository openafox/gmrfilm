
c--------------------------------PAP------------------------------------
c
c     Calculates x-ray intensities using PAP model.
c     program completed 10/89  by richard a. waldo
c
      subroutine pap(adelta,i,nel,nels,zx,ax,cnc,e0,xline,line,toa,mac
     &,mode,za,a1,a2,b1,rc,rm,rx,symbol,caller,z)
      implicit real*8 (d)
      real zx(15),ax(15),cnc(15),mac(15,15),c1(15),flmdepth(6)
     &,za(2),mparam,adelta(7),chiovl(6),p(3),ad(3),ju,javg,mavg
      integer nel(7)
      character*3 lintab(12)
      character*7 symbol
      character*26 callerb
      character*1 mode,caller
      data lintab/'Kb ','Ka ','Lg2','Lb3','Lb4','Lg1',
     &           'Lb1','Lb2','La1','Mg ','Mb ','Ma '/
c
c          initialize variables
c
      csctheta=1./sin(toa/57.2958)
      u0=e0/xline
      rt=7.e-6*e0**1.65
      sum=0.
      tmpdepth=0.
      do 2 j=1,6
        tmpdepth=tmpdepth+adelta(j)
        flmdepth(j)=tmpdepth
2     continue
c
c Calculate starting compositions for the weighted-composition-iteration
c using the same formula in my MAS'88 paper which was used
c for starting thicknesses.
c
      if (mode.eq.'F') then
        do 5 j=1,nels
          layer=layr(nel,j)
          if (layer.eq.1) then
            c1(j)=cnc(j)*(2.-adelta(1)/rt)*adelta(1)/rt
          else if (layer.eq.7) then
            c1(j)=cnc(j)*(1.-flmdepth(6)/rt)*(rt-flmdepth(6))/rt
          else
            c1(j)=cnc(j)*
     &       (((2.-flmdepth(layer)/rt)*flmdepth(layer)/rt)-
     &        ((2.-flmdepth(layer-1)/rt)*flmdepth(layer-1)/rt))
c            c1(j)=cnc(j)*(2.-(adelta(layer-1)+adelta(layer))/rt)
c     &     *(adelta(layer)-adelta(layer-1))/rt
          endif
          if (c1(j).le.0.) c1(j)=1.e-5
5       continue
      else
        do 6 j=1,nels
6       c1(j)=cnc(j)
      endif
      iter=0
      sum=0.
      do 10 j=1,nels
10      sum=sum+c1(j)
      do 15 j=1,nels
15      c1(j)=c1(j)/sum

1      iter=iter+1
      zn=0.
      z=0.
      mavg=0.
      javg=0.

      do 50 j=1,nels
        mavg=mavg+zx(j)/ax(j)*c1(j)
        zn=zn+alog(zx(j))*c1(j)
        z=z+zx(j)*c1(j)
        javg=javg+c1(j)*zx(j)/ax(j)*
     &alog(zx(j)*(10.04+8.25*exp(-1.*zx(j)/11.22))/1000.)
50    continue

      zn=exp(zn)

      javg=javg/mavg
      javg=exp(javg)

      p(1)=0.78
      p(2)=0.1
      p(3)=-1.*(0.5-0.25*javg)
      ad(1)=6.6e-6
      ad(2)=1.12e-5*(1.35-0.45*(javg*javg))
      ad(3)=2.2e-6/javg
c
      dr0=0.
      do 100 j=1,3
        p1=1.+p(j)
        p2=1.-p(j)
        dr0=dr0+javg**p2*ad(j)/mavg*(e0**p1-xline**p1)/p1
100   continue

      q0=1.-.535*exp(-(21./zn)**1.2)-.00025*(zn/20.)**3.5
      bet=40./z
      operand=amin1((u0-1.)/bet,88.)
      q=q0+(1.-q0)*exp(-operand)
      adelt=z**.45
      aad=1.+1./(u0**adelt)
      drx=q*aad*dr0
      rx=drx
      if (mode.eq.'B') goto 200
      if (abs(rx*1.e6-rt*1.e6).gt.0.02) then
         call papwt(adelta,cnc,c1,nel,nels,-0.4*rx,rx)
         rt=rx
         goto 1
      endif
      call papwt(adelta,cnc,c1,nel,nels,-0.4*rx,0.5*rx)
200   zp=0.
      do 300 j=1,nels
300     zp=zp+zx(j)**0.5*c1(j)
      zp=zp*zp
      eta=.00175*zp+0.37*(1.-exp(-1.*(.015*(zp**1.3))))
      wavg=0.595+eta/3.7+eta**4.55
      alph=(2.*wavg-1.)/(1.-wavg)
      ju=1.+u0*(alog(u0)-1.)
      gu=(u0-1.-((1.-(1./u0**(alph+1.)))/(1.+alph)))/
     &((2.+alph)*ju)
      gamm=2.-2.3*eta
      dphi0=1.+3.3*(1.-(1./u0**gamm))*eta**1.2
      rb=1.-eta*wavg*(1.-gu)
      if (mode.eq.'F')
     &call papwt(adelta,cnc,c1,nel,nels,-0.6*rx,0.7*rx)
      z=0.
      javg=0.
      mavg=0.
      do 350 j=1,nels
        z=z+zx(j)*c1(j)
        mavg=mavg+zx(j)/ax(j)*c1(j)
        javg=javg+c1(j)*zx(j)/ax(j)
     &       *alog(zx(j)*(10.04+8.25*exp(-1.*zx(j)/11.22))/1000.)
350   continue
      javg=javg/mavg
      javg=exp(javg)
      if (lintab(line)(1:1).eq.'L') mparam=.82
      if (lintab(line)(1:1).eq.'M') mparam=.78
      if (lintab(line)(1:1).eq.'K') then
        if (zx(i).gt.30) then
          mparam=.86
        else
          mparam=.86+0.12*exp(-1.*(zx(i)/5.)**2.)
        endif
      endif
      if (i.eq.16) mparam=.86
      p(3)=-1.*(0.5-0.25*javg)
      ad(2)=1.12e-5*(1.35-0.45*(javg*javg))
      ad(3)=2.2e-6/javg

      v0=e0/javg
      qe=alog(u0)/xline**2/u0**mparam
      t7=rb*(u0/v0)/mavg
      df=0.
      do 400 k=1,3
        t=1.+p(k)-mparam
        t1=u0**t
        df=df+t7*(ad(k)*(v0/u0)**p(k)*(t*t1*alog(u0)-t1+1.)/
     &t**2)/qe
400   continue
      if (mode.eq.'F') z=(z+zp)/2.
      g1z=.11+.41*exp(-(z/12.75)**.75)
      g2z=1.
      g3z=1.
      t1=-(u0-1.)**.35/1.19
      if (t1.gt.-88.) g2z=1.-exp(t1)
      t2=-(u0-.5)*z**.4/4.
      if (t2.gt.-88.) g3z=1.-exp(t2)
      dRm=g1z*g2z*g3z*drx
      dt1=dphi0*drx/3.
      delt=(drx-drm)*(df-dt1)*((drx-drm)*df-dphi0*drx*(drm+drx/3))
      if (delt.lt.0.) then
        rmt=drm
        drm=drx*(df-dphi0*drx/3.)/(df+dphi0*drx)
        rm=drm
        delt=0.
        if (caller.eq.'E') callerb='pure element standard     '
        if (caller.eq.'F') callerb='fluorescence, film        '
        if (caller.eq.'C') callerb='compound standard         '
        if (caller.eq.'B') callerb='fluorescence, bulk (std.?)'
        if (caller.eq.'I') callerb='main iteration procedure  '
c  Warning statements suppressed when calling
c  routine is either bulk or film fluorescence

        if ((caller.eq.'E').or.(caller.eq.'C').or.(caller.eq.'I'))
     &     print 979,symbol(1:4),rmt*1.e6,rm*1.e6,callerb
979     format(' !!!Warning!!! overvoltage ratio is too low for ',a4
     &,/,' Rm lowered from',f7.2,' to',f7.2,' to calculate parameters;'
     &,/,' Calling routine : ',a26)
      endif
      drc=1.5*((df-dt1)/dphi0-dsqrt(delt)/(dphi0*(drx-drm)))
      da1=dphi0/(drm*(drc-drx*(drc/drm-1.)))
      da2=da1*(drc-drm)/(drc-drx)
      db1=dphi0-da1*drm*drm
      if (i.eq.16) goto 451
      i1=1
      i2=nel(1)
      layer=layr(nel,i)
      if ((caller.eq.'F').or.(caller.eq.'B')) then
        chi=0.
        do 447 n=1,7
447       chiovl(n)=0.
        goto 451
      endif
      if (mode.eq.'B') goto 449
      if (layer.ge.2) call chiov(mac,i,nel,layer,cnc,chiovl)
      do 448 kk=1,7
        if (layer.eq.kk) goto 449
        i1=i1+nel(kk)
        i2=i2+nel(kk+1)
448   continue
449   chi=0.
      do 450 j=i1,i2
450     chi=chi+cnc(j)*mac(i,j)
451    if (mode.eq.'B') layer=8
      call papint(adelta,layer,da1,da2,db1,drc,drm,drx,
     &chi,chiovl,dza1,csctheta)
      za(2)=df
      a1=da1
      a2=da2
      b1=db1
      rm=drm
      rx=drx
      rc=drc
      za(1)=dza1
      return
      end
