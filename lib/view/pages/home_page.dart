import 'dart:io';

import 'package:contacts/controller/contact_provider.dart';
import 'package:contacts/models/contact_model.dart';
import 'package:contacts/view/pages/add_contacts_page.dart';
import 'package:contacts/view/pages/view_contact_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  void addContact(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const AddContactsPage()));
  }

  void callContact(int number) {
    FlutterPhoneDirectCaller.callNumber(number.toString());
  }

  void openEditPage(BuildContext context, int index, Contact contact) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddContactsPage(
            index: index,
            contact: contact,
          ),
        ));
  }

  void openViewPage(BuildContext context, int index, Contact contact) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ViewContactPage(
            index: index,
            contact: contact,
          ),
        ));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        actions: [
          IconButton(
            onPressed: () => addContact(context),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: ref.watch(contactProvider).length,
        itemBuilder: (context, index) {
          final contact = ref.watch(contactProvider)[index];

          return GestureDetector(
            onTap: () => openViewPage(context, index, contact),
            child: ListTile(
              title: Text(contact.name),
              subtitle: Text(contact.phone.toString()),
              leading: CircleAvatar(
                backgroundImage: contact.image != null
                    ? FileImage(File(contact.image!))
                    : null,
                child: contact.image == null
                    ? Text(contact.name[0].toUpperCase())
                    : null,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => callContact(contact.phone),
                    icon: const Icon(Icons.call),
                  ),
                  IconButton(
                    onPressed: () => openEditPage(context, index, contact),
                    icon: const Icon(Icons.edit),
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 16),
      ),
    );
  }
}
