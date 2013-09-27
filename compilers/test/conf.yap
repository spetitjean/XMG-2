%% -*- prolog -*-

:-module(xmg_compiler_conf).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Compiler Configuration
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

init:-
	add_to_path('/home/simon/Bureau/XMG-NG'),
	use_module('compilers/test/generated_parser_test.yap'),
	add_to_path('/home/simon/Bureau/XMG-NG/compilers/test'),
	use_module('xmg_dimensions'),
	use_module('xmg_tokenizer_punct'),
	use_module('xmg_modules_def').