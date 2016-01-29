# -*- coding: utf-8 -*-
import xml.etree.cElementTree as ETree

class Grammar(object):
    
    @classmethod
    def fromFile(cls, filename, formalism, encoding="utf-8"):
        parser = ETree.XMLParser(encoding=encoding)
        return cls(ETree.parse(filename, parser=parser),formalism)

    @classmethod
    def fromstring(cls, string, encoding="utf-8"):
        return cls(ETree.XML(string))

    def __init__(self, etree, formalism):
        #self.entries = tuple(map(Entry,etree.findall(".//entry")))
        self.entries = [Entry(entry,formalism) for entry in etree.findall(".//entry")]


def textof(elem):   
    return "".join(elem.itertext()).replace('class_', '')

def gensem(sem):
    if sem is None:
        return ''
    else:
        s = ''
        for i in sem.findall("*"):
            if i.tag == "literal":
                if not i.get("negated") is None:
                    s += "!"
                    s += gensem(i)
            elif i.tag == 'label':
                # s+= i.find('sym').get('value') + ":"
                if 'value' in i.find('sym').attrib:
                    s+= i.find('sym').get('value') + ":"
                elif 'varname' in i.find('sym').attrib: 
                    s+= i.find('sym').get('varname') + ":"
            elif i.tag == 'predicate':
                if 'value' in i.find('sym').attrib:
                    s+= i.find('sym').get('value') + "("
                elif 'varname' in i.find('sym').attrib: 
                    s+= i.find('sym').get('varname') + "("
            elif i.tag == 'arg':
                s+= i.find("sym").get('varname') + ","
        if len(s) > 0:
            if s[len(s)-1] == ',':
                s = s[:-1]
                s+=')\n'
        return s

class Entry(object):

    def __init__(self, entry, formalism):
        if formalism == "tag":
            to_find="tree/node"
        elif formalism == "frame":
            to_find="frame/node"

        self.name = entry.get("name").replace('class_', '')
        self.family = textof(entry.find("family")).replace('class_', '')
        self.semantics = gensem(entry.find("semantics", None))
        fs = entry.find("interface/fs", None)
        self.interface = None if fs is None else FS(fs)
        self.trace = tuple(map(textof,entry.find("trace").findall("class")))
        self.root = Node(entry.find(to_find))



class Node(object):

    def __init__(self, node):
        self.type = node.get("type",None)
        self.name = node.get("name",None)
        fs = node.find("narg/fs", None)
        self.fs = None if fs is None else FS(fs)
        self.children = tuple(map(Node,node.findall("node")))
        
    def __eq__(self, other):
        if self.type != other.type:
            return False
        else:
            return self.fs == other.fs

class FS(object):

    def __init__(self, fs):
        self.coref = fs.get("coref", None)
        self.table = {}
        for f in fs.findall("f"):
            if f.find('*', None) is None:
                self.table[f.get("name")] = f.get("varname")
            else:
                self.table[f.get("name")] = feature_value(f.find("*"))
    def __eq__(self, other):
        return self.table['cat'] == other.table['cat']

def feature_value(value):
    tag = value.tag
    assert tag in ("fs","sym","vAlt")
    if value.tag == "fs":
        return FS(value)    
    if value.tag == "sym":
        if not value.get('varname') is None:
            return value.get('varname')
        else:
            return value.get("value")
    if value.tag == "vAlt":
        return ALT(value)


class ALT(object):

    def __init__(self, alt):
        self.coref = alt.get("coref", None)
        self.values = tuple(map(feature_value,alt.findall("sym")))

    def __eq__(self,  other):
        if str(other).find('ALT') > -1:
            s = ''
            for i in self.values:
                s += i + '|'
            y = ''
            for i in other.values:
                y += i + '|'
            return s == y
        else:
            return False
