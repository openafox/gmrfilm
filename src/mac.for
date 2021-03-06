c-------------------------------MAC----------------------------------
c
c     a) calculation of the parameters used to calculate the
c        mass absortion coefficients
c     b) calculation of mass absorption coefficients
c     heinrich, proceedings icxom-11 1986.
c     10/88 r.a. waldo
c
      subroutine mac(xmu,nz,at,ex,iflag)
      real n
      iflag=1
c
c      calculate 'c' parameter
c
      if (ex.gt.edge(nz,'Ka ')) then
         ie=1
        if (nz.lt.6) then
          c=-2.87536  e-4
     &      +1.808599 e-3*nz
        else
          c=+5.253   e-3
     &      +1.33257 e-3*nz
     &      -7.5937  e-5*nz*nz
     &      +1.69357 e-6*nz*nz*nz
     &      -1.3975  e-8*nz*nz*nz*nz
        endif
      else if (ex.gt.edge(nz,'La1')) then
         c=-9.24    e-5
     &     +1.41478 e-4*nz
     &     -5.24999 e-6*nz*nz
     &     +9.85296 e-8*nz*nz*nz
     &     -9.07306 e-10*nz*nz*nz*nz
     &     +3.19254 e-12*nz*nz*nz*nz*nz
         if (ex.gt.edge(nz,'Lb3')) then
         ie=2
           c=c
         else if (ex.gt.edge(nz,'Lb1')) then
         ie=3
           c=c*.858
         else
           ie=4
           c=c*(.8933-nz*8.29e-3+nz*nz*6.38e-5)
         endif
      else if (ex.gt.edge(nz,'M1 ')) then
         ie=5
        if (nz.lt.30) then
          c=+1.889757  e-2
     &      -1.8517159 e-3*nz
     &      +6.9602789 e-5*nz*nz
     &      -1.1641145 e-6*nz*nz*nz
     &      +7.2773258 e-9*nz*nz*nz*nz
        else
          c=+3.0039     e-3
     &      -1.73663566 e-4*nz
     &      +4.0424792  e-6*nz*nz
     &      -4.0585911  e-8*nz*nz*nz
     &      +1.497763   e-10*nz*nz*nz*nz
        endif
      else if (ex.gt.edge(nz,'Ma ')) then
         c1=+7.7708   e-5
     &      -7.83544  e-6*nz
     &      +2.209365 e-7*nz*nz
     &      -1.29086  e-9*nz*nz*nz
         c2=+1.406
     &      +.0162    *nz
     &      -6.561 e-4*nz*nz
     &      +4.865 e-6*nz*nz*nz
         c3=+0.584
     &      +0.01955    *nz
     &      -1.285   e-4*nz*nz
         c4=+1.082
     &      +1.366 e-3*nz
         c5=+1.6442
     &      -0.0480    *nz
     &      +4.0664 e-4*nz*nz
         if (ex.gt.edge(nz,'M2 ')) then
           ie=6
           c=c1*c2*c3
         else if (ex.gt.edge(nz,'Mg ')) then
           ie=7
           c=c1*c2*c4
         else if (ex.gt.edge(nz,'Mb ')) then
           ie=8
           c=c1*c2*0.95
         else
           ie=9
           c=c1*c2*c5
         endif
      else 
         ie=10
        c=1.08*(+4.3156   e-3
     &          -1.4653   e-4*nz
     &          +1.707073 e-6*nz*nz
     &          -6.69827  e-9*nz*nz*nz)
        if (ex.lt.edge(nz,'N1 ')) then
         cutoff=((0.252*nz-31.1812)*nz+1042.)/1000.    
         e=cutoff
         ie=11
        endif
      endif
      
      
c
c      calculate 'n' parameter
c


       if (ex.gt.edge(nz,'Ka ')) then
         if (nz.lt.6) then
           n=+3.34745
     &       +0.02652873 *nz
     &       -0.01273815 *nz*nz
         else
           n=+3.112
     &       -0.0121*nz
         endif
       else if (ex.gt.edge(nz,'La1')) then
         n=+2.7575
     &     +1.889 e-3*nz
     &     -4.982 e-5*nz*nz
       else if (ex.gt.edge(nz,'M1 ')) then
         n=+.5385
     &     +0.084597   *nz
     &     -1.08246 e-3*nz*nz
     &     +4.4509  e-6*nz*nz*nz
       else if (ex.gt.edge(nz,'Ma ')) then
         n=3.0-.004*nz
       else 
         n=.3736+0.02401*nz
      endif


c
c      calculate 'a' parameter
c
       if (ex.gt.edge(nz,'Ka ')) then
         if (nz.lt.6) then 
           a=+24.4545 
     &       +155.6055 *nz
     &       -14.15422 *nz*nz
         else
           a=+47.      *nz
     &       +6.52     *nz*nz
     &       -0.152624 *nz*nz*nz
         endif
        else if (ex.gt.edge(nz,'La1')) then
           a=+17.8096       *nz
     &       +0.067429      *nz*nz
     &       +0.01253775    *nz*nz*nz
     &       -1.16286    e-4*nz*nz*nz*nz
        else if (ex.gt.edge(nz,'M1 ')) then
           a=+10.2575657    *nz
     &       -0.822863477   *nz*nz
     &       +2.63199611 e-2*nz*nz*nz
     &       -1.8641019  e-4*nz*nz*nz*nz
        else if(ex.gt.edge(nz,'Ma ')) then
           a=+4.62 *nz
     &       -0.04 *nz*nz
        else
           a=+19.64      *nz
     &       -0.61239    *nz*nz
     &       +5.39309 e-3*nz*nz*nz
      endif



c
c      calculate 'b' parameter
c
       if (ex.gt.edge(nz,'Ka ')) then
         if (nz.lt.6) then 
           b=-103.
     &       +18.2*nz
         else
           b=0.
         endif
       else if (ex.gt.edge(nz,'La1')) then
          b=0.
       else if (ex.gt.edge(nz,'M1 ')) then
         if (nz.lt.61) then
           b=+5.654       *nz
     &       -0.536839169 *nz*nz
     &       +0.018972278 *nz*nz*nz
     &       -1.683474 e-4*nz*nz*nz*nz
         else
           b=-1232.4022    *nz
     &       +51.114164    *nz*nz
     &       -0.699473097  *nz*nz*nz
     &       +3.1779619 e-3*nz*nz*nz*nz
         endif
       else if (ex.gt.edge(nz,'Ma ')) then
           b=(+2.51
     &       -0.052*nz
     &       +3.78e-4*nz*nz)*edge(nz,'Mb ')*1000.
       else
         b=-113.
     &     +4.5*nz
       endif
      if (ex.gt.edge(nz,'N1 ')) then
        qq=(-ex*1000.+b)/a
        if (qq.gt.88.) then
          qq=88.
        else if (qq.lt.-88.) then
          qq=-88.
        endif
        xmu=c*nz**4/at*((12.397/ex)**n)
     &        *(1.-exp(qq))
        if (xmu.lt.0.) iflag=8
      else
        xmu=((12.397/ex)**n)*c*nz**4/at*(ex-cutoff)/
     &       (1.08*edge(nz,'N1 '))
      endif
      if (ex.lt.1.1*cutoff) iflag=3
      if ((ex-e.lt..02).and.(ex-e.gt.-.005)) iflag=2
      if (ie.eq.9) iflag=5
      if (ie.eq.11) iflag=4
      if ((ie.eq.11).and.((ex-e.lt..02).and.(ex-e.gt.-.005)))
     & iflag=6
      if ((ie.eq.9).and.((ex-e.lt..02).and.(ex-e.gt.-.005)))
     & iflag=7
      if ((xmu.lt.0.).and.(iflag.eq.4)) iflag=9
      return
      end
