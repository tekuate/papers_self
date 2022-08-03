 function errorfc,x
  return,1.0-errorf(x)
 end

 function errorftx,x,t,k
  y = x/sqrt(4.*k*t)
  f=errorf(y)
  return,f
 end

 function derrfdt,x,t,k,deltaT
  f=errorftx(x,t+deltaT,k)-errorftx(x,t-deltaT,k) 
  f=f/2./deltaT
  return,f
 end
 
 t=tm[3]
 dfdt1 = derrfdt(x,tm[3],k,deltaT)
 dfdt2 = derrfdt(x,tm[100],k,deltaT)
 dfdt3 = derrfdt(x,tm[200],k,deltaT)

 plot,x,dfdt1,yrange=[-0.01,0.01]
 oplot,x,x*0
 oplot,x,dfdt2,color=colors.red
 oplot,x,dfdt3,color=colors.blue

end
