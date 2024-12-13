model tiny
stak 100k
data
  mes db "Hello world"
code
  main proc
    * 
  mov AH,4ch
    int 21h
   