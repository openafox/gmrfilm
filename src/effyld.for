c------------------------------EFFYLD--------------------------------
c EFFective Fluorescence YieLD for all lines.
c 3/91 r.a. waldo
c
      function effyld(z1,jedge,xenergy,exciter)
      real l1,l2,l3,jr1,jr2,jr3
      character*9 exciter
      nz1=int(z1)
      goto (1,2,2,2,1,1,1,1,1,3,3,3)jedge
1     effyld=omega(z1,jedge)
      return
2     jr1=rjump(z1,2)
      jr2=rjump(z1,3)
      jr3=rjump(z1,4)
      l1=edge(nz1,'Lb3')
      l2=edge(nz1,'Lb1')
      l3=edge(nz1,'La1')
      if (jedge.eq.2) then
        effyld=omega(z1,2)
      else if (jedge.eq.3) then
        if ((xenergy.lt.l1).and.(xenergy.gt.l2)) then
          effyld=omega(z1,3)
        else if (xenergy.gt.l1) then
          if (exciter(1:1).eq.'e') then
            effyld=omega(z1,3)*(1.+ck(12,z1))
          else
            effyld=omega(z1,3)*(1.+ck(12,z1)*(jr1-1.)*jr2/(jr2-1.))
          endif
        endif
      else if (jedge.eq.4) then
        if ((xenergy.lt.l2).and.(xenergy.gt.l3)) then
          effyld=omega(z1,4)
        else if ((xenergy.lt.l1).and.(xenergy.gt.l2)) then
          effyld=omega(z1,4)*(1.+ck(23,z1)*(jr2-1.)*jr3/(jr3-1.))
        else if (xenergy.gt.l1) then
          if (exciter(1:1).eq.'e') then
            effyld=omega(z1,4)*
     &             (1.+.5*ck(13,z1)+.5*(1.+ck(12,z1))*ck(23,z1))
          else
            effyld=omega(z1,4)*(1.+ck(13,z1)*(jr1-1.)*jr2*jr3/(jr3-1.)
     &                          +ck(23,z1)*(jr2-1.)*jr3/(jr3-1.)
     &                          +ck(12,z1)*(jr1-1.)*jr2*jr3/(jr3-1.))
          endif
        endif
      endif
      return
3     effyld=0.
      return
      end
