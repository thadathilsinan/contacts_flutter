import 'dart:io';

import 'package:contacts/controller/contact_provider.dart';
import 'package:contacts/models/contact_model.dart';
import 'package:contacts/utils/snackbar_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class AddContactsPage extends ConsumerStatefulWidget {
  final int? index;
  final Contact? contact;

  const AddContactsPage({
    super.key,
    this.index,
    this.contact,
  });

  @override
  ConsumerState<AddContactsPage> createState() => _AddContactsPageState();
}

class _AddContactsPageState extends ConsumerState<AddContactsPage> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  String? imagePath;

  @override
  void initState() {
    if (widget.contact != null) {
      imagePath = widget.contact!.image;
      nameController.text = widget.contact!.name;
      phoneController.text = widget.contact!.phone.toString();
      emailController.text = widget.contact!.email;
    }

    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();

    super.dispose();
  }

  void saveContact(BuildContext context, WidgetRef ref) {
    if (formKey.currentState!.validate()) {
      final name = nameController.text;
      final phone = phoneController.text;
      final email = emailController.text;

      String? error;
      if (widget.index != null) {
        error = ref.read(contactProvider.notifier).updateContact(
              index: widget.index!,
              name: name,
              phone: phone,
              email: email,
              imagePath: imagePath,
            );
      } else {
        error = ref.read(contactProvider.notifier).addContact(
              name: name,
              phone: phone,
              email: email,
              imagePath: imagePath,
            );
      }

      if (error == null) {
        Navigator.pop(context);
      } else {
        SnackbarUtil.showMessage(context, error);
      }
    }
  }

  void pickImage(BuildContext context) async {
    final imagePicker = ImagePicker();
    final imagePath = await imagePicker.pickImage(source: ImageSource.gallery);

    if (imagePath != null) {
      setState(() {
        this.imagePath = imagePath.path;
      });
    } else {
      Future.sync(() => SnackbarUtil.showMessage(context, 'No image selected'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.index == null ? 'Add contact' : 'Edit Contact'),
        actions: [
          IconButton(
            onPressed: () => saveContact(context, ref),
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(36),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: () => pickImage(context),
                child: CircleAvatar(
                  radius: 56,
                  backgroundImage:
                      imagePath != null ? FileImage(File(imagePath!)) : null,
                ),
              ),
              TextFormField(
                controller: nameController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter name';
                  }

                  return null;
                },
                decoration: const InputDecoration(
                  hintText: 'Name',
                ),
                keyboardType: TextInputType.name,
              ),
              TextFormField(
                controller: phoneController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter phone number';
                  }

                  if (value.length < 10) {
                    return 'Number should be atleast 10 digits';
                  }

                  return null;
                },
                decoration: const InputDecoration(
                  hintText: 'Phone',
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.phone,
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
