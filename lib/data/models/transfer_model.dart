import 'package:isar/isar.dart';

part 'transfer_model.g.dart';

enum TransferType { incoming, outgoing }

@collection
class Transfer {
  Id id = Isar.autoIncrement;

  late String senderName;
  late String receiverName;
  late double amount;
  late String currency;
  late double exchangeRate;
  late DateTime date;

  @enumerated
  late TransferType type;

  String? notes;
  String? receiptImagePath;
  bool isArchived = false;

  double get convertedAmount => amount * exchangeRate;
}
