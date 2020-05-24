CSS SELECTOR PARSER
===================

Deno utility to parse CSS selector.

## Example Usage

```ts
import { parse } from "https://raw.githubusercontent.com/emsifa/deno-css-selector-parser/master/css-selector-parser.ts";

const result = parse("a[href^='https://www.google.com'] > span.label");

console.log(JSON.stringify(result, null, 2));
```

Result:

```json
{
  "type": "RuleSet",
  "selectors": [    
    {
      "type": "Selector",
      "combinator": ">",
      "left": {
        "type": "SimpleSelector",
        "element": "a",
        "qualifiers": {
          "ids": [],
          "classes": [],
          "attrs": [
            {
              "type": "AttributeSelector",
              "attribute": "href",
              "operator": "^=",
              "value": "https://www.google.com"
            }
          ]
        }
      },
      "right": {
        "type": "SimpleSelector",
        "element": "span",
        "qualifiers": {
          "ids": [],
          "classes": [
            {
              "type": "ClassSelector",
              "class": "label"
            }
          ],
          "attrs": []
        }
      }
    }
  ]
}
```