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
  Future<UserModel?> getUserProfile(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        return UserModel.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      throw AuthException('Failed to fetch user profile: ${e.toString()}');
    }
  }

  @override
  Future<void> updateUserProfile({
    required String uid,
    String? name,
    String? phone,
    String? bio,
  }) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null && user.uid == uid && name != null) {
        await user.updateDisplayName(name);
        await user.reload();
      }

      final Map<String, dynamic> updates = {};
      if (name != null) updates['name'] = name;
      if (phone != null) updates['phone'] = phone;
      if (bio != null) updates['bio'] = bio;

      if (updates.isNotEmpty) {
        await _firestore.collection('users').doc(uid).set(
          updates,
          SetOptions(merge: true),
        );
      }
    } catch (e) {
      throw AuthException('Failed to update user profile: ${e.toString()}');
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
    return _firebaseAuth.authStateChanges().asyncMap((user) async {
      if (user != null) {
        final profile = await getUserProfile(user.uid);
        if (profile != null) {
          return UserModel(
            id: user.uid,
            email: user.email ?? profile.email,
            name: user.displayName ?? profile.name,
            photoUrl: user.photoURL ?? profile.photoUrl,
            phone: profile.phone,
            bio: profile.bio,
          );
        }
        return UserModel.fromFirebaseUser(user);
      }
      return null;
    });
  }

  @override
  Future<UserModel?> get currentAuthenticatedUser async {
    final user = _firebaseAuth.currentUser;
    return user != null ? UserModel.fromFirebaseUser(user) : null;
  }
}
