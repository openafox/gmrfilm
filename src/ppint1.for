c--------------------------------ppint1--------------------------------------
c evaluate limits of weighting function integral for PAP model
c 10/89, r.a. waldo
c
      double precision function ppint1(x,L,R)
      real L
      ppint1=x*(x**4/5.-x**3/2.*(R+L)+x**2/3.*(R**2+4.*R*L+L**2)
     &-x*(R**2*L+L**2*R)+(R**2*L**2))
      return
      end
