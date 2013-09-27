type CLASS=[1..7]
type GENDER={m,f}
type ACCENT={penultimate,last}

feature nclass : CLASS
feature gender : GENDER
feature accent : ACCENT

field root
field end
field p1
field p2
field p3


class name 
export R E C G A
declare R E C G A
{
	% %% naag -->> naago
	% <morph>{
	% 	R = "naa";
	% 	E = "g";
	% 	C = 1;
	% 	G = f;
	% 	A = last
	% 	}
	% 	|
	% %%  galab -->> galbo, meme pluriel que naag, sauf que la dernière voyelle de la racine disparait
	% <morph>{
	% 	R = "gala";
	% 	E = "b";
	% 	C = 1;
	% 	G = f;
	% 	A = last
	% 	}
	% 	|
	% %% albaab -->> albaabbo 
	% <morph>{
	% 	R = "albaa";
	% 	E = "b";
	% 	C = 2;
	% 	G = m;
	% 	A = penultimate
	% 	}
	% 	|	
	% %% dariiq -->> dariiqyo, meme pluriel que albaab, sauf que le q est parmi les consonnes qui ne doublent pas  
	% <morph>{
	% 	R = "darii";
	% 	E = "q";
	% 	C = 2;
	% 	G = m;
	% 	A = penultimate
	% 	}
	% 	|
	% %% dab
	% <morph>{
	% 	R = "da";
	% 	E = "b";
	% 	C = 4;
	% 	G = m;
	% 	A = last
	% 	}
	% 	|
	% %% miis
	% <morph>{
	% 	R = "mii";
	% 	E = "s";
	% 	C = 4;
	% 	G = m;
	% 	A = last
	% 	}
	% 	|
	% %% ilik -->> ilko
	% <morph>{
	% 	R = "ili";
	% 	E = "k";
	% 	C = 3;
	% 	G = m;
	% 	A = penultimate
	% 	}
	% 	|
	% %% bare
	% <morph>{
	% 	R = "bar";
	% 	E = "e";
	% 	C = 6;
	% 	G = m;
	% 	A = last
	% 	}
	% 	|
	% %% sheeko
	% <morph>{
	% 	R = "sheek";
	% 	E = "o";
	% 	C = 7;
	% 	G = f;
	% 	A = last
	% 	}
	%% naag -->> naago
	<morph>{
		R = "naag";
		C = 1;
		G = f
		}
		|
	%%  galab -->> galbo, meme pluriel que naag, sauf que la dernière voyelle de la racine disparait
	<morph>{
		R = "galab";
		C = 1;
		G = f
		}
		|
	%% albaab -->> albaabbo 
	<morph>{
		R = "albaab";
		C = 2;
		G = m
		}
		|	
	%% dariiq -->> dariiqyo, meme pluriel que albaab, sauf que le q est parmi les consonnes qui ne doublent pas  
	<morph>{
		R = "dariiq";
		C = 2;
		G = m
		}
		|
	%% dab
	<morph>{
		R = "dab";
		C = 4;
		G = m
		}
		|
	%% miis
	<morph>{
		R = "miis";
		C = 4;
		G = m
		}
		|
	%% ilik -->> ilko
	<morph>{
		R = "ilik";
		C = 3;
		G = m
		}
		|
	%% bare
	<morph>{
		R = "bare";
		C = 6;
		G = m
		}
		|
	%% sheeko
	<morph>{
		R = "sheeko";
		C = 7;
		G = f
		}
	}

class singular
declare Name R E C G A
{
	Name=name[];
	R = Name.R;
	%E = Name.E;
	C = Name.C;
	G = Name.G;
	%A = Name.A;
	<morph>{
		root <- R;
		%end <- E;
		nclass = C;
		gender = G
		%accent = A
		}
}

class plural
declare Name R E C G A L
{
	Name=name[];
	R = Name.R;
	%E = Name.E;
	C = Name.C;
	G = Name.G;
	%A = Name.A;
	<morph>{
		root <- R;
		nclass = C
		}
	;
	{
		%% pluriel classe 1 : changement de genre et suffixe o
		<morph>{
			C = 1;
			G = f;
			%A = last;
			gender = m;
			%end <- E;
			end <- "AU"
			%accent = last
			}
	|
		%% pluriel classe 2 : changement de genre, doublement de la consonne finale et suffixe o
			<morph>{
			C = 2;
			G = m;
			%A = penultimate;
			gender = f;
			%end <- E;
			%p1 <- E;
			end <- "+AU"	
			%accent = last
			}
	|
		%% pluriel classe 3 : ajout de o, disparition de la derniere voyelle
			<morph>{
			C = 3;
			G = m;
			gender = m;
			%end <- E;
			end <- "AU"
			%accent = last
			}
	|
		%% pluriel classe 4 : ajout de a, puis de la derniere consonne
			<morph>{
			C = 4;
			G = m;
			gender = m;
			%end <- E;
			end <- "AU"
			%p2 <- E;
			%accent = last
			}
	|
		%% pluriel classe 6 : changement de genre, le e est remplace par ayaal
			<morph>{
			C = 6;
			G = m;
			gender = f;
			end <- "ayaal"
			%accent = penultimate
			}
	|
		%% pluriel classe 7 : changement de genre, le o est remplace par ooyin
			<morph>{
			C = 7;
			G = f;
			gender = m;
			%end <- E;
			end <- "oyin"
			%accent = penultimate
			}
	}
	% ; 
	% En classe 3, la derniere lettre (voyelle) de la racine disparait
	% {
	% 		<phon>{
	% 		C=3;
	% 		root=L^ ; 
	% 		L -> '' 
	% 		}

	% test PC-KIMMO :
	% V est une voyelle, = un caractere (qui ne sont pas couverts par d'autres colonnes)
	  % Lexical :  V =
	  % Surface :  0 =
	  % 1 :	     2 1
	  % 2 :	     0 0
	  

	% |
	% 		<phon>{
	% 		C=2;
	% 		p2=L ; 
	% 		L=@{'q','h'}
	% 		}
	% }

	  % En definissant un type G pour les consonnes gutturales
	  % SUBSET G     q h j s

	  % Lexical : G G =
	  % Surface : G Y =
	  % 1 :       2 0 1
	  % 2 :	    0 1 1

}
	

%value name
%value singular
value plural