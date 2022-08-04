Function forcing,t,form=form,tauf=tauf,slope=slope,tramp = tramp,yearc=yearc,$
   tmax=tmax
 ; form: 0 Cess; 1:linear 2:ramp 3:triangle,4: const yr
 ;tmax ramp to zero

 if(not keyword_set(form))then form=0
 if(not keyword_set(tauf))then tauf=30.*12
 if(not keyword_set(slope))then slope=4. ; 100 yr for 4W/m2
 if(not keyword_set(tmax))then tmax=max(t)  ; 100 yr for 4W/m2
; decreasing forcing
 if(not keyword_set(tramp))then tramp = tauf
 if(not keyword_set(yearc))then yearc = 0
; constant time in yr


 F=t*0
 case form of
0: begin  ;cess
 tauf = 30.  ;  30 years
 F = 0.0277*(exp (t / tauf ) - 1)*5.34 ; to yield 4 w/m2
   end

1: begin ; linear
   F = slope*t/100.     ;slope 100 years

   end

2: begin ; ramp
   F = slope*t/100.     ;slope 0.04
   jj=where(t ge tramp,cnt) 
   jmax=min(jj)-1
   F[jj] = F[jmax] 
   end

3: begin ; trangle 
   F = slope*t/100.     ;slope 
   jj=where(t ge tramp,cnt) 
  if(cnt eq 0)then goto,jump3
   jmax=min(jj)-1
   F[jj] = F[jmax]*(1-(t[jj]-t[jmax])/(max(t)-t[jmax]) )
  jump3:
   end
4: begin ; trangle 
   F = slope*t/100.     ;slope 
   jj=where(t ge tramp,cnt) 
  if(cnt eq 0)then goto,jump4
   jmax=min(jj)-1
   jj1 = where(t ge tramp+yearc,cnt1)  ;rampc=constant ramp
   jmax1=min(jj1)-1

   F[jmax:jmax1] = F[jmax]
   slope2 = f[jmax]/(tmax-t[jmax1])
   F[jj1] = F[jmax]-slope2*(t[jj1]-t[jmax1])
  jump4:
   end
else: print,'no forcing mode chosen'
endcase

return ,F
end
 

