:-module(xmg_output_pg).

output([]):-!.
output(L):-
	%%xmg_compiler:send(info,L),xmg_compiler:send_nl(info),
	xmg_compiler:send(info,' PG : '),xmg_compiler:send_nl(info),
	output_list(L),xmg_compiler:send_nl(info),
	xmg_compiler:send(info,'_______________________________________________'),
	xmg_compiler:send_nl(info),xmg_compiler:send_nl(info).

output_list(List):-
	xmg_compiler:send(info,List).

