import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

/// Service class to handle Firebase Authentication and Database operations
class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  /// Get current user
  User? get currentUser => _auth.currentUser;

  /// Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Sign in with email and password
  Future<UserCredential> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Register with email and password
  Future<UserCredential> registerWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Write data to Realtime Database
  Future<void> writeData(String path, Map<String, dynamic> data) async {
    try {
      await _database.child(path).set(data);
    } catch (e) {
      rethrow;
    }
  }

  /// Update data in Realtime Database
  Future<void> updateData(String path, Map<String, dynamic> data) async {
    try {
      await _database.child(path).update(data);
    } catch (e) {
      rethrow;
    }
  }

  /// Read data from Realtime Database (one-time)
  Future<DataSnapshot> readData(String path) async {
    try {
      return await _database.child(path).get();
    } catch (e) {
      rethrow;
    }
  }

  /// Listen to data changes in Realtime Database
  Stream<DatabaseEvent> listenToData(String path) {
    return _database.child(path).onValue;
  }

  /// Delete data from Realtime Database
  Future<void> deleteData(String path) async {
    try {
      await _database.child(path).remove();
    } catch (e) {
      rethrow;
    }
  }
}
