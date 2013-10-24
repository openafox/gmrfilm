c
c     this program calculates the complementary error function
c     for the value x using horner's approximation method
c
c     program completed march, 5 1987 by richard a. waldo
c
      function erfc(x)
      if (x.gt.sqrt(88.)) then
        erfc=0.
        return
      else if (x.eq.0.) then
        erfc=1.
        return
      endif
      p=.3275911
      t=1./(1.+p*x)
      a1=.254829592
      a2=-.284496736
      a3=1.421413741
      a4=-1.453152027
      a5=1.061405429
      erfc=(a1*t+a2*t*t+a3*t*t*t+a4*t*t*t*t+a5*t*t*t*t*t)
     &     *exp(-x*x)
      return
      end
