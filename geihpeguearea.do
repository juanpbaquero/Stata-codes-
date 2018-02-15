

** GEIH for TI ***
** In this do  i open and save caracteristicas generales and 

set more off
local meses Enero Febrero Marzo Abril Mayo Junio Julio Agosto Septiembre Octubre Noviembre Diciembre
local tipos Área



forvalues año=2015/2016 {

foreach mes of local meses {

foreach tipo of local tipos {



display("`año'`mes'`tipo'")



cd "C:\Users\Juan Pablo\Documents\GEIH `año'"

import delimited "C:\Users\Juan Pablo\Documents\GEIH `año'\\`mes'.txt\\`tipo' - Ocupados.txt", clear 


keep directorio hogar orden p6500 p6430 p6800 mes  rama2d


egen llavepersona=concat(directorio hogar orden) , punct("-")

egen llavehogar=concat(directorio hogar)

save `tipo'ocup`mes'`año' , replace




import delimited "C:\Users\Juan Pablo\Documents\GEIH `año'\\`mes'.txt\\`tipo' - Características generales (Personas).txt", clear 

keep directorio secuencia_p orden hogar p6040 p6020  fex_c_2011 dpto p6210 p6220  

egen llavepersona=concat(directorio hogar orden) , punct("-")

egen llavehogar=concat(directorio hogar)

save `tipo'car`mes'`año',replace   // cabecera caracteristicas generales



}
}
}

********************************************************************************************




** Append across months **



local meses   Febrero Marzo Abril Mayo Junio Julio Agosto Septiembre Octubre Noviembre Diciembre

local tipos car ocup


forvalues año=2015/2016 {


foreach tipo of local tipos {


cd "C:\Users\Juan Pablo\Documents\GEIH `año'"
use Área`tipo'Enero`año', clear 

foreach mes of local meses {

append using Área`tipo'`mes'`año'  


}

save  `tipo'`año' , replace 


}
}



