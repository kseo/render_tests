# render_tests

A regression test framework for Dart.

render_tests performs regression tests by comparing the rendered output against an expected output file. It also provides an easy way to create expected output files (called rebaselining).

## Usage

Let's create regression tests for `markdownToHtml` function from [markdown][markdown] package.

The first thing you need to do is to implement `Renderer<T>` instance. render_tests uses it to generate an output from the given file. You can implement `Renderer<T>` by overriding `render` method with a call to `markdownToHtml`. Here, StringRenderer is a synonym for `Renderer<String>`.

```dart
class MarkdownRenderer implements StringRenderer {
  String render(String input) => markdownToHtml(input);
}
```

Once you have a `Renderer<T>`, you can construct a `RendererTests` instance from it. The second argument of the `RendererTests` is a [glob][glob] pattern which specifies the input files. Let's grab every file with `markdown` extension.

```dart
Renderer<String> renderer = new MarkdownRenderer();
RendererTests tests = new RendererTests(renderer, '**.markdown');
```
 
If you run the test for the first time, you don't yet have the expected outputs to compare. You can create the expected outputs using `rebaseline` or `rebaselineAll`. If glob pattern matches `foo.markdown`, rebaselining will generate `foo.markdown.expected` file in the same directory as `foo.markdown`. Later, render_tests will use these expected outputs to find regression bugs. Don't forget to add these files to your VCS.

NOTE: render_tests does not provide a script to perform rebaselining because you need to create your own `RendererTests` instance with your custom `Renderer<T>`. I recommend you to create a small script which helps you perform rebaselining easily.

```dart
tests.rebaselineAll();
```

Now you are ready to perform regression tests. Let's assume you made a few changes to `markdownToHtml` function and want to make sure that it didn't introduce any regression bug. You can register tests using `runTests` functions. Just create a test group and call `runTests` in it. render_tests compares the rendered result with the expected output and check if they are still the same.

```dart
group('markdownToHtml tests', () {
  tests.runTests();
});
```

`example/base64encoder_tests.dart` is another example you can reference. The script provides commands to run tests and perform rebaselining.

```
base64encoder tests

Usage: base64encoder_tests <command> [arguments]

Global options:
-h, --help    Print this usage information.

Available commands:
  help         Display help information for base64encoder_tests.
  rebaseline   rebaseline the tests
  run          run the tests

Run "base64encoder_tests help <command>" for more information about a command.
```

[markdown]: https://pub.dartlang.org/packages/markdown
[glob]: https://pub.dartlang.org/packages/glob

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/kseo/render_tests/issues
