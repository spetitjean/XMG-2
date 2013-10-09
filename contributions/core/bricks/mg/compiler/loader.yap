:-module(xmg_loader_mg).

load_module:-
	add_to_path('contributions/MG/bricks/MG/compiler'),
	use_module('xmg_errors'),
	use_module('tokenizer'),
	use_module('xmg_parser'),
	use_module('xmg_unfolder'),
	use_module('xmg_exporter'),
	use_module('xmg_typer'),
	use_module('xmg_generator'),
	use_module('xmg_convert'),
	use_module('xmg_printer'),!.
