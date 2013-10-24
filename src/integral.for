c-------------------------------INTEGRAL----------------------------------
c
c     this program integrates the phi(rz) curve.  four cases
c     need to be handled.  case 1) the phi(rz) curve of a bulk
c     specimen (for example when the pure element standard x-ray
c     intensity is needed to calculate a k-ratio.  case 2) the
c     curve for a thin film of thickness delta.  case 3)  the curve
c     for a substrate under a film of thickness delta, the curve is
c     integrated from delta to infinity.  case 4) the curve for a buried
c     film of thickness delta1.  for thin films, weighted
c     average values of the phi(rz) parameters are used (see
c     subprogram to see how the parameter vlues are weighted).
c
c     program completed 4/87 by richard a. waldo
c
      subroutine integral(delta,icase,wtalpha,wtbeta,gamsam
     &,wtphi0,chisam,chiovl,za,toa)
      real mu,chiovl(6),delta(7)
      c=sqrt(3.14159265359)/2.
      csctheta=1./sin(toa/57.2958)
      g=gamsam
      gp=gamsam-wtphi0
      a1=wtalpha
      b=wtbeta
      mu=chisam*csctheta
      if ((icase.eq.1).or.(icase.eq.8)) then
        f1=delta(1)
      else
        f1=0.
        f3=0.
        do 100 j=1,icase-1
          f1=f1+delta(j)
          f3=f3+(chiovl(j)*csctheta-mu)*delta(j)
100     continue
        f2=f1+delta(icase)
        if (icase.eq.7) f2=f1
      endif
      t11=mu/a1/2
      t33=(b+mu)/a1/2
      t1=arfc(t11)
      t3=arfc(t33)
      t4a=exp(-1.*amin1((2.*a1*f1*t11+(a1*f1)**2),88.))
      t4=t4a*arfc((a1*f1)+t11)
      t5a=exp(-1.*amin1((2.*a1*f1*t33+(a1*f1)**2),88.))
      t5=t5a*arfc((a1*f1)+t33)
      if (icase.eq.1) then
        za=c*((g*(t1-t4))-(gp*(t3-t5)))/a1
      else if (icase.eq.8) then
        za=c*(g*t1-gp*t3)/a1
      else
        t6a=exp(-1.*amin1((2.*a1*f2*t11+(a1*f2)**2),88.))
        t6=t6a*arfc((a1*f2)+t11)
        t7a=exp(-1.*amin1((2.*a1*f2*t33+(a1*f2)**2),88.))
        t7=t7a*arfc((a1*f2)+t33)
        if (icase.eq.7) then
          za=c*(((g*t6)-(gp*t7))/a1)*exp(-1.*amin1(f3,88.))
        else
          za=c*((g*(t4-t6))-(gp*(t5-t7)))/a1*exp(-1.*amin1(f3,88.))
        endif
      endif
      return
      end
