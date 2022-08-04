; to solve diffusion-advection equation numerically
; fixed end boundary conditions, starting from an inital condition
; dT/dt+u(x)*dT/dx = k*d^2T/dx^2

 
 deltaX = 1000.; ;m
 Xmax = 200*1000. 
 NX = Xmax/deltaX+1
 x = indgen(NX)*deltax

 deltaT = 60./2    ;s
 Tmax = 2*86400./4.
 NT = Tmax/deltaT+1
 tm = indgen(NT)*deltat
 
 U = x*0 + 1. ;const
 K = x*0 + 1.0e4  ;m2/s

 ; initial and boundary condition
 T00 = x*0 + 0.0
 period = 86400.*2
 TB0t = tm*0 + 1.0* cos(tm*3.1416*2/Period)
 TBNt = tm*0 + 0.0

 C1 = U*deltaT/deltaX
 C2 = K*deltaT/deltaX^2

 ;CFD conditions and CR1^2 less than 2CR2
 CR1 = max(C1)
 CR2 = max(C2)
 print,'CR1,CR2:',CR1,CR2,CR1^2-2*CR2

 it=1
 T0 = T00
 T1 = T0 - C1/2*(shift(T0,-1)-shift(T0,1)) $
         + C2*(shift(T0,-1)+shift(T0,1) - 2*T0)
 T1[0]  = TB0t[it]
 T1[NX-1] = TBNt[it]
 plot,x,T1,yrange=[-1.5,1.5]
 oplot,x,x*0

 FOR IT = 2,NT-1 DO BEGIN

 T2S = T1 - C1*(shift(T1,-1)-shift(T1,1))/2. 
 T2s[0]  = TB0t[it]
 T2s[NX-1] = TBNt[it]
; T2S = Smooth(T2S,3)
 T2s[0]  = TB0t[it]
 T2s[NX-1] = TBNt[it]

 T2 = T2S + C2*(shift(T1,-1)+shift(T1,1) - 2*T1)
 T2[0]  = TB0t[it]
 T2[NX-1] = TBNt[it]

;; if((it mod 100) eq 1)then T2 = Smooth(T2,3)
 T2[0]  = TB0t[it]
 T2[NX-1] = TBNt[it]
  
 T0 = T1
 T1 = T2

  time = tm[it]/3600.

 if( (long(it*deltat) mod long(2*3600)) eq 0 )then begin
  ix=1
  print,'go (tm=)?',it,time
;  print,'t0',t0[0:10]
;  print,'t1',t1[0:10]
;  print,'t2',t2[0:10]
;;  read,ix
  oplot,x,t1,color=colors.red
 endif
 

 ENDFOR ; --------------- time loop end


end
