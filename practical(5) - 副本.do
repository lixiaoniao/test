clear all

*y=a+b*x+u
*u~N(0,1)

*Define parameter values
scalar N=1000
scalar a=0.1
scalar b=1
scalar S=1000

*The correlation between u and x
scalar r1=0.8
*The correlation between z and x
scalar r2=0.05
*The correlation between u and z
scalar r3=0.1
*Adjust the values of r1¡¢r2¡¢r3 according to the requirements of the topic to complete all the simulation process

scalar c1 = (r2-r1*r3)/(1-r1^2)
scalar c2 = (r3-r1*r2)/(1-r1^2)

*Define program to generate 1 dataset and compute the estimators

program onesample, rclass
	drop _all
	quietly set obs `=N'
	gen u=rnormal(0,1)
	gen x=r1*u+rnormal(1,1)
	gen z=c1*x+c2*u+rnormal(0,1)
	gen y=`=b'*x + u
	reg y x
	return scalar bols=_b[x]
	ivregress 2sls y (x=z)
	return scalar b2sls=_b[x]
end

*Run once
onesample
return list

*Simulate S times
simulate bols=r(bols) b2sls=r(b2sls), seed(999) reps(`=S'): onesample

sum

histogram bols, normal
graph save g1, replace

histogram b2sls, normal
graph save g2, replace

graph combine g1.gph g2.gph

