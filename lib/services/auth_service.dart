import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../utils/exceptions.dart';
import '../utils/result.dart';
import '../utils/app_constants.dart';
import '../utils/logger.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Get current user model with role
  Future<Result<UserModel>> getCurrentUserModel() async {
    try {
      final user = currentUser;
      if (user == null) {
        return Result.failure('User tidak ditemukan');
      }

      final doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(user.uid)
          .get();

      if (doc.exists) {
        final userModel = UserModel.fromMap(doc.data()!);
        AppLogger.d('User model loaded successfully: ${userModel.email}');
        return Result.success(userModel);
      }

      return Result.failure('Data user tidak ditemukan');
    } on FirebaseException catch (e, stackTrace) {
      AppLogger.e('Error getting user model', e, stackTrace);
      return Result.failure(
        FirestoreException.fromError(e).message,
        errorCode: e.code,
      );
    } catch (e, stackTrace) {
      AppLogger.e('Unexpected error getting user model', e, stackTrace);
      return Result.failure('Terjadi kesalahan: ${e.toString()}');
    }
  }

  // Register new user
  Future<Result<UserModel>> register({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    try {
      AppLogger.i('Attempting to register user: $email');

      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = result.user;
      if (user == null) {
        return Result.failure('Gagal membuat user');
      }

      // Create user document in Firestore
      final userModel = UserModel(
        uid: user.uid,
        email: email,
        name: name,
        role: role,
        createdAt: DateTime.now(),
      );

      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(user.uid)
          .set(userModel.toMap());

      // Auto-create PatientProfile if role is patient
      if (role == AppConstants.rolePatient) {
        AppLogger.i('Creating patient profile for: $email');

        // Import statement needed at top: import '../models/patient_profile.dart';
        final patientProfile = {
          'id': user.uid,
          'userId': user.uid,
          'name': name,
          'age': 0, // Will be updated later
          'bloodType': 'A+', // Default, will be updated later
          'allergies': [],
          'emergencyContact': '',
          'insuranceNumber': '',
          'photoUrl': null,
        };

        await _firestore
            .collection(AppConstants.patientsCollection)
            .doc(user.uid)
            .set(patientProfile);

        AppLogger.i('Patient profile created successfully');
      }

      AppLogger.i('User registered successfully: $email');
      return Result.success(userModel);
    } on FirebaseAuthException catch (e, stackTrace) {
      AppLogger.e('Firebase Auth error during registration', e, stackTrace);
      final authException = AuthException.fromFirebaseError(e.code);
      return Result.failure(authException.message, errorCode: e.code);
    } on FirebaseException catch (e, stackTrace) {
      AppLogger.e('Firestore error during registration', e, stackTrace);
      return Result.failure(
        'Gagal menyimpan data user: ${e.message}',
        errorCode: e.code,
      );
    } catch (e, stackTrace) {
      AppLogger.e('Unexpected error during registration', e, stackTrace);
      return Result.failure('Terjadi kesalahan: ${e.toString()}');
    }
  }

  // Login
  Future<Result<UserModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      AppLogger.i('Attempting to login user: $email');

      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = result.user;
      if (user == null) {
        return Result.failure('Login gagal');
      }

      AppLogger.i('User logged in successfully: $email');
      return await getCurrentUserModel();
    } on FirebaseAuthException catch (e, stackTrace) {
      AppLogger.e('Firebase Auth error during login', e, stackTrace);
      final authException = AuthException.fromFirebaseError(e.code);
      return Result.failure(authException.message, errorCode: e.code);
    } catch (e, stackTrace) {
      AppLogger.e('Unexpected error during login', e, stackTrace);
      return Result.failure('Terjadi kesalahan: ${e.toString()}');
    }
  }

  // Logout
  Future<Result<void>> logout() async {
    try {
      AppLogger.i('User logging out');
      await _auth.signOut();
      AppLogger.i('User logged out successfully');
      return Result.success(null);
    } catch (e, stackTrace) {
      AppLogger.e('Error during logout', e, stackTrace);
      return Result.failure('Gagal logout: ${e.toString()}');
    }
  }

  // Reset password
  Future<Result<void>> resetPassword(String email) async {
    try {
      AppLogger.i('Sending password reset email to: $email');
      await _auth.sendPasswordResetEmail(email: email);
      AppLogger.i('Password reset email sent successfully');
      return Result.success(null);
    } on FirebaseAuthException catch (e, stackTrace) {
      AppLogger.e('Error sending password reset email', e, stackTrace);
      final authException = AuthException.fromFirebaseError(e.code);
      return Result.failure(authException.message, errorCode: e.code);
    } catch (e, stackTrace) {
      AppLogger.e('Unexpected error during password reset', e, stackTrace);
      return Result.failure('Gagal mengirim email: ${e.toString()}');
    }
  }
}
