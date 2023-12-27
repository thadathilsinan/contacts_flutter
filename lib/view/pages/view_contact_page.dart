import 'dart:io';

import 'package:contacts/controller/contact_provider.dart';
import 'package:contacts/models/contact_model.dart';
import 'package:contacts/utils/snackbar_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ViewContactPage extends ConsumerWidget {
  final int index;
  final Contact contact;

  const ViewContactPage({
    super.key,
    required this.index,
    required this.contact,
  });

  void deleteContact(BuildContext context, WidgetRef ref) {
    final error = ref.read(contactProvider.notifier).removeContact(index);

    if (error == null) {
      Navigator.pop(context);
    } else {
      SnackbarUtil.showMessage(context, error);
    }
  }

  void callContact() {
    FlutterPhoneDirectCaller.callNumber(contact.phone.toString());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(contact.name),
        actions: [
          IconButton(
            onPressed: () => callContact(),
            icon: const Icon(Icons.call),
          ),
          IconButton(
            onPressed: () => deleteContact(context, ref),
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 56,
                backgroundImage: contact.image != null
                    ? FileImage(File(contact.image!))
                    : null,
              ),
            ),
            const SizedBox(height: 36),
            const Text('Phone'),
            ListTile(
              title: Text(
                contact.phone.toString(),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Email'),
            ListTile(
              title: Text(
                contact.email.isEmpty ? 'Not available' : contact.email,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
