c---------------------------------ZNL----------------------------------
c  Number of electrons in the ionized shell.
c
c 3/91 r.a. waldo
      function znl(nshell)
      goto (1,1,1,2,1,1,2,2,3,1,1,2)nshell
1     znl=2.
      return
2     znl=4.
      return
3     znl=6.
      return
      end
