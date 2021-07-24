import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:notes/constants/style.dart';
import 'package:notes/presentation/pages/notes/views/notes_view_large.dart';
import 'package:notes/presentation/pages/notes/views/notes_view_small.dart';

class NotesPage extends HookWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constrains) {
        if (constrains.maxWidth < kMaxMobileWidth) {
          return const NotesViewSmall();
        } else {
          return const NotesViewLarge();
        }
      },
    );
  }
}
