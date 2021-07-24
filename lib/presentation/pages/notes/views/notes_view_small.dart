import 'package:flutter/material.dart';
import 'package:notes/constants/palette.dart';
import 'package:notes/constants/style.dart';
import 'package:notes/presentation/pages/notes/widgets/note_content.dart';
import 'package:notes/presentation/pages/notes/widgets/notes_drawer.dart';

class NotesViewSmall extends StatelessWidget {
  const NotesViewSmall({Key? key}) : super(key: key);

  AppBar _appBar(BuildContext context) {
    return AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'My awesome Notepad',
          style: TextStyle(color: kPrimaryColor),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kDividerWidth),
          child: Container(
            color: kPrimaryColor,
            height: kDividerWidth,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(context),
        drawer: const NotesDrawer(),
        body: Column(
          children: const [
            Expanded(
              child: NoteContent(),
            )
          ],
        ));
  }
}
