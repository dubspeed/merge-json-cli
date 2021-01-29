# merge-json-cli

A command line tool to merge different json files together into a single output.

This tool is build around mergejson library and uses the default rules defined there. If custom / additional rules are required, please refer to [the library](https://github.com/dubspeed/mergejson). 

## Features

* Allows multiple glob patterns to target as many json files as desired
* Eats anything that is halfway JSON-like: no problem with comments, dangling commas or missing quotes (unless --strict is given)
* option to pretty print the resulting json

## Usage

Command help:

```
# ./merge-json 

MergeJson, merge muliple JSON files together into one.

[-o | --output] <arg> : output file containing the result, default output.json
[-d | --dir] <arg>    : root working directory, default .
[-g | --glob] <arg>   : glob pattern to match files below -d <dir>, multiple -g parameters are supported, default **/*.json
[-s | --strict]       : strict json parsing, default false
[-p | --pretty]       : pretty print the resulting json file, default false
[-v | --verbose]      : print helpfull information while processing, default false
```

Typical usage:

```
# ./merge-json -v -o combined.json -g data1/**/*.json -g more_data/**/*.json
```

## Installation, Compilation and usage

See the releases sectoin on github for binary versions of the tool.

The tool is build with the [Haxe](https://haxe.org) programming language and toolchain and can be compiled to many of the haxe target platforms (requires a 'sys' access).

For convience binaries for the usual plaforms are provided in the releases section of the page.

1. Install Haxe programming language, e.g.:
``` 
    brew install haxe
```

2. Clone or download the reprository and install the missing libraries

```
    haxelib install all
```

3. Modify and recompile

```
    haxe mergejson-cli.hxml
``` 

## Merge rules

The rules reflect the default merge rules of mergejson and [are reflected here](https://github.com/dubspeed/mergejson#default-rules).

## Examples for merges

Examples of merge results can be found [here at the mergerjson example section](https://github.com/dubspeed/mergejson#examples).

## License


All files are released under the [Apache License 2.0](LICENSE.txt).

Individual files contain the following tag instead of the full license text:
```
SPDX-License-Identifier: Apache-2.0
```

This enables machine processing of license information based on the SPDX License Identifiers that are available here: https://spdx.org/licenses/.


## Contribution

Contributions via github are very welcome!.
