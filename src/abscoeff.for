c-------------------------------ABSCOEFF---------------------------------
c
c     This program controls the calculation (via subroutines mu and mac)
c     of mass absorption coefficients.  The option is present for operator
c     input of the mac's.  Used for layer and substrate elements in a
c     thin film system.
c author r.a. waldo 4/87
c changed to Heinrich's ICXOM-11
c Mass Absorption Coefficient Equations 10/88
c
      subroutine abscoeff(nel,nels,mac,symb,zx,ax,line,macchange,m)
      real mac(15,15),zx(15),ax(15)
      integer line (15),nel(7)
      character*7 symb(15),tempabs1*12,macchange*1,m*1
2     format ('+Mass absorption coefficients (def=no change)  :')
5     format ('+Mass absorption coefficients for ',a6,i1,' elements (def
     &=no change)  :')
10    format ('+Mass absorption coefficients for ',a9,' elements (def=no
     & change):')
      print 9007
      do 200 i1=1,nels
        call layrelem(nea,nel,la,i1)
        if (macchange.ne.'Y') goto 30
        if (m.eq.'B') then
          print 2
        else
          do 20 kk=1,6
            if ((la.eq.kk).and.(nea.eq.1)) then
              print 5,'layer ',kk
              print 9007
            endif
20        continue
          if ((la.eq.7).and.(nea.eq.1)) then
            print 10,'substrate'
            print 9007
          endif
        endif
30      do 150 i2=1,nels
          lb=layr(nel,i2)
          if (la.lt.lb) goto 150
          call mu(xmu,zx(i1),zx(i2),line(i1),ax(i2))
          if ((m.eq.'B').and.(i1.eq.i2)) goto 140
          if (macchange.ne.'Y') goto 140
          if (m.eq.'B') then
            print 9006,symb(i1)(1:5),symb(i2)(1:2),xmu
          else if ((la.ne.7).and.(lb.ne.7)) then
            print 9003,la,symb(i1)(1:5),lb,symb(i2)(1:2),xmu
          else if ((la.eq.7).and.(lb.ne.7)) then
            print 9004,symb(i1)(1:5),lb,symb(i2)(1:2),xmu
          else if ((la.eq.7).and.(lb.eq.7)) then
            print 9005,symb(i1)(1:5),symb(i2)(1:2),xmu
          endif
        read 9001,tempabs1
        if (tempabs1  .eq.' ') then
          goto 140
        else
          do 40 i=1,12
            if (tempabs1(i:i).eq.'.') goto 50
            if (tempabs1(i:i).eq.' ') then
              tempabs1(i:i)='.'
              goto 50
            endif
40        continue
50        read(tempabs1,fmt='(f10.2)')xmu
          print 9002,xmu
          print*,' '
        endif
140    mac(i1,i2)=xmu
150    continue
200    continue
      return
9001  format (a12)
9002  format('+Changed to :',f10.2)
9003  format('+MAC for layer ',i1,'  '
     &,1x,a5,' in layer ',i1,'  ',1x,a2,' is : ',f9.2,
     &'  Change to? : ')
9004  format('+MAC for substrate'
     &,1x,a5,' in layer ',i1,'  ',1x,a2,' is : ',f9.2,
     &'  Change to? : ')
9005     format('+MAC for substrate'
     &,1x,a5,' in substrate',1x,a2,' is : ',f9.2,
     &'  Change to? : ')
9006     format('+MAC for ',1x,a5,' in',1x,a2,' is : ',f9.2,
     &'  Change to? : ')
9007  format(' ')
      end
