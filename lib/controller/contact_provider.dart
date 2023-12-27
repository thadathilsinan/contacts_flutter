import 'package:contacts/models/contact_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ContactNotifier extends Notifier<List<Contact>> {
  @override
  List<Contact> build() {
    return [];
  }

  /// Add new contact
  String? addContact({
    required String name,
    required String phone,
    required String email,
    String? imagePath,
  }) {
    try {
      final updatedContacts = [...state];
      updatedContacts.add(Contact(
        name: name,
        email: email,
        image: imagePath,
        phone: int.parse(phone),
      ));

      state = updatedContacts;
      return null;
    } catch (e) {
      return 'Cannot add contact. Please try again';
    }
  }

  /// Remove contact
  String? removeContact(int index) {
    try {
      final updatedContacts = [...state];
      updatedContacts.removeAt(index);

      state = updatedContacts;
    } catch (e) {
      return 'Cannot remove contact. Please try again';
    }

    return null;
  }

  /// Update contact
  String? updateContact({
    required int index,
    required String name,
    required String phone,
    required String email,
    String? imagePath,
  }) {
    try {
      final updatedContacts = [...state];
      updatedContacts[index] = Contact(
        name: name,
        email: email,
        image: imagePath,
        phone: int.parse(phone),
      );

      state = updatedContacts;
    } catch (e) {
      return 'Cannot update contact. Please try again';
    }

    return null;
  }
}

final contactProvider = NotifierProvider<ContactNotifier, List<Contact>>(
  () => ContactNotifier(),
);
