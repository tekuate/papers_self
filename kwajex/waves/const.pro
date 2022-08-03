he = 200. ;
beta = 4*3.1416/86400./6400./1000.
k = 6.*2*3.1416/(2*3.1416*6400.*1000.)
g = 9.8
cg = sqrt(g*he)
r0 = 6400.*1000.

mu = k*cg*0.5*(1.-sqrt(1.+4*beta/k^2/cg ) )
c  = mu/k

sai = (indgen(201)-100)*0.02
y   = sai/sqrt(beta/cg)  ;meter
yd  = y/r0*180./3.1416

xd = indgen(360)*1.0
x  = xd*(2.*3.1416*6400.*1000./360.) ;meter

v1 = exp(-sa

end


