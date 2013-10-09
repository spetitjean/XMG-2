%% -*- prolog -*-

:-module(xmg_tokenizer).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Part of tokenizer
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dim('<sem>') -->> input_gets("sem"),!. 
dim(dim('sem')) -->> input_gets("<sem>"),!.
dim('<syn>') -->> input_gets("syn"),!. 
dim(dim('syn')) -->> input_gets("<syn>"),!.
