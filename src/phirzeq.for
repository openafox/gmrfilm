c-------------------------------PHIRZEQ---------------------------------
c
c     calculates the four phi(rz) parameters alpha, beta, gamma
c     and phi(0) for each layer in a thin film system.  several
c     models are included (see main program for list).  the variable
c     phipar contains the i.d. of the particular model used.
c     program completed 4/87  by richard a. waldo
c
c     updated 10/88 for Bastin's nbs workshop model (1988), r.a. waldo
c     NOTE: see also Scanning vol.12, 1990. p.225
c
      subroutine phirzeq(nel,nels,i3,delta,alpha,beta,gamma,phi0
     &,z1,a1,cnc,e0,xline,phipar,line,ff,z)
      real z1(15),a1(15),cnc(15),aj(15),iu,pk(3),d(3)
     &,javg,s(3),ju,mparam,lwt(14),delta(7)
      integer nel(7)
      logical flag,flags(16),ff
      character*1 phipar
      character*3 lines(12)
      data lines/'Kb ','Ka ','Lg2','Lb3','Lb4','Lg1',
     &           'Lb1','Lb2','La1','Mg ','Mb ','Ma '/
c
c          initialize variables
c
      u0=e0/xline
      alpha=1.e6/(3.*e0**1.7)
      javg=0.
      bsf=0.
      zp=0.
      do 1 k=1,5
        ajp=0.
        z=0.
        a=0.
        za=0.
        talpha=alpha
        call scale(delta,talpha,lwt)
        do 100 j=1,nels
          layer=layr(nel,j)
          if (cnc(j).eq.0.) cnc(j)=1.e-5
          if (phipar .eq. 'B') then
            aj(j)=(9.29*z1(j)*(1.+1.287/z1(j)**0.667))/1000.
          else if (phipar .eq. 'C') then
            aj(j)=z1(j)*(10.04+8.25*exp(-1.*z1(j)/11.22))/1000.
          else if (phipar .eq. 'P') then
            ajp=ajp+lwt(layer)*cnc(j)*.0115*z1(j)
          endif
          za=za+(z1(j)/a1(j))*lwt(layer)*cnc(j)
          z=z+z1(j)*lwt(layer)*cnc(j)
          a=a+a1(j)*lwt(layer)*cnc(j)
100     continue
        alpha=0.
        do 200 i=1,nels
          layer=layr(nel,i)
          if (phipar.eq.'B') then
            alpha=alpha+(((175000./(e0**1.25*(u0-1.)**0.55))
     &      *((alog(1.166*e0/aj(i))/xline)**0.5))**2)
     &      *(lwt(layer)*cnc(i)*z1(i)/a1(i))
          else if (phipar.eq.'C') then
            alpha=alpha+1./((216140.*z1(i)**1.163/(e0**1.25*a1(i)*
     &      (u0-1.)**0.5))*((alog(1.166*e0/aj(i))/xline)**0.5))*
     &      lwt(layer)*cnc(i)*z1(i)/a1(i)
          endif
200     continue
        if (phipar.eq.'B') then
          alpha=sqrt(a*alpha/z)
        else if (phipar.eq.'C') then
          alpha=za/alpha
        else if (phipar.eq.'P') then
          alpha=(415000./e0**0.75)*((z-1.3)/z)*(za**0.5)*
     &    (sqrt(za*alog((1.166/ajp*(e0+xline)/2.))/(e0**2-xline**2)))
        endif
        if (delta(1).eq.0.) goto 202
        if (abs(alpha-talpha).lt.1.) goto 202
1     continue
202   if (phipar .eq. 'B') goto 1000
      if (phipar .eq. 'P') goto 2000
      if (phipar .eq. 'C') goto 3000
c
c     calculate according to bastin scanning'86 paper
c
1000  do 1100 j=1,nels
        layer=layr(nel,j)
        eta=(-52.3791+150.48371*z1(j)
     &  -1.67373*z1(j)**2+0.00716*z1(j)**3)/10000.
        geta=(-1112.8+30.289*z1(j)-0.15498*z1(j)**2)/10000.
        eta=eta*(1.0+geta*alog(e0/20.))
        bsf=bsf+lwt(layer+7)*cnc(j)*eta
1100  continue
      gu=-.59299+21.55329/u0-30.55248/u0/u0+9.59218/u0/u0/u0
      iu=3.43378-10.7872/u0+10.97628/u0/u0-3.62286/u0/u0/u0
      phi0=1.+(bsf/(1.+bsf))*(iu+gu*alog(1.+bsf))
c
      if (u0.le.3. ) gamma=1.+(u0-1)/(.3384+.4742*(u0-1))
      if (u0.gt.3. ) gamma=5.*3.14159*(u0+1.)/u0/(alog(u0+1.))*
     &                       (alog(u0+1.)-5.+5.*(u0+1.)**(-0.2))
      xn=z/(.4765+.5473*z)
      beta=alpha*z**xn/a
      gamma=gamma
      phi0=phi0
      return
c
c     calculate according to packwood
c
2000  do 2100  j=1,nels
        layer=layr(nel,j)
        eta=(-52.3791+150.48371*z1(j)
     &  -1.67373*z1(j)**2+0.00716*z1(j)**3)/10000.
        bsf=bsf+lwt(layer+7)*cnc(j)*eta
2100  continue
      dum=amax1((1-u0)/2.,-88.)
      phi0=1.+2.7*bsf*(1.-exp(dum))
      gamma=31.4159*u0/(u0-1.)*(1.+(10./(alog(u0))*(u0**(-0.1)-1.)))
      beta=0.4*alpha*z**0.6
      gamma=gamma
      phi0=phi0
      return
c
c     this section calculates the bastin scanning'90 model parameter values.
c
3000  continue
      if (i3.eq.16) then
        mparam=.86
      else
        if (lines(line)(1:1).eq.'L') mparam=.82
        if (lines(line)(1:1).eq.'M') mparam=.78
        if (lines(line)(1:1).eq.'K') then
          if (z1(i3).gt.30) then
            mparam=.86
          else
            mparam=.86+0.12*exp(-1.*(z1(i3)/5.)**2.)
          endif
        endif
      endif
      do 3100 j=1,nels
        layer=layr(nel,j)
        zp=zp+z1(j)**0.5*lwt(layer+7)*cnc(j)
3100    continue
      zp=zp**2
c
      do 3200  j=1,nels
        layer=layr(nel,j)
3200    javg=javg+lwt(layer)*cnc(j)*z1(j)/a1(j)*alog(aj(j))

      javg=javg/za
      javg=exp(javg)
      pk(1)=0.78
      pk(2)=0.1
      pk(3)=-1.*(0.5-0.25*javg)
      d(1)=6.6e-6
      d(2)=1.12e-5*(1.35-0.45*(javg**2.))
      d(3)=2.2e-6/javg
c
c     calculate phi(0), surface ionization; rb, backscatter factor;
c     and f, the integral of the intensity
c
      eta=.00175*zp+0.37*(1.-exp(-1.*(.015*(zp**1.3))))
      wavg=0.595+eta/3.7+eta**4.55
      alph=(2.*wavg-1.)/(1.-wavg)
      ju=1.+u0*(alog(u0)-1.)
      gu=(u0-1.-((1.-(1./u0**(alph+1.)))/(1.+alph)))/
     &((2.+alph)*ju)
      gamm=2.-2.3*eta
c
c     rb is backscatter factor
      rb=1.-eta*wavg*(1.-gu)
c
      phi0=1.+3.3*(1.-(1./u0**gamm))*eta**1.2
c
c     qe is ionization cross section at eO
      qe=alog(u0)/xline**2/u0**mparam
      v0=e0/javg
      t7=rb*(u0/v0)/za
      do 3300 i=1,3
        t=1.+pk(i)-mparam
        t1=u0**t
        s(i)=t7*(d(i)*(v0/u0)**pk(i)*(t*t1*alog(u0)-t1+1.)/t**2)/qe
3300  continue
      f=s(1)+s(2)+s(3)
      if (u0 .le. 6. )
     &  gamma=3.98352*u0**(-0.0516861)*(1.276233-u0**
     &  (-1.25558*z**(-0.1424549)))
      if (u0 .gt. 6. )
     &  gamma=2.814333*u0**(0.262702*z**
     &  (-0.1614454))
      if (xline .lt. 0.7)
     &   gamma=gamma*xline/(-.0418780+1.05975*xline)
      call bastbeta(alpha,beta,gamma,phi0,f,flag)
      if (flag) then
        if (flags(i3)) goto 998
         flags(i3)=.true.
         if (i3.eq.16) then
           if (.not.ff) print 9998
         else
           if (.not.ff) print 9999,int(z1(i3)),lines(line)
         endif
9998    format(/' !!! 0>R(b/2a)>1 for continuum excitation distribution
     &')
9999    format(/' !!! 0>R(b/2a)>1 for
     &element Z = ',i2,', xline = ',a3,' !!!',/,' !!! Overvoltage ratio
     &  may be too low !!!'/)
      endif
998   continue
      return
      end
