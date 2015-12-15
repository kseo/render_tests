// Copyright (c) 2015, Kwang Yul Seo. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library render_tests.example.base64encoder_tests;

import 'dart:async';
import 'dart:convert';

import 'package:args/command_runner.dart';
import 'package:render_tests/render_tests.dart';

class Base64Renderer implements StringRenderer {
  String render(String input) {
    final Base64Encoder _encoder = new Base64Encoder();
    return _encoder.convert(input.codeUnits);
  }
}

class RunCommand extends Command {
  final name = "run";
  final description = "run the tests";
  final RendererTests _tests;

  RunCommand(this._tests);

  Future run() async {
    _tests.runTests();
  }
}

class RebaselineCommand extends Command {
  final name = "rebaseline";
  final description = "rebaseline the tests";
  final RendererTests _tests;

  RebaselineCommand(this._tests) {
    argParser.addFlag('all',
        abbr: 'a', help: 'rebaseline all tests');
  }

  Future run() async {
    if (argResults.rest.isEmpty || argResults['all']) {
      await _tests.rebaselineAll();
    } else {
      for (final path in argResults.rest) {
        await _tests.rebaseline(path);
      }
    }
  }
}

main(List<String> args) async {
  final renderer = new Base64Renderer();
  final tests = new RendererTests(renderer, '**.txt', verbose: true);

  new CommandRunner('base64encoder_tests', 'base64encoder tests')
    ..addCommand(new RebaselineCommand(tests))
    ..addCommand(new RunCommand(tests))
    ..run(args);
}
