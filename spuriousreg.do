prog drop _all
program spuriousreg, rclass
 args obs 
 drop _all
 qui set obs `obs'
 mata : mydgp(`obs')
    
 quietly regress y_I0  x_I0
 matrix mym=r(table)
 scalar t_I0=mym[3,1]
     
 quietly regress y_I1  x_I1
 matrix mym=r(table)
 scalar t_I1=mym[3,1]
    
 quietly regress y_I2  x_I2
 matrix mym=r(table)
 scalar t_I2=mym[3,1]
    
   return scalar t_I0=t_I0
   return scalar t_I1=t_I1
   return scalar t_I2=t_I2
    
   drop y_I0 y_I1 y_I2 x_I0 x_I1 x_I2
   
   end



