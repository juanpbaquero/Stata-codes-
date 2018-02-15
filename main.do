clear all
loc srep 1000   // number of reps
global dir "C:\Users\Juan Pablo\Dropbox\codigos"

cd "$dir"


quiet do mydgp.do
quiet do spuriousreg.do 

// loop through sample sizes
foreach j in 50 100 200 500 { 

simulate t_I0=r(t_I0) t_I1=r(t_I1) t_I2=r(t_I2) , seed(10101) reps(`srep') nodots : spuriousreg `j'

// here we count if the t-value is in the reject zone 
gen countI0=0 
replace countI0=1 if t_I0>2 | t_I0<-2
gen countI1=0 
replace countI1=1 if t_I1>2 | t_I1<-2
gen countI2=0 
replace countI2=1 if t_I2>2 | t_I2<-2


// here we obtain the mean across reps to obtain the size of the test
matrix store_`j'=J(3,1,0)
summarize countI0,meanonly
matrix store_`j'[1,1]=r(mean)
summarize countI1,meanonly
matrix store_`j'[2,1]=r(mean)
summarize countI2,meanonly
matrix store_`j'[3,1]=r(mean)
matrix rownames store_`j' = "I(0) I(0) "  " I(1) I(1) " " I(2) I(2) " 
matrix colnames store_`j' = " P(|t |> 2) "

drop _all
}
 

 // finally making the tables
 foreach j in 50 100 200 500 {
 
esttab matrix(store_`j') ,replace addnotes("`srep' reps") label nonumber title("Sporious regression test, sample=`j' ") mtitle("") 

}

