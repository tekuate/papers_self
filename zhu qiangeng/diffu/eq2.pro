; diffusion numerical model, extend from two box model eq0.pro  

;run .r con first
; with u<>0 as a comparison

; cd*rho*D*dTs/dt = -K*(Ts-T0)+F-(lamda0-lamdac)*Ts
; dT/dt+u(x)*dT/dx = k*d^2T/dx^2
; K*(Ts-T0) = cp*rho*k*dT/dz


isave=1
;------------

form=1
KK=kk0

FOR IKK = 0,1 DO BEGIN
 KK = KK0*10.^(-IKK)  ;1,0.1
 print,kk
FOR  FORM=0,4 DO BEGIN
;FOR  FORM=1,2 DO BEGIN
case form of
0: title='Cess' 
1: title='linear'
2: title='ramp'
3: title='triangle'
4: title='plateau'
else:
endcase
;------------ forcing form
F = forcing(t,form=form,slope=4,tmax=max(t),tramp=50,yearc=20,tauf=30)

Ts = t*0 ;mixed layer temp
T0 = t*0 ;deep ocean temp at z=0
Tse = t*0 ;equalibrium temp

ncase = 21
;ncase = 3
t2s = fltarr(nt,ncase)
t20 = t2s
t2se = t2s

fluxa=t2s & fluxo = t2s & fluxf =t2s

lamda2c = indgen(ncase)*0.15-1.5 ;cloud feedback -1.5,1.5
;lamda2c = indgen(ncase)*0.2-2. ;cloud feedback 

lamda0 = 2.5 ;W/m2/K

FOR IC = 0,NCASE-1,10 DO BEGIN

lamdac = lamda2c[ic]

;===============
tt0 = fltarr(nz)
tt1 = tt0

 c1 = cp*rho*k/deltaz

for i=1,nt-1 do begin
 Ts_tend = -KK*(Ts[i-1]-T0[i-1])+(F[i]+F[i-1])/2.-(lamda0-lamdac)*Ts[i-1]
 Ts[i] = Ts[i-1]+deltaT*86400.*30/Cd* Ts_tend

; period = 50.
; Ts[i] =  1.0* cos(t[i]*3.1416*2/Period)

 tb0 = (c1*TT0[1]+kk*ts[i])/(c1+kk)
 
; test
;-----------
 ; initial and boundary condition
; period = 50.
; TB0 =  1.0* cos(t[i]*3.1416*2/Period)
;-----------
 
 TT1 = TT0 - Cc1*(shift(TT0,-1)-shift(TT0,1))/2.$
            +Cc2*(shift(TT0,-1)+shift(TT0,1) - 2*TT0)
 TT1[0]  = TB0
 TT1[NZ-1] = 0

 T0[i] = tb0

 tt0 = tt1
;----------------------------------------;obtain TT1[z] and T0[i]

 ;here is the two box model 
 ;T0_tend = KK*(Ts[i-1]-T0[i-1])
 ;T0[i] = T0[i-1]+deltaT*86400*30/CH * T0_tend

 Tse = F/(lamda0-lamdac)


titlef='uTz deep '+title+' kk='+strdigit(kk,4)+' k='+strtrim(k,2)+' lmdc='+strdigit(lamdac,1)
if((i mod 120) eq 1)then begin
 if(i eq 1)then  begin
    plot,z/1000.,tt1 ,xrange=[0,2] ,yrange=[-1.,1],xtitle='depth',ytitle='T',title=titlef
 endif else begin
    oplot,z/1000,tt1,color=colors.red
 endelse
endif

endfor ; i

if(isave)then  saveimage,'gif/uTz_deep_kk_'+strdigit(kk,3)+title+'_k='+strtrim(k,2)+'_lmdc='+strdigit(lamdac,1)+'.gif'

;------------------------------
;stop
if(not isave)then read,ix
;stop
 T2S[*,IC]=TS
 T20[*,IC]=T0
 T2SE[*,IC]=TSE

 fluxo[*,ic] = -kk*(Ts-T0)
 fluxa[*,ic] = -(lamda0-lamdac)*Ts
 fluxf[*,ic ]= f


ENDFOR  ;cloud feedback
tend = fluxf+fluxa+fluxo


titlef='uT response from '+title+' forcing. eq:solid kk='+strdigit(kk,4)

;window,/free

for ic=ncase-1,0,-ncase/2 do begin

 if(ic eq ncase-1)then begin 
      plot,t,t2se[*,ic],title=titlef,xtitle='Year',ytitle='T response'
      oplot,t,t2s[*,ic],linest=2
 endif 
 if(ic eq 0)then begin 
      oplot,t,t2se[*,ic],color=colors.red
      oplot,t,t2s[*,ic],color=colors.red,linest=2
 endif 
 if(ic eq ncase/2)then begin 
      oplot,t,t2se[*,ic],color=colors.blue
      oplot,t,t2s[*,ic],color=colors.blue,linest=2
 endif 
endfor 

 ix=0
 if(not isave)then read,ix
 
if(isave)then  saveimage,'gif/uT_deep_kk_'+strdigit(kk,3)+'_'+title+'.gif'

titlef='ufluxes from '+title+' forcing. o:solid; atm:dash kk='+strdigit(kk,4)
for ic=ncase-1,0,-ncase/2 do begin

 if(ic eq ncase-1)then begin 


      plot,t,fluxf[*,ic],title=titlef,xtitle='Year',ytitle='flux',$
         yrange=[-2.,4]
      oplot,t,t*0
      oplot,t,fluxf[*,ic],color=colors.green
      oplot,t,fluxa[*,ic],linest=2
      oplot,t,fluxo[*,ic]
      oplot,t,tend[*,ic],linest=3,thick=2
 endif 
 if(ic eq 0)then begin 
      oplot,t,fluxa[*,ic],linest=2,color=colors.red
      oplot,t,tend[*,ic],linest=3,thick=2,color=colors.red
      oplot,t,fluxo[*,ic],color=colors.red
 endif 
 if(ic eq ncase/2)then begin 
      oplot,t,fluxa[*,ic],linest=2,color=colors.blue
      oplot,t,fluxo[*,ic],thick=2,color=colors.blue
      oplot,t,tend[*,ic],linest=3,thick=2,color=colors.blue
 endif 
endfor 

 ix=0
 if(not isave)then read,ix
 
 if(isave)then saveimage,'gif/ufluxdeep_kk_'+strdigit(kk,3)+'_'+title+'.gif'

 titled='gif/uddeep_'+strdigit(kk,3)+'_form_'+strtrim(form,2)+'.dat'
 print,titled

 if(isave) then save,filename=titled,$
         kk,form,lamda2c,t,t2s,t20,t2se,fluxa,fluxo,fluxf,tend

ENDFOR ;form
ENDFOR ;IKK

end
