

*Juan Pablo Baquero Vargas  17/04/2017

// poner missings 
// ano por año pilas!


* historia de desempleo para el caso en que la base esta 

clear
import excel "C:\Users\Juan Pablo\Documents\unemployment duration\historiaficticiatraslapada.xlsx", sheet("Sheet1") firstrow
set more off

// se genera un string de comienzo del estado 
egen inicio=concat(año1 mes1),punct("/")

// se genera un string de final del estado  
egen Final=concat(año2 mes2),punct("/")

// pasamos a fechas para poder operarlo 
gen iniciofecha=date(inicio, "YM")
gen finalfecha=date(Final, "YM")
// Duracion del periodo 
gen diff=finalfecha-iniciofecha
format iniciofecha %12.0g

// Ahora haremos una resta diff=inicio periodo - final periodo anterior
// con el fin de ver si hay traslape 
gen diff2=0
local N=_N
forvalues i = 2/`N' {
replace diff2=iniciofecha[`i']-finalfecha[`i'-1] in `i'
display(`i')
display(finalfecha[`i'-1])
}

// este contador lo generamos porque la diferencia hayada en el punto anterior
// sera negativa para la primera observacion de cada individuo dado que compara entre individuos
// lo cual es un dato que no tiene sentido en el analisis 

bysort ID: gen counter=_n

// fechastraslapadas nos dira las variables traslapadas

gen fechastraslapadas=0
replace fechastraslapadas=1 if diff2<=0 & counter!=1

// el metodo de solucion propuesto es aumentar el periodo  traslapado hasta que pierda el " traslape " 
// al periodo traslapado se le suma lo que le falta para no estar traslapado 
replace iniciofecha=iniciofecha-diff2*fechastraslapadas+31*fechastraslapadas

 tempvar AñosI MesesI 
gen `AñosI'=year(iniciofecha)
gen `MesesI'=month(iniciofecha)

// InicioI va a ser el periodo de inicio modificado 
egen inicioI=concat(`AñosI' `MesesI'),punct("/")

// nos quedamos con la fecha de inicio modificada 
drop inicio
rename inicioI inicio 








*** teniendo la base sin errores podemos pasar a llenarla **** 

local meses 1 2 3 4 5 6 7 8 9 10 11 12 
local años 2009 2010 2011 2012 
foreach año of local años {
 foreach mes of  local meses {
gen año`año'mes`mes'=0

}
}

foreach año of local años {

 foreach mes of  local meses {
 replace año`año'mes`mes'=1    if  (inicio=="`año'/`mes'")& (Estado=="O")
 replace año`año'mes`mes'=2    if  (inicio=="`año'/`mes'")& (Estado=="D")
 replace año`año'mes`mes'=3    if  (inicio=="`año'/`mes'")& (Estado=="I")
 }
 }
 
 foreach año of local años {
 foreach mes of  local meses {
 replace año`año'mes`mes'=1    if  (Final=="`año'/`mes'")& (Estado=="O")
 replace año`año'mes`mes'=2    if  (Final=="`año'/`mes'")& (Estado=="D")
 replace año`año'mes`mes'=3    if  (Final=="`año'/`mes'")& (Estado=="I")
 }
 }
 
 collapse (sum) año2009* año2010* año2011* año2012* , by(ID)
 
 // llenamos los valores de 2009 
 
 foreach mes of  local meses {
 local ames=`mes'-1
 
 if `mes'==1  { 
 continue
 } 
 replace año2009mes`mes'=1  if (año2009mes`mes'==0)&(año2009mes`ames'==1)
 replace año2009mes`mes'=2  if (año2009mes`mes'==0)&(año2009mes`ames'==2)
 replace año2009mes`mes'=3  if (año2009mes`mes'==0)&(año2009mes`ames'==3)
 }
 
 
 
 
// llenando los ultimos años 

local AÑO 2010 2011 2012 
 
foreach años of local AÑO {

local AÑOantes=`años'-1
 
 replace año`años'mes1=1  if (año`años'mes1==0)&(año`AÑOantes'mes12==1)
 replace año`años'mes1=2  if (año`años'mes1==0)&(año`AÑOantes'mes12==2)
 replace año`años'mes1=3  if (año`años'mes1==0)&(año`AÑOantes'mes12==3)
 
 foreach mes of  local meses {
 local ames=`mes'-1
 
 if `mes'==1  { 
 continue
 } 
 replace año`años'mes`mes'=1  if (año`años'mes`mes'==0)&(año`años'mes`ames'==1)
 replace año`años'mes`mes'=2  if (año`años'mes`mes'==0)&(año`años'mes`ames'==2)
 replace año`años'mes`mes'=3  if (año`años'mes`mes'==0)&(año`años'mes`ames'==3)
 
 }
 }
 
 
 
 
// long format 

reshape long año   ,i(ID ) j(s ) string 
rename año Estado

gen año   = regexs(0) if regexm(s, "^[0-9]+")
gen mes = regexs(0) if regexm(s, "[0-9]+$")

destring año mes ,replace
sort ID año mes 

gen date=ym(año, mes)
 xtset ID date
