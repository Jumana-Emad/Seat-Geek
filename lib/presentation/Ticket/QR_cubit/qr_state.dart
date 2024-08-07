part of 'qr_cubit.dart';

@immutable
abstract class QrState {}

class QrInitial extends QrState {}

class QrCodeVisible extends QrState {
  final int index;

  QrCodeVisible(this.index);
}

class QrCodeHidden extends QrState {}
