
 delta = 0.02/10
 sig = (indgen(4001)+1)*delta

jj=3
;plot,sig*0,sig,xrange=[-6.,6],yrange=[0.,6],xtitle='k',ytitle='sigma',title='j='+strtrim(jj,2)

 for m=1,5 do begin

  ;for j=-1,10 do begin
;  for j=0,10 do begin
j=jj
   
    kk1 = sig*0.0-100.
    kk2 = sig*0.0-100.

    temp1 = (1.0/sig - 2.*m*sig)^2 - 8.*m*j

    jk1 = where(temp1 ge 0,cnt1)
    if(cnt1 gt 0)then begin
       kk1[jk1] = -0.5/sig + 0.5*sqrt(temp1[jk1])
       kk2[jk1] = -0.5/sig - 0.5*sqrt(temp1[jk1])
    endif
    print,'m,j',m,j
;    oplot,kk1,sig,color=colors.red ;red
;    oplot,kk2,sig,color=colors.green ;green
;    oplot,kk1,sig,color=colors.red,psym=j
;    oplot,kk2,sig,color=colors.green ,psym=j

    oplot,kk1,sig,color=colors.blue,psym=3
    oplot,kk2,sig,color=colors.cyan ,psym=3

    oplot,kk1,sig,color=colors.red,psym=3
    oplot,kk2,sig,color=colors.red ,psym=3

    oplot,kk1,sig,color=colors.black,psym=3
    oplot,kk2,sig,color=colors.purple ,psym=3

    oplot,kk1,sig,color=colors.pink,psym=3
    oplot,kk2,sig,color=colors.pink ,psym=3

 stop

endfor
;endfor

end
