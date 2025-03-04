import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventure/core/utils/theme/colors.dart';
import 'package:eventure/features/admin_Dashboard/presentation/widgets/event_textfield.dart';
import 'package:eventure/features/admin_Dashboard/presentation/widgets/number_input.dart';
import 'package:flutter/material.dart';

class AddEvent extends StatefulWidget {
  const AddEvent({super.key});

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController addressController = TextEditingController();
  TextEditingController coverController = TextEditingController();
  TextEditingController dateTimeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController seatsController = TextEditingController();
  TextEditingController titleController = TextEditingController();

  Future<void> _pickDateTime(BuildContext context) async {
    FocusScope.of(context).unfocus();

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
          dateTimeController.text =
              "${date.toLocal()} - ${time.format(context)}";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: kMainDark,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 120),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                SizedBox(
                  height: 50,
                ),
                Center(
                  child: Text(
                    "Create New Event",
                    style: TextStyle(
                        fontSize: 30,
                        color: white,
                        fontWeight: FontWeight.w900),
                  ),
                ),
                SizedBox(
                  height: 70,
                ),
                // Image Picker Placeholder
                Container(
                  height: 120,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.purple.shade700,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.purpleAccent, width: 1),
                  ),
                  child: const Center(
                    child: Icon(Icons.image, size: 50, color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomEventTextField(
                        hint: "Enter event title",
                        controller: titleController,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: CustomEventTextField(
                        hint: "Select Date & Time",
                        controller: dateTimeController,
                        icon: Icons.calendar_today,
                        readOnly: true,
                        onTap: () => _pickDateTime(context),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomEventTextField(
                          hint: "Location 'URL'",
                          controller: locationController,
                          icon: Icons.location_on),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: CustomEventTextField(
                        hint: "Price (\$)",
                        controller: priceController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomEventTextField(
                        hint: "address",
                        controller: addressController,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: NumericStepperField(
                        hint: "Number of Seats",
                        controller: seatsController,
                        icon: Icons.chair,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomEventTextField(
                        hint: "Enter event details",
                        controller: descriptionController,
                        maxLines: 5,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    height: 50,
                    child: FilledButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            var db = FirebaseFirestore.instance;
                            final data = {
                              "id": db.collection("events").doc().id,
                              "address": addressController.text,
                              "title": titleController.text,
                              "seats": int.tryParse(seatsController.text) ?? 0,
                              "dateTime": Timestamp.fromDate(
                                  DateTime.tryParse(dateTimeController.text) ??
                                      DateTime.now()),
                              "description": descriptionController.text,
                              "price": priceController.text,
                              "location": locationController.text,
                              "cover": coverController.text,
                              "registeredUsers": [],
                            };

                            db
                                .collection("events")
                                .add(data)
                                .then((documentSnapshot) {
                              addressController.clear();
                              titleController.clear();
                              seatsController.clear();
                              dateTimeController.clear();
                              descriptionController.clear();
                              priceController.clear();
                              locationController.clear();
                              coverController.clear();

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("New Event Created Successfuly"),
                                backgroundColor: Colors.green,
                              ));
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kButton2,
                        ),
                        child: Text(
                          "Create Event",
                          style: TextStyle(
                              color: white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        )),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    addressController.dispose();
    coverController.dispose();
    dateTimeController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    priceController.dispose();
    seatsController.dispose();
    super.dispose();
  }
}
