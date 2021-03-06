c------------------------------FTest------------------------------------
c  Fluorescence Test; test if characteristic x-ray fluorescence
c  can occur for the given elements and beam voltage.   6/88 r.a.waldo
c
c
      function ftest(e0,eci,zb,lb,line)
      logical ftest
      character*3 line
      ftest=.false.
      xb=edge(int(zb),line)
      if (e0.le.xb) return
      if ((eci.lt.xray(zb,lb)).and.(2.*eci.gt.xray(zb,lb))) ftest=.true.
      return
      end
