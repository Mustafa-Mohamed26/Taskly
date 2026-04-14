import 'package:equatable/equatable.dart';

class SecurityState extends Equatable {
  final bool biometricEnabled;
  final bool hideNotificationsEnabled;
  final bool isBiometricSupported;
  final bool isLoading;
  final String? errorMessage;

  const SecurityState({
    required this.biometricEnabled,
    required this.hideNotificationsEnabled,
    required this.isBiometricSupported,
    this.isLoading = false,
    this.errorMessage,
  });

  factory SecurityState.initial() {
    return const SecurityState(
      biometricEnabled: false,
      hideNotificationsEnabled: false,
      isBiometricSupported: false,
    );
  }

  SecurityState copyWith({
    bool? biometricEnabled,
    bool? hideNotificationsEnabled,
    bool? isBiometricSupported,
    bool? isLoading,
    String? errorMessage,
  }) {
    return SecurityState(
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      hideNotificationsEnabled: hideNotificationsEnabled ?? this.hideNotificationsEnabled,
      isBiometricSupported: isBiometricSupported ?? this.isBiometricSupported,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        biometricEnabled,
        hideNotificationsEnabled,
        isBiometricSupported,
        isLoading,
        errorMessage,
      ];
}
