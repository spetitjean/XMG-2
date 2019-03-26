# Content:

* folder Description contains a short documentation of the mg

* lvc-stehen_v2.mg: the initial metagrammar

* types.mg: description of the type hierarchy

* lvc-stehen-syn.mg: description of the syntactic structures
  to compile (with type hierarchy generated):
  xmg compile synframe lvc-stehen-syn.mg --force --more

* lvc-stehen-frame.mg: description of the semantic frames
  to compile (with type hierarchy generated):
  xmg compile synframe lvc-stehen-frame.mg --force --more

* lvc-stehen-lex.mg: lexicon of lemmas
  to compile:
  xmg compile lex lvc-stehen-lex.mg --force

* lvc-stehen-mph.mg: lexicon of inflected forms
  to compile:
  xmg compile mph lvc-stehen-mph.mg --force

* compile_all.sh: a script to compile the 4 resources

* .xml files: the generated grammars/lexicons

* more.mac: the generated type hierarchy