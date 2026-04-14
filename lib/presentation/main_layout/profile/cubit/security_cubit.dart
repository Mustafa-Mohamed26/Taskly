import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:local_auth/local_auth.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import '../../../../core/service/cache_helper.dart';
import '../../../../domain/repositories/auth_repository.dart';
import 'security_state.dart';

@injectable
class SecurityCubit extends Cubit<SecurityState> {
  final LocalAuthentication _auth = LocalAuthentication();
  final AuthRepository _authRepository;

  SecurityCubit(this._authRepository) : super(SecurityState.initial());

  Future<void> init() async {
    final bioEnabled = CacheHelper.getBiometricEnabled();
    final hideNotifications = CacheHelper.getHideNotificationsEnabled();
    
    final isSupported = await _auth.isDeviceSupported();
    final canCheckBiometrics = await _auth.canCheckBiometrics;

    emit(state.copyWith(
      biometricEnabled: bioEnabled,
      hideNotificationsEnabled: hideNotifications,
      isBiometricSupported: isSupported && canCheckBiometrics,
    ));
  }

  Future<void> toggleBiometric(bool value) async {
    if (value) {
      // Authenticate before enabling
      try {
        final authenticated = await _auth.authenticate(
          localizedReason: 'Please authenticate to enable biometric lock',
          biometricOnly: true,
          persistAcrossBackgrounding: true,
        );

        if (authenticated) {
          await CacheHelper.setBiometricEnabled(true);
          emit(state.copyWith(biometricEnabled: true));
        }
      } catch (e) {
        emit(state.copyWith(errorMessage: 'Authentication failed: $e'));
      }
    } else {
      await CacheHelper.setBiometricEnabled(false);
      emit(state.copyWith(biometricEnabled: false));
    }
  }

  Future<void> toggleHideNotifications(bool value) async {
    await CacheHelper.setHideNotificationsEnabled(value);
    emit(state.copyWith(hideNotificationsEnabled: value));
  }

  Future<void> openAppSettings() async {
    await ph.openAppSettings();
  }

  Future<void> deleteAccount(String uid) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      await _authRepository.deleteAccount(uid);
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
