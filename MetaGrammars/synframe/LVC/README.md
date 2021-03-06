# Content:

* folder Description contains a short documentation of the metagrammar

* folder Parses contains outputs from the parser for some example inputs

* types.mg: description of the type hierarchy (used by other the two following mg files)

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

# Use:

* to visualize the example parses, one should use the XMG [WebGUI](http://xmg.phil.hhu.de/index.php/upload/upload_viewer). Remark: as some contraints are not implemented yet, the parser generates the LVC and the litteral readings for all inputs. The overgenerated entries (e.g. the non-loc reading for "Hans steht vor dem Haus") should be ignored. What is missing to prevent this overgeneration is a constraint on the *part-of* relation, which makes sure that the types or both arguments are compatible (two states or two locations for example).

* to compile the grammar, the xmg instructions are given in the descriptions above. The compilation is also possible online (but without the type hierarchy) with the [online compiler](http://xmg.phil.hhu.de/index.php/upload/workbench)

* the generated syntactic and semantics grammars are viewable online (by uploading lvc-stehen-syn.xml or lvc-stehen-frame.xml in the [WebGUI](http://xmg.phil.hhu.de/index.php/upload/upload_viewer))

* to analyse sentences with the grammar, the 5 produced resources can be given to the [TuLiPA parser](https://github.com/spetitjean/TuLiPA-frames)

