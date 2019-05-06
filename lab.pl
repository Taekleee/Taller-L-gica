%***************************PREDICADOS***************************
%especies()
%tipo()


%*************************METAS******************************++***
%prepararCafe(TamañoTaza,TipoPreparación,TipoCafe,EstacionAño,Salida).
%cantidadTazas(TamañoTaza,TipoPreparación,TipoCafe,EstacionAño,Salida).
%sePuedeUsar(Instalada,CantidadAgua,CantidadCafe,CantidadLeche).
%intensidadCafe(TipoCafe,TipoPreparación,Salida).


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


gradoIntensidad(suave,1).
gradoIntensidad(medio,2).
gradoIntensidad(intenso,3).


%Indica el tiempo de prepación de los cafés dependiendo de la época del año en que se encuentra,
%debido a que la temperatura ambiente varía.
estacion(verano,60).
estacion(otono,90).
estacion(primavera,90).
estacion(primavera,90).
estacion(invierno,120).


%Cada tamaño se relaciona con una proporción para saber que cantidades de ingredientes tiene cada taza.
tamano(pequeno,1).
tamano(mediana,2).
tamano(grande,3).

instalada(si).



%********************CLAUSULAS DE HORN***+************************

%Suma se utiliza para sumar los valores usados para una taza de cafe
suma(0,_ ,0).
suma(N,X,R):- Nant is N-1,
			suma(Nant,X,Rnuevo),
			R is (Rnuevo + X).


cantidad(N,X,Xs,Y,Ys,Z,Zs,W,Ws):- suma(N,X,Xs),
								  suma(N,Y,Ys),
								  suma(N,Z,Zs),
								  suma(N,W,Ws).


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



minutos(_,0,0).
minutos(Duracion,CantidadTazas,Minutos):- CantidadTazas >0,
										  CantidadTazasNuevo is (CantidadTazas - 1),
										  minutos(Duracion,CantidadTazasNuevo,MinutosNuevo),
										  Minutos is (MinutosNuevo + Duracion).
				

prepararCafe(TamanoTaza,TipoPreparacion,TipoCafe,EstacionAno,Salida):- tiposPreparacion(TipoPreparacion,X,Y,Z,W),
																	   tamano(TamanoTaza,Valor),
																	   tipoCafe(TipoCafe,Intensidad,_),
																	   cantidad(Valor,X,Xs,Y,Ys,Z,Zs,W,Ws),
																	   estacion(EstacionAno,Tiempo),
																	   atomic_list_concat([Xs,",",Ys,",",Zs,",",Ws,",",Intensidad,",",Tiempo],Salida).


sePuedeUsar(Instalada,CantidadAgua,CantidadCafe,CantidadLeche):- instalada(Instalada),
																 CantidadAgua >= 150,
																 CantidadCafe >=30,
																 CantidadLeche>=30.

cantidadTazas(TamanoTaza,TipoPreparacion,_,EstacionAno,CantidadCafe,CantidadAgua,CantidadLeche,CantidadChocolate,Salida):-
		tiposPreparacion(TipoPreparacion,Cafe,Agua,Leche,Chocolate),
		tamano(TamanoTaza,Valor),
		cantidad(Valor,Cafe,CafeTotal,Agua,AguaTotal,Leche,LecheTotal,Chocolate,ChocolateTotal),
		capacidad(CantidadCafe,CafeTotal,CantidadAgua,AguaTotal,CantidadLeche,LecheTotal,CantidadChocolate, ChocolateTotal,Tazas),
		estacion(EstacionAno,Tiempo),
		minutos(Tiempo,Tazas,Minutos),
		atomic_list_concat([Tazas,",",Minutos],Salida). 

intensidad(Cafe,Leche,Chocolate,-1):- (Cafe < Leche);
									  (Cafe < Chocolate).

intensidadCafe(_,TipoPreparacion,Salida):- tiposPreparacion(TipoPreparacion,Cafe,_,Leche,Chocolate),
												  intensidad(Cafe,Leche,Chocolate,X),
												  X =:= 1,
												  gradoIntensidad(Salida,X).


intensidadCafe(TipoCafe, TipoPreparacion, Salida):- tiposPreparacion(TipoPreparacion,Cafe,_,Leche,Chocolate),
													 intensidad(Cafe,Leche,Chocolate,X),
													 tipoCafe(TipoCafe,_,Y),
													 Z is Y + X,
													 gradoIntensidad(Salida,Z).

