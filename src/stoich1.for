c-------------------------------STOICH1--------------------------------
c
c      calculates weight and atomic fractions of all
c      elements given their valences and that one element
c      is analyzed by stoichiometry
c      3/88 by r.a.waldo
c
       subroutine stoich1(ifix,nel,st,val,c1,c3,ax)
       real c1(15),c3(15),ax(15),atpc(15)
       integer nel(7),st(7),val(15)
       logical ifix(7)
       i1=1
       i2=nel(1)
         do 200 j=1,7
           if (ifix(j)) goto 199
           if (st(j).eq.0) goto 125
           stc=0.
           do 120 i=i1,i2
             if(st(j).eq.i) goto 120
             atpc(i)=c1(i)/ax(i)
             stc=stc+atpc(i)*val(i)/val(st(j))
120        continue
            atpc(st(j))=stc
125         tsum=0.
            do 150 i=i1,i2
              if(st(j).ne.0) c1(i)=atpc(i)*ax(i)
              tsum=tsum+c1(i)
150         continue
            if (st(j).ne.0) c3(st(j))=c1(st(j))
            do 170 i=i1,i2
              c1(i)=c1(i)/tsum
170         continue
199      i1=i1+nel(j)
         i2=i2+nel(j+1)
200      continue
         return
          end
