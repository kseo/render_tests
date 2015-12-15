// Copyright (c) 2015, Kwang Yul Seo. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of render_tests;

class RendererTests {
  static const String _expectedResultExtension = 'expected';

  final Glob _glob;
  final Renderer _renderer;
  final String _root;

  final bool _followLinks;
  final bool _verbose;

  Stream<FileSystemEntity> get _entities =>
      _glob.list(root: _root, followLinks: _followLinks);

  List<FileSystemEntity> get _entitiesSync =>
      _glob.listSync(root: _root, followLinks: _followLinks);

  RendererTests(this._renderer, String globPattern,
      {String root, bool followLinks: true, bool verbose: false})
      : _root = root ?? path.current,
        _glob = new Glob(globPattern),
        _followLinks = followLinks,
        _verbose = verbose;

  void runTests() {
    group('RendererTests', () {
      for (final entity in _entitiesSync) {
        test('${entity.path}', () async {
          final expectedFile = '${entity.path}.$_expectedResultExtension';

          final contents = await new File(entity.path).readAsString();
          final expected = await new File(expectedFile).readAsString();
          final actual = _renderer.render(contents);
          expect(actual, expected);
        });
      }
    });
  }

  Future<Null> rebaselineAll([String path]) async {
    await for (final entity in _entities) {
      await rebaseline(entity.path);
    }
  }

  Future<Null> rebaseline(String path) async {
    final contents = await new File(path).readAsString();
    final actual = _renderer.render(contents);
    final expectedFile = '${path}.$_expectedResultExtension';

    if (_verbose) {
      print('Generating $expectedFile');
    }
    await new File(expectedFile).writeAsString(actual);
  }
}
