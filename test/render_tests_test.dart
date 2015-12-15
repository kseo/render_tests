// Copyright (c) 2015, Kwang Yul Seo. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library render_tests.test;

import 'dart:async';
import 'dart:io';

import 'package:glob/glob.dart';
import 'package:markdown/markdown.dart';
import 'package:path/path.dart' as path;
import 'package:render_tests/render_tests.dart';
import 'package:test/test.dart';

class MarkdownRenderer implements StringRenderer {
  String render(String input) => markdownToHtml(input);
}

String testFilePath(String name) => path.join('test', 'markdowns', name);
String expectedFilePath(String name) =>
    path.join('test', 'markdowns', '$name.expected');

Future deleteExpectedFiles() async {
  final glob = new Glob('**.markdown.expected');
  final entities = glob.list(root: 'test');
  await for (final entity in entities) {
    await entity.delete();
  }
}

void main() {
  group('RenderTests run tests', () {
    Renderer<String> renderer = new MarkdownRenderer();
    RendererTests tests = new RendererTests(renderer, '**.markdown');

    group('run tests', () {
      setUp(tests.rebaselineAll);
      tests.runTests();
    });

    group('baseline tests', () {
      setUp(deleteExpectedFiles);

      test('rebaseline', () async {
        const testName = 'stylingText.markdown';

        await tests.rebaseline(testFilePath(testName));
        final result =
            await new File(expectedFilePath(testName)).readAsString();
        expect(result, equals('''
<p><em>This text will be italic</em>
<strong>This text will be bold</strong></p>
'''));
      });

      test('rebaselineAll', () async {
        final testNames = [
          'stylingText.markdown',
          'blockquotes.markdown',
          'headings.markdown'
        ];

        await tests.rebaselineAll();

        for (final testName in testNames) {
          final file = new File(expectedFilePath(testName));
          expect(await file.exists(), isTrue);
        }
      });

      tearDown(deleteExpectedFiles);
    });
  });
}
