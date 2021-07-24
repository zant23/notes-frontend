import 'package:flutter/material.dart';
import 'package:notes/constants/palette.dart';
import 'package:notes/constants/style.dart';
import 'package:notes/presentation/pages/notes/widgets/add_note_icon.dart';
import 'package:notes/presentation/pages/notes/widgets/note_content.dart';
import 'package:notes/presentation/pages/notes/widgets/notes_title_bar.dart';

class NotesViewLarge extends StatelessWidget {
  const NotesViewLarge({Key? key}) : super(key: key);

  AppBar _appBar(BuildContext context) {
    return AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: const AddNoteIcon(),
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
        body: Column(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Flexible(child: NotesTitleBar()),
                  VerticalDivider(
                    color: kPrimaryColor,
                    width: kDividerWidth,
                    thickness: kDividerWidth,
                  ),
                  Flexible(flex: 4, child: NoteContent())
                ],
              ),
            )
          ],
        ));
  }
}
