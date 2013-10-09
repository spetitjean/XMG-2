%% -*- prolog -*-

:-module(xmg_compiler_conf).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Compiler Configuration
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

init:-
	add_to_path('contributions/synsem/compilers'),
	use_module('generated_parser_test.yap'),
	use_module('xmg_dimensions'),
	use_module('xmg_tokenizer_punct'),
	use_module('xmg_modules_def').