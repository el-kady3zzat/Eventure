import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel?> login(String email, String password) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    return _getUserData(userCredential.user?.uid);
  }

  Future<UserModel?> signup(String email, String password, String name, String phone) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final user = UserModel(
      id: userCredential.user!.uid,
      name: name,
      email: email,
      password: password,
      phone: phone,
      location: '', // Default empty value
      role: 'client', // Default role
      image: '', // Default empty value
      bookedEvents: [], // Empty list initially
      favEvents: [], // Empty list initially
      savedEvents: [],  // Empty list initially
    );

    await _firestore.collection('users').doc(user.id).set(user.toMap());
    return user;
  }

  Future<UserModel?> _getUserData(String? uid) async {
    if (uid == null) return null;
    DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();
    return userDoc.exists ? UserModel.fromFirestore(userDoc) : null;
  }

  // Optional: Add method to update user data
  Future<void> updateUserData(UserModel user) async {
    await _firestore.collection('users').doc(user.id).update(user.toMap());
  }

  // Optional: Add method to update specific user fields
  Future<void> updateUserField(String uid, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(uid).update(data);
  }

  // Optional: Add methods for managing events lists
  Future<void> addToBookedEvents(String uid, String eventId) async {
    await _firestore.collection('users').doc(uid).update({
      'bookedEvents': FieldValue.arrayUnion([eventId])
    });
  }

  Future<void> addToFavEvents(String uid, String eventId) async {
    await _firestore.collection('users').doc(uid).update({
      'favEvents': FieldValue.arrayUnion([eventId])
    });
  }

  Future<void> addToSavedEvents(String uid, String eventId) async {
    await _firestore.collection('users').doc(uid).update({
      'savedEvents': FieldValue.arrayUnion([eventId])
    });
  }

  Future<void> removeFromBookedEvents(String uid, String eventId) async {
    await _firestore.collection('users').doc(uid).update({
      'bookedEvents': FieldValue.arrayRemove([eventId])
    });
  }

  Future<void> removeFromFavEvents(String uid, String eventId) async {
    await _firestore.collection('users').doc(uid).update({
      'favEvents': FieldValue.arrayRemove([eventId])
    });
  }

  Future<void> removeFromSavedEvents(String uid, String eventId) async {
    await _firestore.collection('users').doc(uid).update({
      'savedEvents': FieldValue.arrayRemove([eventId])
    });
  }
}