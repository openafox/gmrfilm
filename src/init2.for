c      
c     initialize variables 5/93 r.a. waldo
c
      subroutine init2(iter,solution,fcont,fchar,prim)
      logical solution
      real fcont(15),fchar(15),prim(15)
      iter=0
      solution=.false.
      do 4 i=1,15
        fcont(i)=0.
        fchar(i)=0.
        prim(i)=0.
4     continue
      return
      end
