; to solve diffusion-advection equation analytically
; fixed end boundary conditions, starting from an inital condition
; dT/dt+u(x)*dT/dx = k*d^2T/dx^2

 deltaX = 1000./100 ;m
 Xmax = 200*1000.
 NX = Xmax/deltaX+1
 x = indgen(NX)*deltax

 deltaT = 60./2/5.    ;s
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

 T0 = T00
 T0[0] = TB0t[0]
 T0[NX-1] = TBNt[0]

 T1=T0

 plot,x,T1,yrange=[-1.5,1.5]
 oplot,x,x*0

 dT0dt = tm*0
 dT0dt[0] = (TB0t[1]-TB0t[0])/deltaT   
 for it=1,NT-2 do dT0dt[it] = (TB0t[it+1]-TB0t[it-1])/deltaT/2. 
 dT0dt[NT-1] = (TB0t[NT-1]-TB0t[NT-2])/deltaT   

 ntf=fix(2*3600/deltat)
 FOR IT = 2,NT-1,NTF DO BEGIN
 ; FOR IT = 2,2 DO BEGIN
  jj = where( tm lt tm[it],cnt)
  tmp = tm(jj)
 for ix=1,nx-2 do begin
  xtp = x[ix]-u[ix]*(tm[it]-tmp)

  jjx=where(xtp le 0.0,cntx)
  if(cntx gt 0)then xtp[jjx] = 0.0

  yt = xtp/sqrt(4*K[ix]*(tm[it]-tmp))
  sum = total(errorfc(yt)*dT0dt[0:cnt-1])*deltat
  ;T1[ix] = TB0t[0]*errorfc(x[ix]/sqrt(4*K[ix]*tm[it]) ) + sum

  xtp0 = x[ix] - u[ix]*tm[it]
  xtp0 = xtp0 > 0

  T1[ix] = TB0t[0]*errorfc(xtp0/sqrt(4*K[ix]*tm[it]) ) + sum
 endfor
; stop

  ix=1
  time = tm[it]/3600
  print,'go (tm=)?',it,time
;  print,'t0',t0[0:10]
;  print,'t1',t1[0:10]
;  print,'t2',t2[0:10]
;;  read,ix
  oplot,x,t1,color=colors.red

 ENDFOR ; --------------- time loop end


end
