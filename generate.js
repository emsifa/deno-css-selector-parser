const fs = require("fs");
const pegjs = require("pegjs");
const tspegjs = require("ts-pegjs");
const peg = fs.readFileSync("css-selector.pegjs");

const parser = pegjs.generate(peg.toString(), {
    output: "source",
    format: "commonjs",
    plugins: [tspegjs],
    "tspegjs": {
        "noTslint": true,
    }
});

fs.writeFileSync("generated.ts", parser);