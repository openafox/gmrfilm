c      
c     initialize variables 5/93 r.a. waldo
c
      subroutine init3(symb,stds0,stds1,stds2,nel,delta)
      character*7 symb(15)
      integer stds0(15),nel(7)
      real stds1(15,3,15),delta(7)
      character*2 stds2(15,15)
      do 6 j=1,15
        symb(i)(6:6)=' '
        stds0(j)=0
        do 6 k=1,15
6         stds2(j,k)='  '
      do 8 j=1,7
        nel(j)=0
        delta(j)=0.
8     continue        
      do 11 i=1,15  
        do 10 j=1,3
          do 9 k=1,15
            stds1(i,j,k)=0.
9         continue
10      continue
11    continue
       return
       end
