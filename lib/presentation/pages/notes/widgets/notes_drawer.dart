import 'package:flutter/material.dart';
import 'package:notes/constants/palette.dart';
import 'package:notes/constants/style.dart';
import 'package:notes/presentation/pages/notes/widgets/add_note_icon.dart';

import 'notes_title_bar.dart';

class NotesDrawer extends StatelessWidget {
  const NotesDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const _DrawerIconBar(),
            const Divider(
              color: kPrimaryColor,
              height: kDividerWidth,
              thickness: kDividerWidth,
            ),
            Expanded(
                child: NotesTitleBar(
                    afterNoteSelected: (note) => Navigator.pop(context))),
          ],
        ),
      ),
    );
  }
}

class _DrawerIconBar extends StatelessWidget {
  const _DrawerIconBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      color: kBackgroundColor,
      child: Material(
        color: kBackgroundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.menu,
                  size: 25,
                )),
            const AddNoteIcon(),
          ],
        ),
      ),
    );
  }
}
