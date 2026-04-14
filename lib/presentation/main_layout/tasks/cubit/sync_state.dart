import 'package:equatable/equatable.dart';

enum SyncStatus { initial, syncing, success, error }

class SyncState extends Equatable {
  final SyncStatus status;
  final String? lastSyncedAt;
  final String? errorMessage;

  const SyncState({
    this.status = SyncStatus.initial,
    this.lastSyncedAt,
    this.errorMessage,
  });

  SyncState copyWith({
    SyncStatus? status,
    String? lastSyncedAt,
    String? errorMessage,
  }) {
    return SyncState(
      status: status ?? this.status,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, lastSyncedAt, errorMessage];
}
