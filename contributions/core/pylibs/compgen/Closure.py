# -*- coding: utf-8 -*-

from xmg.compgen.Symbol import Symbol
from xmg.compgen.Item import LR0Item
from xmg.compgen.Rule import Rule
from xmg.compgen.Grammar import BasicGrammar
from xmg.compgen.First import First

# class Closure:

# 	def __init__(self,I):
# 		self._closure = None
# 		super(Closure, self).__init__()

# 	def closure(self, I):
# 		"""returns a constant set of all the items built by a closure of the items I."""
# 		# assert isinstance(I, [LR0Item::_])
# 		if self._closure is None:
# 			self._compute_closure()
# 		return self._closure[I]

def compute_closure(I,G):
	rules_ = G.rules
	J = set(I)
	closure=set(I)
	fixpoint=False
	while not fixpoint :
		print('fixpoint not reached')
		fixpoint=True
		J=closure.copy()
		for item in J:
			print('item : ')
			print(item)
			if not item.complete:
				suff=item.suffix
				for rule in rules_:
					print('rule : ')
					print(rule)
					head=rule.head
					if head==suff[0]:
						additem=LR0Item((rule,0,))
						if additem not in closure :
							closure.add(additem)
							print('* added *')
							fixpoint=False
	return closure

def compute_closure_1(I,G):
	rules_ = G.rules
	J = set(I)
	closure=set(I)
	fixpoint=False
	while not fixpoint :
		print('fixpoint not reached')
		fixpoint=True
		J=closure.copy()
		for item in J:
			print('item : ')
			print(item)
			if not item.lr0.complete:
				suff=item.lr0.suffix
				for rule in rules_:
					print('rule : ')
					print(rule)
					head=rule.head
					token=item.token
					first= First(suff[1:]+[token])
					for b in first:
						if head==suff[0]:
							additem=LR1Item(LR0item(rule,0,),b,)
							if additem not in closure :
								closure.add(additem)
								print('* added *')
								fixpoint=False
	return closure
				
				

			    
			    
    
