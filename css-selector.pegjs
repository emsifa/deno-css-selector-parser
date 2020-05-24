{
  function extractOptional(optional, index) {
    return optional ? optional[index] : null;
  }

  function extractList(list, index) {
    return list.map(function(element) { return element[index]; });
  }

  function buildList(head, tail, index) {
    return [head].concat(extractList(tail, index))
      .filter(function(element) { return element !== null; });
  }

  function buildExpression(head, tail) {
    return tail.reduce(function(result, element) {
      return {
        type: "Expression",
        operator: element[0],
        left: result,
        right: element[1]
      };
    }, head);
  }
}

start
  = ruleset
  
operator
  = "/" S* { return "/"; }
  / "," S* { return ","; }

combinator
  = "+" S* { return "+"; }
  / ">" S* { return ">"; }

property
  = name:IDENT S* { return name; }

ruleset
  = selectorsHead:selector
    selectorsTail:("," S* selector)*{
      return {
        type: "RuleSet",
        selectors: buildList(selectorsHead, selectorsTail, 2),
      };
    }

selector
  = left:simple_selector S* combinator:combinator right:selector {
      return {
        type: "Selector",
        combinator: combinator,
        left: left,
        right: right
      };
    }
  / left:simple_selector S+ right:selector {
      return {
        type: "Selector",
        combinator: " ",
        left: left,
        right: right
      };
    }
  / selector:simple_selector S* { return selector; }

simple_selector
  = element:element_name qualifiers:(id / class / attrib / pseudo)* {
      return {
        type: "SimpleSelector",
        element: element,
        qualifiers: {
            ids: qualifiers.filter(q => q.type === "IDSelector"),
            classes: qualifiers.filter(q => q.type === "ClassSelector"),
            attrs: qualifiers.filter(q => q.type === "AttributeSelector"),
        }
      };
    }
  / qualifiers:(id / class / attrib / pseudo)+ {
      return {
        type: "SimpleSelector",
        element: "*",
        qualifiers: qualifiers
      };
    }

id
  = id:HASH { return { type: "IDSelector", id: id }; }

class
  = "." class_:IDENT { return { type: "ClassSelector", "class": class_ }; }

element_name
  = IDENT
  / "*"

attrib
  = "[" S*
    attribute:IDENT S*
    operatorAndValue:(("=" / INCLUDES / DASHMATCH / BEGINSWITH / ENDSWITH / CONTAINS) S* (IDENT / STRING) S*)?
    "]"
    {
      return {
        type: "AttributeSelector",
        attribute: attribute,
        operator: extractOptional(operatorAndValue, 0),
        value: extractOptional(operatorAndValue, 2)
      };
    }

pseudo
  = ":"
    value:(
        name:FUNCTION S* params:(IDENT S*)? ")" {
          return {
            type: "Function",
            name: name,
            params: params !== null ? [params[0]] : []
          };
        }
      / IDENT
    )
    { return { type: "PseudoSelector", value: value }; }

h
  = [0-9a-f]i

nonascii
  = [\x80-\uFFFF]

unicode
  = "\\" digits:$(h h? h? h? h? h?) ("\r\n" / [ \t\r\n\f])? {
      return String.fromCharCode(parseInt(digits, 16));
    }

escape
  = unicode
  / "\\" ch:[^\r\n\f0-9a-f]i { return ch; }

nmstart
  = [_a-z]i
  / nonascii
  / escape

nmchar
  = [_a-z0-9-]i
  / nonascii
  / escape

string1
  = '"' chars:([^\n\r\f\\"] / "\\" nl:nl { return ""; } / escape)* '"' {
      return chars.join("");
    }

string2
  = "'" chars:([^\n\r\f\\'] / "\\" nl:nl { return ""; } / escape)* "'" {
      return chars.join("");
    }

ident
  = prefix:$"-"? start:nmstart chars:nmchar* {
      return prefix + start + chars.join("");
    }

name
  = chars:nmchar+ { return chars.join(""); }

string
  = string1
  / string2

s
  = [ \t\r\n\f]+

w
  = s?

nl
  = "\n"
  / "\r\n"
  / "\r"
  / "\f"

A  = "a"i / "\\" "0"? "0"? "0"? "0"? [\x41\x61] ("\r\n" / [ \t\r\n\f])? { return "a"; }
C  = "c"i / "\\" "0"? "0"? "0"? "0"? [\x43\x63] ("\r\n" / [ \t\r\n\f])? { return "c"; }
D  = "d"i / "\\" "0"? "0"? "0"? "0"? [\x44\x64] ("\r\n" / [ \t\r\n\f])? { return "d"; }
E  = "e"i / "\\" "0"? "0"? "0"? "0"? [\x45\x65] ("\r\n" / [ \t\r\n\f])? { return "e"; }
G  = "g"i / "\\" "0"? "0"? "0"? "0"? [\x47\x67] ("\r\n" / [ \t\r\n\f])? / "\\g"i { return "g"; }
H  = "h"i / "\\" "0"? "0"? "0"? "0"? [\x48\x68] ("\r\n" / [ \t\r\n\f])? / "\\h"i { return "h"; }
I  = "i"i / "\\" "0"? "0"? "0"? "0"? [\x49\x69] ("\r\n" / [ \t\r\n\f])? / "\\i"i { return "i"; }
K  = "k"i / "\\" "0"? "0"? "0"? "0"? [\x4b\x6b] ("\r\n" / [ \t\r\n\f])? / "\\k"i { return "k"; }
L  = "l"i / "\\" "0"? "0"? "0"? "0"? [\x4c\x6c] ("\r\n" / [ \t\r\n\f])? / "\\l"i { return "l"; }
M  = "m"i / "\\" "0"? "0"? "0"? "0"? [\x4d\x6d] ("\r\n" / [ \t\r\n\f])? / "\\m"i { return "m"; }
N  = "n"i / "\\" "0"? "0"? "0"? "0"? [\x4e\x6e] ("\r\n" / [ \t\r\n\f])? / "\\n"i { return "n"; }
O  = "o"i / "\\" "0"? "0"? "0"? "0"? [\x4f\x6f] ("\r\n" / [ \t\r\n\f])? / "\\o"i { return "o"; }
P  = "p"i / "\\" "0"? "0"? "0"? "0"? [\x50\x70] ("\r\n" / [ \t\r\n\f])? / "\\p"i { return "p"; }
R  = "r"i / "\\" "0"? "0"? "0"? "0"? [\x52\x72] ("\r\n" / [ \t\r\n\f])? / "\\r"i { return "r"; }
S_ = "s"i / "\\" "0"? "0"? "0"? "0"? [\x53\x73] ("\r\n" / [ \t\r\n\f])? / "\\s"i { return "s"; }
T  = "t"i / "\\" "0"? "0"? "0"? "0"? [\x54\x74] ("\r\n" / [ \t\r\n\f])? / "\\t"i { return "t"; }
U  = "u"i / "\\" "0"? "0"? "0"? "0"? [\x55\x75] ("\r\n" / [ \t\r\n\f])? / "\\u"i { return "u"; }
X  = "x"i / "\\" "0"? "0"? "0"? "0"? [\x58\x78] ("\r\n" / [ \t\r\n\f])? / "\\x"i { return "x"; }
Z  = "z"i / "\\" "0"? "0"? "0"? "0"? [\x5a\x7a] ("\r\n" / [ \t\r\n\f])? / "\\z"i { return "z"; }

// Tokens

S "whitespace"
  = s

INCLUDES "~="
  = "~="

DASHMATCH "|="
  = "|="

BEGINSWITH "^="
  = "^="

ENDSWITH "$="
  = "$="

CONTAINS "*="
  = "*="

STRING "string"
  = string:string { return string; }

IDENT "identifier"
  = ident:ident { return ident; }

HASH "hash"
  = "#" name:name { return "#" + name; }

FUNCTION "function"
  = name:ident "(" { return name; }
