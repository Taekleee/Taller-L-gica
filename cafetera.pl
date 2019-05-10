%Integrantes: Catalina Morales Rojas - Juan Fernández Muñoz.
%Rut: 19.848.748-1 - 19.420.486-8


%*************************METAS******************************++***
%prepararCafe(TamañoTaza,TipoPreparación,TipoCafe,EstacionAño,Salida).
%cantidadTazas(TamanoTaza,TipoPreparacion,_,EstacionAno,CantidadCafe,CantidadAgua,CantidadLeche,CantidadChocolate,Salida):-
%sePuedeUsar(Instalada,CantidadAgua,CantidadCafe,CantidadLeche).
%intensidadCafe(TipoCafe, TipoPreparacion, Salida).


%***************************HECHOS********************************



%Indica la proporción de los ingredientes de cada una de las preparaciones: Cafe - Agua - Leche - Chocolate -
tiposPreparacion(espresso,7,30,0,0).
tiposPreparacion(americano,7,60,0,0).
tiposPreparacion(cortado,7,50,3,0).
tiposPreparacion(cappuccino,7,150,19,0).
tiposPreparacion(latte,7,90,9,0).
tiposPreparacion(mokaccino,7,100,9,3).

%Indica los tipos de café y su intensidad respectiva.
tipoCafe(arabica,suave,1).
tipoCafe(robusta,intenso,3).
tipoCafe(combinado,medio,2).
tipoCafe(descafeinado,suave,1).

%Le asigna un valor a cada una de las intensidades.
gradoIntensidad(suave,1).
gradoIntensidad(medio,2).
gradoIntensidad(intenso,3).


%Indica el tiempo de prepación de los cafés dependiendo de la época del año en que se encuentra,
%debido a que la temperatura ambiente varía.
estacion(verano,60).
estacion(otono,90).
estacion(primavera,90).
estacion(invierno,120).


%Cada tamaño se relaciona con una proporción para saber que cantidades de ingredientes tiene cada taza.
tamano(pequeno,1).
tamano(mediana,2).
tamano(grande,3).

%Permite comparar si una máquina está o no instalada.
instalada(si).



%********************CLAUSULAS DE HORN***+************************



%Entradas: N: Cantidad de veces que se deben sumar los ingredientes.
%		   X,Y,Z,W: Valor asignado a cada ingrediente.
%		   Xs,Ys,Zs,Ws: Variable en donde serán almacenados los ingredientes. 
%Cantidad retorna la proporción de cada
cantidad(N,X,Xs,Y,Ys,Z,Zs,W,Ws):- Xs is X*N,
								  Ys is Y*N,
								  Zs is Z*N,
								  Ws is W*N.

%Entradas: CafeI,AguaI,LecheI,ChocolateI : Contienen la cantidad ingresada por el usuario para cada ingrediente.
%		   CafeNecesario,AguaNecesaria,LecheNecesaria,ChocolateNecesario: Contiene la cantidad real que se necesita para realizar cada taza.
%		   R: Variable en donde son almacenadas la cantidad de tazas que se pueden hacer.
%La salida es la cantidad de tazas que es posible realizar según los ingredientes ingresados por el usuario y lo que necesitan para cada una de las tazas.
capacidad(CafeI,CafeNecesario,AguaI,AguaNecesaria,LecheI,LecheNecesaria,ChocolateI,ChocolateNecesario,R):- 
		CafeI>= CafeNecesario,
		LecheI>=LecheNecesaria,
		AguaI>=AguaNecesaria,
		ChocolateI >= ChocolateNecesario,
		CafeNuevo is (CafeI - CafeNecesario),
		LecheNueva is (LecheI - LecheNecesaria),
		AguaNueva is (AguaI - AguaNecesaria),
		ChocolateNuevo is (ChocolateI - ChocolateNecesario),
		capacidad(CafeNuevo, CafeNecesario, AguaNueva,AguaNecesaria,LecheNueva, LecheNecesaria,ChocolateNuevo,ChocolateNecesario,Rnuevo),
		R is (Rnuevo + 1).
capacidad(_,_,_,_,_,_,_,_,0).





%Entradas: Duracion: Corresponde a la cantidad de minutos que demora una taza en específico en ser preparada.
%		   CantidadTazas: Corresponde a la cantidad de tazas que serán preparadas.
%		   Minutos: Variable en donde se almacenan los minutos totales.
%Retorna el tiempo total en minutos que demorará la preparación de todas las tazas ingresadas.
minutos(_,0,0).
minutos(Duracion,CantidadTazas,Minutos):- CantidadTazas >0,
										  CantidadTazasNuevo is (CantidadTazas - 1),
										  minutos(Duracion,CantidadTazasNuevo,MinutosNuevo),
										  Minutos is (MinutosNuevo + Duracion).
				


% El predicado retorna la proporción que es necesaria de cada ingrediente según el tipo de preparación, la intensidad y el tiempo que demora su preparación
% tipo de café y la estación del año  el tamaño de la taza.
prepararCafe(TamanoTaza,TipoPreparacion,TipoCafe,EstacionAno,Salida):- tiposPreparacion(TipoPreparacion,X,Y,Z,W),
																	   tamano(TamanoTaza,Valor),
																	   tipoCafe(TipoCafe,Intensidad,_),
																	   cantidad(Valor,X,Xs,Y,Ys,Z,Zs,W,Ws),
																	   estacion(EstacionAno,Tiempo),
																	   atomic_list_concat([Xs,",",Zs,",",Ys,",",Ws,",",Intensidad,",",Tiempo],Salida).

%Indica si una cafetera puede ser utilizada en base a si las cantidades de agua, café y leche que esta posee
% además de si se encuentra o no instalada. Las cantidades deben ser: Agua mayor a 150 y café y leche mayor a 30.
sePuedeUsar(Instalada,CantidadAgua,CantidadCafe,CantidadLeche):- instalada(Instalada),
																 CantidadAgua >= 150,
																 CantidadCafe >=30,
																 CantidadLeche>=30.


%Entrega la cantidad total de tazas que pueden ser realizadas según las proporciones de los ingredientes ingresados y el tiempo que demora 
cantidadTazas(TamanoTaza,TipoPreparacion,_,EstacionAno,CantidadCafe,CantidadLeche,CantidadAgua,CantidadChocolate,Salida):-
		tiposPreparacion(TipoPreparacion,Cafe,Agua,Leche,Chocolate),
		tamano(TamanoTaza,Valor),
		cantidad(Valor,Cafe,CafeTotal,Agua,AguaTotal,Leche,LecheTotal,Chocolate,ChocolateTotal),
		capacidad(CantidadCafe,CafeTotal,CantidadAgua,AguaTotal,CantidadLeche,LecheTotal,CantidadChocolate, ChocolateTotal,Tazas),
		estacion(EstacionAno,Tiempo),
		minutos(Tiempo,Tazas,Minutos),
		atomic_list_concat([Tazas,",",Minutos],Salida). 


%Intensidad entrega -1 si las proporciones de leche o de chocolate son mayores a las de café.
intensidad(Cafe,Leche,Chocolate,-1):- (Cafe < Leche);
									  (Cafe < Chocolate).
%Si la leche y el chocolate son menores al café (caso contrario del anterior), se retorna 0 para que la intensidad se conserve.
intensidad(Cafe,Leche,Chocolate,0):- (Cafe > Leche),
									 (Cafe > Chocolate).

%IntensidadCafe entrega la intensidad que tiene cada café, dependiendo del tipo de preparación y el tipo de café.
%La intensidad no puede ser menor a suave. Si las proporciones de la leche o chocolate son mayores a las de café
%la intensidad se disminuye en un grado.
intensidadCafe(_,TipoPreparacion,Salida):- tiposPreparacion(TipoPreparacion,Cafe,_,Leche,Chocolate),
												  intensidad(Cafe,Leche,Chocolate,X),
												  X =:= 1,
												  gradoIntensidad(Salida,X).


intensidadCafe(TipoCafe, TipoPreparacion, Salida):- tiposPreparacion(TipoPreparacion,Cafe,_,Leche,Chocolate),
													 intensidad(Cafe,Leche,Chocolate,X),
													 tipoCafe(TipoCafe,_,Y),
													 Z is Y + X,
													 gradoIntensidad(Salida,Z).

