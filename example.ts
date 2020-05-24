import { parse } from "./css-selector-parser.ts";

const result = parse("a[href^='https://www.google.com'] > span.label");

console.log(JSON.stringify(result, null, 2));