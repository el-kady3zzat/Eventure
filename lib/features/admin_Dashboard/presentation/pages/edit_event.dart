import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventure/core/utils/theme/colors.dart';
import 'package:eventure/features/admin_Dashboard/model/firestore_event_model.dart';
import 'package:eventure/features/admin_Dashboard/presentation/pages/events_screen.dart';
import 'package:eventure/features/admin_Dashboard/presentation/widgets/event_textfield.dart';
import 'package:eventure/features/admin_Dashboard/presentation/widgets/number_input.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class EditEvent extends StatefulWidget {
  final FSEvent event;

  const EditEvent({super.key, required this.event});

  @override
  State<EditEvent> createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  final _formKey = GlobalKey<FormState>();
  Uint8List? _webImage;
  DateTime? selectedDateTime;
  late TextEditingController titleController;
  late TextEditingController dateTimeController;
  late TextEditingController descriptionController;
  late TextEditingController locationController;
  late TextEditingController priceController;
  late TextEditingController seatsController;
  late TextEditingController addressController;
  late TextEditingController coverController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.event.title);
    selectedDateTime = widget.event.dateTime; // Set initial date value
    dateTimeController = TextEditingController(
        text: DateFormat('yyyy-MM-dd HH:mm').format(selectedDateTime!));
    descriptionController =
        TextEditingController(text: widget.event.description);
    locationController = TextEditingController(text: widget.event.location);
    priceController =
        TextEditingController(text: widget.event.price.toString());
    seatsController =
        TextEditingController(text: widget.event.seats.toString());
    addressController = TextEditingController(text: widget.event.address);
    coverController = TextEditingController(text: widget.event.cover ?? '');
  }

  Future<void> _pickDateTime(BuildContext context) async {
    DateTime? date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (time != null) {
        setState(() {
          selectedDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
          dateTimeController.text =
              DateFormat('yyyy-MM-dd HH:mm').format(selectedDateTime!);
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      Uint8List imageBytes = await pickedFile.readAsBytes();
      setState(() {
        _webImage = imageBytes;
        coverController.text = base64Encode(imageBytes);
      });
    }
  }

  Future<void> _updateEvent() async {
    if (_formKey.currentState!.validate()) {
      FirebaseFirestore.instance
          .collection("events")
          .doc(widget.event.id)
          .update({
        "title": titleController.text,
        "dateTime": Timestamp.fromDate(selectedDateTime!),
        "description": descriptionController.text,
        "location": locationController.text,
        "price": double.tryParse(priceController.text) ?? 0.0,
        "seats": int.tryParse(seatsController.text) ?? 0,
        "address": addressController.text,
        "cover": coverController.text,
      }).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Event updated successfully!")),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => EventsScreen(),
          ),
          (route) => false,
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error updating event: $error")),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainDark,
      appBar: AppBar(title: Text("Edit Event")),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 200),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 120,
                  width: 250,
                  decoration: BoxDecoration(
                    color: kMainLight,
                    borderRadius: BorderRadius.circular(12),
                    image: _webImage != null
                        ? DecorationImage(
                            image: MemoryImage(_webImage!), fit: BoxFit.cover)
                        : widget.event.cover != null
                            ? DecorationImage(
                                image: NetworkImage(widget.event.cover!),
                                fit: BoxFit.cover)
                            : null,
                  ),
                  child: _webImage == null && widget.event.cover == null
                      ? const Center(
                          child:
                              Icon(Icons.image, size: 50, color: Colors.white))
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              CustomEventTextField(
                hint: "Enter event title",
                controller: titleController,
              ),
              const SizedBox(height: 20),
              CustomEventTextField(
                hint: "Select Date & Time",
                controller: dateTimeController,
                icon: Icons.calendar_today,
                readOnly: true,
                onTap: () => _pickDateTime(context),
              ),
              const SizedBox(height: 20),
              CustomEventTextField(
                  hint: "Location 'URL'", controller: locationController),
              const SizedBox(height: 20),
              CustomEventTextField(
                  hint: "Price (\$)",
                  controller: priceController,
                  keyboardType: TextInputType.number),
              const SizedBox(height: 20),
              CustomEventTextField(
                hint: "Address",
                controller: addressController,
              ),
              const SizedBox(height: 20),
              NumericStepperField(
                hint: "Number of Seats",
                controller: seatsController,
              ),
              const SizedBox(height: 20),
              CustomEventTextField(
                  hint: "Enter event details",
                  controller: descriptionController,
                  maxLines: 5),
              const SizedBox(height: 40),
              SizedBox(
                height: 50,
                child: FilledButton(
                  onPressed: _updateEvent,
                  style: ElevatedButton.styleFrom(backgroundColor: kButton2),
                  child: const Text(
                    "Save Changes",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    dateTimeController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    priceController.dispose();
    seatsController.dispose();
    addressController.dispose();
    coverController.dispose();
    super.dispose();
  }
}
