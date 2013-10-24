c---------------------------------ppint2-----------------------------------
c     Evaluate limits of x-ray intensity integral.
c     10/89, r.a. waldo
c
      double precision function ppint2(a,b,r,c,x)
      real*8 a,b,r
      if (c.eq.0.) then
        ppint2=x*(x*x/3.-r*x+r*r+b/a)
        return
      endif
c For some reason I don't understand, c and x must be transferred
c to dummy variables before the c*x>88 test can be made.  If this is
c not done 'ppint2' does not have double precision accuracy.
      c1=c
      x1=x
      if (c1*x1.gt.88.) then
        ppint2=0.
        return
      endif
      ppint2=exp(-c*x)*((x-r)**2+2.*(x-r)/c+2./c/c+b/a)
      return
      end
