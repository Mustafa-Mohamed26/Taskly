import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import '../../models/user_model.dart';
import '../auth_data_source.dart';
import '../../../core/error/auth_exception.dart';
import '../../../core/utils/auth_exception_handler.dart';

@Injectable(as: AuthDataSource)
class FirebaseAuthDataSourceImpl implements AuthDataSource {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

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

  @override
  Future<UserModel> loginWithGoogle() async {
    try {
      // 1. Trigger the Google Authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw AuthException('Google Sign-In was cancelled by the user.');
      }

      // 2. Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // 3. Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4. Sign in to Firebase with the credential
      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user == null) {
        throw AuthException('Failed to retrieve user information from Google.');
      }

      // 5. Prepare User Model
      // Note: We only set createdAt if it's a new user (optional, but good for database hygiene)
      final userModel = UserModel(
        id: user.uid,
        email: user.email ?? '',
        name: user.displayName ?? 'Google User',
      );

      // 6. Sync to Firestore (always merge to ensure we have the latest user data)
      await saveUserProfile(userModel);

      return userModel;
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException(AuthExceptionHandler.handleException(e));
    }
  }
}
