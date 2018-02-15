
mata: 

void function mydgp(n)
{

x=rnormal(1,n,0,1)

// the dependent variable 
// first i create the I(0) process
y_I0=x[1::n]
// now i create the I(1) process with a for loop 
y_I1=J(1,n,0)
y_I1[1]=x[1] 
for (i=2; i<=n; i++) {
 y_I1[i]=y_I1[i-1]+x[i] 
 }

//the same for the I(2) process
y_I2=J(1,n,0)
y_I2[1::2]=x[1::2] 
for (i=3; i<=n; i++) {
 y_I2[i]=2*y_I2[i-1]+x[i]-y_I2[i-2] 
 }
 
 
 
 
 // the independent  variable 
// first i create the I(0) process
x=rnormal(1,n,0,1)
x_I0=x[1::n]
// now i create the I(1) process with a for loop 
x_I1=J(1,n,0)
x_I1[1]=x[1] ;
for (i=2; i<=n; i++) {
 x_I1[i]=x_I1[i-1]+x[i] 
 }

//the same for the I(2) process
x_I2=J(1,n,0)
x_I2[1::2]=x[1::2] ;
for (i=3; i<=n; i++) {
 x_I2[i]=2*x_I2[i-1]+x[i]-x_I2[i-2] 
 }
 
 
 // finally we export the variables to stata 
 


  idx=st_addvar("float",("y_I0","y_I1","y_I2","x_I0","x_I1","x_I2"))

  st_store(.,idx,(y_I0',y_I1',y_I2',x_I0',x_I1',x_I2'))
  

}

end 


 
 
 
 


