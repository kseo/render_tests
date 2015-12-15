// Copyright (c) 2015, Kwang Yul Seo. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of render_tests;

abstract class Renderer<T> {
  T render(String input);
}

abstract class StringRenderer implements Renderer<String> {
  String render(String input);
}

abstract class BufferedStringRenderer implements StringRenderer {
  String render(String input) {
    final buffer = new StringBuffer();
    renderToBuffer(input, buffer);
    return buffer;
  }

  void renderToBuffer(String input, StringBuffer buffer);
}
