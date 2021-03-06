c-------------------------------PAPINT----------------------------------
c
c     This program integrates the phi(rz) curve for PAP model.  4 cases
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
c     program completed 10/89 by richard a. waldo
c
      subroutine papint(adelta,icase,da1,da2,db1,drc,drm,drx,
     &c,chiovl,dza,csctheta)
      implicit real*8 (d)
      real mu,chiovl(6),adelta(7),lim(2,2)
      double precision ppint2
      db2=0.
      mu=c*csctheta
      rc=drc
      rx=drx
      rm=drm
c
c     determine the limits of integration of the functions H1, H2
      if (icase.eq.8) goto 20
      if (icase.eq.1) then
        ad1=0.
        ad2=adelta(1)
        goto 20
      endif
      ad11=0.
      factor=0.
      do 10 j=1,icase-1
        ad11=ad11+adelta(j)
        factor=factor+(chiovl(j)*csctheta-mu)*adelta(j)
10    continue
      if (icase.eq.7) then
        ad1=ad11
        ad2=rx
      else
        ad1=ad11
        ad2=ad11+adelta(icase)
      endif
20    call paplimts(ad1,ad2,icase,rc,rx,lim)
c
      if (lim(1,1).eq.1.) then
        dza1=0.
      else
        if (mu.eq.0.) then
          dza1=da1*(ppint2(da1,db1,drm,mu,lim(1,2))-
     &ppint2(da1,db1,drm,mu,lim(1,1)))
        else
          dza1=-da1/mu*(ppint2(da1,db1,drm,mu,lim(1,2))-
     &ppint2(da1,db1,drm,mu,lim(1,1)))
        endif
      endif
      if (lim(2,1).eq.1.) then
        dza2=0.
      else
        if (mu.eq.0.) then
          dza2=da2*(ppint2(da2,db2,drx,mu,lim(2,2))-
     &ppint2(da2,db2,drx,mu,lim(2,1)))
        else
          dza2=-da2/mu*(ppint2(da2,db2,drx,mu,lim(2,2))-
     &ppint2(da2,db2,drx,mu,lim(2,1)))
        endif
      endif
      za1=dza1
      za2=dza2
      dza=dza1+dza2
      if (dza.le.0.) then
        dza=1.e-11
        return
      endif
      if ((icase.eq.1).or.(icase.eq.8)) return
      dza=dza*exp(-1.*amin1(factor,88.))
      return
      end
