c      
c     initialize variables 5/93 r.a. waldo
c
      subroutine init5(mode,c1,c2,c3,c4,sc)
      real c1(15),c2(15),c3(15),c4(15),sc(7)
      character*1 mode 
       do 100 i=1,15
         c2(i)=c1(i)
         c3(i)=c1(i)
         c4(i)=c1(i)
100    continue
       if (mode.eq.'F') then
         do 200 i=1,7
           sc(i)=1.
200      continue       
       endif        
       return
       end

