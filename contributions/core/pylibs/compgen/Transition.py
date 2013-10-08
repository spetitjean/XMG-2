# -*- coding: utf-8 -*-

from xmg.compgen.Symbol import Symbol
from xmg.compgen.Item import LR0Item
from xmg.compgen.Rule import Rule
from xmg.compgen.Closure import compute_closure, compute_closure_1

#class Transition:

	# def __init__(self):
	# 	self._transition = None
	# 	super(Transition, self).__init__()

	# 	def transition(self, I, X):
	# 		"""returns the closure of the set of the items [A->alpha X.beta] such than [A -> alpha.X beta] belongs to I"""
	# 		# assert isinstance(I, [Item::_])
	# 		assert isinstance(X, Symbol)
	# 		if self._transition is None:
	# 			self._compute_transition(I,X)
	# 	return self._transition[I,X]

def compute_transition(I,X,G):
	J=set()
	for item in I :
		rule_=item.rule
		index=item.index
		if not item.complete:
			if X==item.suffix[0]:
				shift=LR0Item((rule_,index+1,))
				J.add(shift)
	return compute_closure(J,G)

def compute_transition_1(I,X,G):
	J=set()
	for item in I :
		rule_=item.rule
		index=item.index
		if not item.lr0.complete:
			if X==item.suffix[0]:
				shift=LR1Item(LR0Item((rule_,index+1,)),token,)
				J.add(shift)
	return compute_closure_1(J,G)
