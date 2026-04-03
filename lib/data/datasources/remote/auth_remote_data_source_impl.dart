import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import '../../models/user_model.dart';
import '../auth_data_source.dart';
import '../../../core/error/auth_exception.dart';
import '../../../core/utils/auth_exception_handler.dart';

@Injectable(as: AuthDataSource)
class FirebaseAuthDataSourceImpl implements AuthDataSource {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return UserModel.fromFirebaseUser(userCredential.user!);
    } catch (e) {
      throw AuthException(AuthExceptionHandler.handleException(e));
    }
  }

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      await userCredential.user!.updateDisplayName(name);
      await userCredential.user!.reload();
      final updatedUser = _firebaseAuth.currentUser!;
      final userModel = UserModel.fromFirebaseUser(updatedUser);
      
      await saveUserProfile(userModel);
      
      return userModel;
    } catch (e) {
      throw AuthException(AuthExceptionHandler.handleException(e));
    }
  }

  @override
  Future<void> saveUserProfile(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).set(
        user.toJson(),
        SetOptions(merge: true),
      );
    } catch (e) {
      throw AuthException('Failed to sync user data to Firestore: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw AuthException(AuthExceptionHandler.handleException(e));
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw AuthException(AuthExceptionHandler.handleException(e));
    }
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((user) {
      return user != null ? UserModel.fromFirebaseUser(user) : null;
    });
  }

  @override
  Future<UserModel?> get currentAuthenticatedUser async {
    final user = _firebaseAuth.currentUser;
    return user != null ? UserModel.fromFirebaseUser(user) : null;
  }
}
