log using "Log - Ejercicio Practico I.smcl", replace
import excel "Base 1.xls", sheet("base1") firstrow
save "Base 1.dta"
describe
clear
import delimited "Base 2.csv"
describe
save "Base 2.dta"
clear
use "Base 1.dta", clear
append using "Base 2.dta"
describe
merge 1:1 var1 using "Base 3.dta"
describe
save "Base de Datos Final.dta"
label variable var1 "Número de Identificación"
rename var1 idpaciente
label drop _merge
label variable var2 "Sexo del Paciente"
rename var2 sexo
label define sexo 1 "Masculino" 0 "Femenino"
label values sexo sexo
label variable var3 "Tipo de Dolor Toráxico"
rename var3 tipodolor
label define tipodolor 1 "Angina Típica" 2 "Angina Atípica" 3 "Dolor No Angina" 4 "Asintomático"
label values tipodolor tipodolor
label variable var4 "Presión Sistólica"
rename var4 psistolica
notes var4: Presión Sistólica en mmHg
label variable var5 "Concentración Plasmática de Colesterol (mg/dL)"
rename var5 colesterol
label variable psistolica "Presión Sistólica (mmHg)"
label variable var6 "Resultados Electrocardiográficos (Reposo)"
rename var6 electrocardiograma
label define electrocardiograma 0 "Normal" 1 "Anomalía Onda ST-T" 2 "Hipertrofia Ventricular"
label values electrocardiograma electrocardiograma
save "Base de Datos Final.dta", replace
label variable var7 "Fecha de Nacimiento"
rename var7 fechanacimiento
label variable var8 "Estado de la Enfermedad - Angiografía"
rename var8 enfcardiaca
label define angiografia 1 "<50% de estrechamiento" 2 ">50% de estrechamiento"
label values enfcardiaca angiografia
label variable var9 "Fecha de Angiografía"
rename var9 fechaangiografia
label define angiografia 0 "<50% de estrechamiento" 1 ">50% de estrechamiento", replace
save "Base de Datos Final.dta", replace
drop _merge
gen id= _n
codebook psistolica
save "Base de Datos Final.dta", replace
destring psistolica, generate(psistolica2) force
codebook psistolica2
 list psistolica psistolica2 psistolica2 if psistolica2==.
codebook colesterol
destring colesterol, generate(colesterol2) force
codebook colesterol2
list colesterol colesterol2 if colesterol2==.
save "Base de Datos Final.dta", replace
generate fechanacimiento2 = date(fechanacimiento, "MDY")
format %tdNN/DD/CCYY fechanacimiento2
save "Base de Datos Final.dta", replace
generate fechaangiografia2 = date(fechaangiografia, "MDY")
format %tdDD/NN/CCYY fechanacimiento2
replace fechaangiografia2 = date(fechaangiografia, "MDY")
drop fechaangiografia2
generate fechaangiografia2 = date(fechaangiografia, "MDY")
format %tdDD/NN/CCYY fechaangiografia2
save "Base de Datos Final.dta", replace
replace fechaangiografia2 = date(fechaangiografia, "DMY")
save "Base de Datos Final.dta", replace
* Categorizar la variable Presión Sistólica
egen float estadiohta = cut(psistolica2), at(90 129 139 159 179 300) icodes
codebook estadiohta
label variable fechanacimiento2 "Fecha de Nacimiento STATA"
label variable id "Número de Identificación (Base de Datos)"
label variable fechaangiografia2 "Fecha de Angiografía STATA"
label variable estadiohta "Estadío de la Presión Arterial"
drop estadiohta
egen float estadiohta = cut(psistolica2), at(0 90 130 140 160 180 300) icodes
codebook estadiohta
label variable estadiohta "Estadio de la Presión Arterial"
label define estadiohta 0 "Hipotensión" 1 "Normal" 2 "Prehipertensión" 3 "Hipertensión E-I" 4 "Hipertensión E-II" 5 "Urgencia Hipertensiva"
label values estadiohta estadiohta
codebook estadiohta
gen edadangiografia = trunc((fechaangiografia2- fechanacimiento2)/365.25)
codebook edadangiografia
label variable edadangiografia "Edad al Momento de la Angiografía"
save "Base de Datos Final.dta", replace
*Descripción de los Pacientes según Variables Sexo y Edad
tabulate sexo, missing
save "Base de Datos Final.dta", replace
summarize edadangiografia, detail
tabstat edadangiografia, statistics( mean sd p25 p50 p75 iqr max min ) by(sexo)
egen float rangosedad = cut(edadangiografia), at(21 45 65 80 150) icodes
label variable rangosedad "Rangos de Edad"
label define rangosedad 0 "Adulto Joven (25 a 45 años)" 1 "Adulto (46 a 65 años)" 2 "Adulto Mayor (66 a 80 años)" 3 "Adulto Centenario (>80 años)"
label values rangosedad rangosedad
codebook rangosedad
histogram rangosedad, discrete frequency binrescale normal ytitle(No. de Pacientes) xtitle(Rangos de Edad) title("Distribución de la Población Según Rangos de Edad")
tabulate rangosedad sexo
tabulate rangosedad sexo, column
save "Base de Datos Final.dta", replace
*Describa el diagnóstico de enfermedad coronaria de acuerdo al tipo de dolor torácico presentado
codebook enfcardiaca
codebook tipodolor
tabulate tipodolor enfcardiaca
tabulate tipodolor enfcardiaca, row
save "Base de Datos Final.dta", replace
