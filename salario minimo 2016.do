
* Descriptivas salario minimo 

* 2016 : 689.445 $    SMLV modal : [ 654972.75   723917.25]
* 2016 : 644.350 $    SMLV modal : [ 612132.50   676567.50]
* 2016 : 616.027  &    SMLV modal : [ 585200.00   646800.00]

cd "C:\Users\Juan Pablo\Documents\GEIH 2016"

  use car2016 , clear

bys llavepersona: gen contador=_n
drop if contador!=1 

save car2016, replace  
 
use ocup2016 , clear

bys llavepersona: gen contador=_n
drop if contador!=1 

save ocup2016, replace  
 
 
use car2016 , clear
 
merge 1:1 llavepersona using ocup2016

keep if _merge==3    // solo las areas 


replace fex_c_2011=fex_c_2011/12


//  p6500 salario 

/* 9	Otro,
8	Jornalero o peón
7	Trabajador sin remuneración en empresas o negocios de otros hogares
6	Trabajador familiar sin remuneración
5	Patrón o empleador
4	Trabajador por cuenta propia
3	Empleado doméstico
2	Obrero o empleado del gobierno
1	Obrero o empleado de empresa particular  */



set more off


tab p6500




gen salariado=1   if  p6430==1 |  p6430==2 | p6430==8



gen possalario=""

replace possalario="Menos de 1 SMLV"  if p6800>=40&(p6500 <  689445)
replace possalario="Entre 1-2 SMLV"  if p6800>=40&(p6500 >= 689445   &  p6500 <= 689445*2)
replace possalario="Mas de 2 SMLV"  if p6800>=40&(p6500 > 2*689445   &  p6500!=.) 

gen incidenciamodal=.

replace incidenciamodal=0  if possalario!=""
replace incidenciamodal=1  if p6800>=40&(p6500> 0.95*689445  & p6500 <=  1.05*689445)
 
// note que possalario suma 100 e incidencia modal es una categoria aparte. 

 



// aca simplemente se organiza de menor a mayor salario para la tabulacion 

label define order1  1 "Menos de 1 SMLV"  2 "Entre 1-2 SMLV"  3 "Mas de 2 SMLV" 

encode possalario, gen(posicionsalario) label(order1)




gen sectores="" 

replace  sectores="Agropecuario"  if  rama2d==1 | rama2d==2 

replace  sectores="Pesca"  if  rama2d==5 
 
replace  sectores="Explotación Minas y Canteras"  if  rama2d>=10   & rama2d<=14 

replace  sectores="Industria manufacturera"  if  rama2d>=15   & rama2d<=37 

replace  sectores="Suministro de electricidad,gas y agua"  if  rama2d==40 | rama2d==41 
 
replace  sectores="Construcción"  if  rama2d==45

replace  sectores="Comercio al por mayor y al por menor "  if  rama2d>=50   & rama2d<=52 

replace  sectores="Hoteles y restaurantes"  if  rama2d==55  

replace  sectores="Transporte "  if  rama2d>=60   & rama2d<=64

replace  sectores="Intermediación financiera "  if  rama2d>=65   & rama2d<=67

replace  sectores="Actividades inmobiliarias"  if  rama2d>=70   & rama2d<=74 
 
replace  sectores="Administración pública y defensa"  if  rama2d==75  

replace  sectores="Enseñanza"  if  rama2d==80 

replace  sectores="Servicios socialesy de salud"  if  rama2d==85

replace  sectores="Otras actividades de servicios comunitarios"  if  rama2d>=90   & rama2d<=93 

replace  sectores="Actividades de hogares como empleadores o productores"  if  rama2d>=95   & rama2d<=97 

replace  sectores="Organizaciones y órganos extraterritoriales"  if  rama2d==99



 
 * TOTAL 
 
tab posicionsalario  if salariado==1 [w=int(fex_c_2011)] 


tab incidenciamodal if salariado==1 [w=int(fex_c_2011)] 



* HOMBRE 

tab posicionsalario  if (salariado==1 & p6020==1)  [w=int(fex_c_2011)] 


tab incidenciamodal if (salariado==1 & p6020==1) [w=int(fex_c_2011)] 


* MUJER 

tab posicionsalario  if (salariado==1 & p6020==2)  [w=int(fex_c_2011)] 


tab incidenciamodal if (salariado==1 & p6020==2) [w=int(fex_c_2011)] 




* EDUCACION


gen educacion= "Ninguno" if p6220==1 
replace educ= "Bachiller" if p6220==2 
replace educ= "Tecnico Tecnologico" if p6220==3 
replace educ= "Universitario" if p6220==4 
replace educ= "Posgrado" if p6220==5 
 

 
label define order  1 "Ninguno"   2 "Bachiller"  3 "Tecnico Tecnologico"  4 "Universitario" 5 "Posgrado"

encode educacion, gen(educorder) label(order) 
 
 

 //SECTOR
 
 
 tab sectores possalario [w=int(fex_c_2011)]   , nofreq row

tab sectores incidenciamodal [w=int(fex_c_2011)]   , nofreq row
 
 
 // dpto 
 
 tab dpto possalario [w=int(fex_c_2011)]   , nofreq col
 
  tab dpto incidenciamodal [w=int(fex_c_2011)]   , nofreq col
 
 
tab  posicionsalario educorder if salariado==1  [w=int(fex_c_2011)] ,nofreq col

tab  incidenciamodal educorder if salariado==1  [w=int(fex_c_2011)] ,nofreq col
 
 

 
 table  sector  dpto [w=int(fex_c_2011)] , by(p6020)   contents( mean p6500) 
  
 
 
 
 
 
 
 