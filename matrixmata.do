

//Scalars Code **
clear all

mata:

void  mobscalar()

{



X=st_data(.,.)

M= ( X[1::5] \ X[6::10] \ X[11::15] \ X[16::20] \ X[21::25]  )

//M1

M1= (cols(M)-sum(diagonal(M)))/( cols(M)-1)

display("M1  calculada")

//M2

eig=eigenvalues(M)

sort(eig,1)

M2=1-eig[2]

M2=Re(M2)

display("M2  calculada")

//M3

M3=1-abs(det(M))
display("M3  calculada")

//M4

// first i will compute the steady state disribution 




display("aca 1")

eigtr=eigenvalues(M')

i=0
w=0

display("aca 2")

minindex(abs(eigtr-J(1,5,1)),1,i,w)

//here i obtain the position of the eigenvector that equals 1 which is i 

X=.

L=.


symeigensystem(M',X,L)

pi=X[.,i]/sum(X[.,i])  
 
M4=(cols(M)- cols(M)*pi'*diagonal(M))/(cols(M)-1)

display("M4  calculada")

display("se corre hasta las M's ")

idx=st_addvar("float",("M1","M2","M3","M4"))


st_store(.,idx,(M1,M2,M3,M4))

}


end





