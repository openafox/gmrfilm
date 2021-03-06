c-------------------------------CHIOV----------------------------------
c
c     chiov finds the wt. fraction averaged mass absorption coefficient
c     of an overlayer for an element 'ne' in an underlying layer
c     4/87 r.a. waldo
c
      subroutine chiov(mac,i,nel,layer,conc,chiovl)
      real mac(15,15),conc(15),chiovl(6)
      integer nel(7)
      do 60 l=1,6
60    chiovl(l)=0.
      i1=1
        do 50 layera=1,layer-1
          i2=i1+nel(layera)-1
          if (nel(layera).eq.0) goto 50
            do 30 k=i1,i2
              chiovl(layera)=chiovl(layera)+conc(k)*mac(i,k)
30          continue
          i1=i1+nel(layera)
50      continue
100   continue
      return
      end
