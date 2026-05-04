import 'package:flutter_quill/flutter_quill.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:markdown_quill/markdown_quill.dart';

extension StringMarkdownX on String {
  Document toDelta() {
    final mdDocument = md.Document(encodeHtml: false);

    final mdToDelta = MarkdownToDelta(markdownDocument: mdDocument);

    final delta = mdToDelta.convert(this);

    return Document.fromDelta(delta);
  }
}

extension DeltaMarkdownX on Document {
  String toMarkdown() {
    final deltaToMd = DeltaToMarkdown();

    return deltaToMd.convert(toDelta());
  }
}
