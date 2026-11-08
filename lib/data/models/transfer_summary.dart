class TransferSummary {
  final double totalReceived;
  final double totalPaid;
  final double totalCommission;
  final int totalCount;
  final int paidCount;

  const TransferSummary({
    this.totalReceived = 0,
    this.totalPaid = 0,
    this.totalCommission = 0,
    this.totalCount = 0,
    this.paidCount = 0,
  });

  double get netBalance => totalReceived - totalPaid - totalCommission;
}
