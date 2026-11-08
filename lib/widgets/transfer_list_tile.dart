import 'package:flutter/material.dart';
import '../data/database.dart';
import '../utils/constants.dart';

class TransferListTile extends StatelessWidget {
  final Transfer transfer;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TransferListTile({super.key, required this.transfer, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final isReceived = transfer.type.name == 'received';
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        onLongPress: () => _showOptions(context),
        leading: CircleAvatar(
          backgroundColor: (isReceived ? Colors.green : Colors.red).withOpacity(0.15),
          child: Icon(isReceived ? Icons.call_received : Icons.call_made,
              color: isReceived ? Colors.green : Colors.red),
        ),
        title: Text(currencyFormat.format(transfer.amount), style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (transfer.note?.isNotEmpty ?? false)
              Text(transfer.note!, maxLines: 1, overflow: TextOverflow.ellipsis),
            Text(dateFormat.format(transfer.date), style: const TextStyle(fontSize: 12)),
          ],
        ),
        trailing: isReceived ? null : Text('+${currencyFormat.format(transfer.commission)}',
            style: const TextStyle(color: Colors.green, fontSize: 12)),
      ),
    );
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('تعديل'),
              onTap: () { Navigator.pop(ctx); onEdit(); },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('حذف', style: TextStyle(color: Colors.red)),
              onTap: () { Navigator.pop(ctx); _confirmDelete(context); },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد من حذف هذه الحوالة؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () { Navigator.pop(ctx); onDelete(); },
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }
}
