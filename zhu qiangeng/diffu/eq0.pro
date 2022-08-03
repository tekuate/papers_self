; simplifie;d transient forcing, but two mixed layers

;run .r con first

; cd*rho*D*dTs/dt = -K*(Ts-T0)+F-(lamda0-lamdac)*Ts
; cd*rho*H*dT0/dt = +K*(Ts-T0)
;; if((it mod 100) eq 1)then T2 = Smooth(T2,3)
; simplified; transient forcing, but two mixed layers
; cd*rho*D*dTs/dt = -K*(Ts-T0)+F-(lamda0-lamdac)*Ts
; cd*rho*H*dT0/dt = +K*(Ts-T0)


isave=1
;------------

nt = 12*150
deltat = 1./12. ;month
t = indgen(nt)*deltat

form=1
KK=kk0

FOR IKK = 0,1 DO BEGIN
 KK = KK0*10.^(-IKK)  ;1,0.1
 print,kk
FOR  FORM=0,4 DO BEGIN
;------------ forcing form
F = forcing(t,form=form,slope=4,tmax=max(t),tramp=50,yearc=20,tauf=30)

Ts = t*0 ;mixed layer temp
T0 = t*0 ;deep ocean temp at z=0
Tse = t*0 ;equalibrium temp

ncase = 21
t2s = fltarr(nt,ncase)
t20 = t2s
t2se = t2s

fluxa=t2s & fluxo = t2s & fluxf =t2s

lamda2c = indgen(ncase)*0.15-1.5 ;cloud feedback -1.5,1.5
;lamda2c = indgen(ncase)*0.2-2. ;cloud feedback 

lamda0 = 2.5 ;W/m2/K

FOR IC = 0,NCASE-1 DO BEGIN

lamdac = lamda2c[ic]

;===============
for i=1,nt-1 do begin
 Ts_tend = -KK*(Ts[i-1]-T0[i-1])+(F[i]+F[i-1])/2.-(lamda0-lamdac)*Ts[i-1]
 Ts[i] = Ts[i-1]+deltaTs/Cd* Ts_tend
 T0_tend = KK*(Ts[i-1]-T0[i-1])
 T0[i] = T0[i-1]+deltaTs/CH * T0_tend

 Tse = F/(lamda0-lamdac)

endfor

 T2S[*,IC]=TS
 T20[*,IC]=T0
 T2SE[*,IC]=TSE

 fluxo[*,ic] = -kk*(Ts-T0)
 fluxa[*,ic] = -(lamda0-lamdac)*Ts
 fluxf[*,ic ]= f


ENDFOR  ;cloud feedback
tend = fluxf+fluxa+fluxo

case form of
0: title='Cess' 
1: title='linear'
2: title='ramp'
3: title='triangle'
4: title='plateau'
else:
endcase

titlef='T response from '+title+' forcing. eq:solid kk='+strdigit(kk,4)

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
 
if(isave)then  saveimage,'gif/T_kk_'+strdigit(kk,3)+'_'+title+'.gif'

titlef='fluxes from '+title+' forcing. o:solid; atm:dash kk='+strdigit(kk,4)
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
 
 if(isave)then saveimage,'gif/flux_kk_'+strdigit(kk,3)+'_'+title+'.gif'

 titled='gif/d_'+strdigit(kk,3)+'_form_'+strtrim(form,2)+'.dat'
 print,titled

 if(isave) then save,filename=titled,$
         kk,form,lamda2c,t,t2s,t20,t2se,fluxa,fluxo,fluxf,tend

ENDFOR ;form
ENDFOR ;IKK

end
