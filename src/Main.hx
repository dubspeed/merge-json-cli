/*
 * Copyright 2021 Michael Engel
 * SPDX-License-Identifier: Apache-2.0
 */

import hx.files.Path;
import hx.files.File;
import haxe.DynamicAccess;
import haxe.Json;
import hx.files.Dir;
import MergeJson;
import tjson.TJSON;

/*
 *	CLI tool that allows merging of multiple json files together,
 * 	supports multiple glob patterns to match multiple directories
 */
class Main {
	public static var _result:DynamicAccess<Dynamic> = {};

	public static var _target_file_path:String = "output.json";
	public static var _dir:String = ".";
	public static var _globs:Array<String> = ["**/*.json"];
	public static var _customGlobs:Bool = false;
	public static var _pretty:Bool = false;
	public static var _strict:Bool = false;
	public static var _verbose:Bool = false;
	public static var _unknown:Bool = false;

	public static var _argHandler = hxargs.Args.generate([
		@doc("output file containing the result, default output.json")
		["-o", "--output"] => function(arg:String) _target_file_path = arg,
		@doc("root working directory, default .")
		["-d", "--dir"] => function(arg:String) _dir = arg,
		@doc("glob pattern to match files below -d <dir>, multiple -g parameters are supported, default **/*.json")
		["-g", "--glob"] => function(arg:String) {
			// first use of this command overrides the default glob
			if (!_customGlobs) {
				_globs = [arg];
				_customGlobs = true;
			} else {
				_globs.push(arg);
			}
		},
		@doc("strict json parsing, default false")
		["-s", "--strict"] => function() _strict = true,
		@doc("pretty print the resulting json file, default false")
		["-p", "--pretty"] => function() _pretty = true,
		@doc("print helpfull information while processing, default false")
		["-v", "--verbose"] => function() _verbose = true,
		_ => function(arg:String) {
			Sys.stderr().writeString('MergeJson, unknown parameter: $arg\n');
			_unknown = true;
		}
	]);

	public static function main():Int {
		// Input: parse command line arguments
		var args = Sys.args();
		if (args.length == 0) {
			Sys.println("MergeJson, merge muliple JSON files together into one. \n");
			Sys.println(_argHandler.getDoc());
			return -1;
		} else
			_argHandler.parse(args);

		// unknown parameter given as input
		if (_unknown)
			return -1;

		if (_verbose) {
			Sys.println('Targetfile is: $_target_file_path');
			Sys.println('Working directory is set to: $_dir');
			for (glob in _globs)
				Sys.println('Matching files with pattern: $glob');
		}

		// Find all files using globs
		var dir = Dir.of(_dir);
		var input_files:Array<File> = [];
		for (glob in _globs)
			input_files = input_files.concat(dir.findFiles(glob));

		// Processing: merge all files
		for (file in input_files) {
			if (_verbose)
				Sys.println('processing: $file');
			var content = file.readAsString();
			var json:DynamicAccess<Dynamic> = null;
			try {
				json = _strict ? Json.parse(content) : TJSON.parse(content);
			} catch (e) {
				Sys.stderr().writeString('JSON parsing failed while processing $file\n');
				Sys.stderr().writeString(e.toString() + '\n');
				if (_strict)
					Sys.stderr().writeString('(--strict was given, try running the tool without.)\n');
			}
			_result = MergeJson.merge(_result, json);
		};

		// Output: write result
		var path = Path.of(_target_file_path);
		if (_verbose)
			Sys.println('Processing finished, writing result to $path');
		var output = File.of(path);
		output.writeString(Json.stringify(_result, null, _pretty ? " " : ""));
		return 0;
	}
}
