import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database.dart';
import '../data/models/transfer_type.dart';   // ⬅️ السطر الجديد
import '../providers/database_provider.dart';
import '../utils/constants.dart';

class TransferFormScreen extends ConsumerStatefulWidget {
  final int accountId;
  final TransferType type;
  final Transfer? existing;

  const TransferFormScreen({super.key, required this.accountId, required this.type, this.existing});

  @override
  ConsumerState<TransferFormScreen> createState() => _TransferFormScreenState();
}

class _TransferFormScreenState extends ConsumerState<TransferFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountController;
  late TextEditingController _noteController;
  late DateTime _date;
  int _commission = 100;
  bool _saving = false;

  bool get isEdit => widget.existing != null;
  bool get isPaid => widget.type == TransferType.paid;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _amountController = TextEditingController(text: e?.amount.toString() ?? '');
    _noteController = TextEditingController(text: e?.note ?? '');
    _date = e?.date ?? DateTime.now();
    _commission = e?.commission ?? 100;
    if (_commission != 100 && _commission != 250) _commission = 100;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'تعديل الحوالة' : (isPaid ? 'حوالة مدفوعة جديدة' : 'حوالة مستلمة جديدة')),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'المبلغ (ل.س)',
                prefixIcon: Icon(Icons.money),
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'أدخل المبلغ';
                final d = double.tryParse(v.trim());
                if (d == null || d <= 0) return 'أدخل مبلغًا صالحًا أكبر من صفر';
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'ملاحظة (اختياري)',
                prefixIcon: Icon(Icons.note),
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('التاريخ'),
              subtitle: Text(dateFormat.format(_date)),
              trailing: const Icon(Icons.edit),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _date,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                  locale: const Locale('ar'),
                );
                if (picked != null) {
                  setState(() {
                    _date = DateTime(picked.year, picked.month, picked.day, _date.hour, _date.minute);
                  });
                }
              },
            ),
            if (isPaid) ...[
              const SizedBox(height: 16),
              const Text('العمولة', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [100, 250].map((c) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text('$c ل.س'),
                      selected: _commission == c,
                      onSelected: (_) => setState(() => _commission = c),
                    ),
                  ),
                )).toList(),
              ),
            ],
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _saving ? null : _save,
              icon: _saving
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.save),
              label: Text(isEdit ? 'حفظ التعديلات' : 'إضافة الحوالة'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final amount = double.parse(_amountController.text.trim());
      final note = _noteController.text.trim();
      final db = ref.read(databaseProvider);

      if (isEdit) {
        await db.transfersDao.updateTransfer(
          id: widget.existing!.id,
          amount: amount,
          commission: isPaid ? _commission : 0,
          date: _date,
          note: note.isEmpty ? null : note,
        );
      } else {
        await db.transfersDao.insertTransfer(
          accountId: widget.accountId,
          type: widget.type,
          amount: amount,
          commission: isPaid ? _commission : 0,
          date: _date,
          note: note.isEmpty ? null : note,
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(isEdit ? 'تم حفظ التعديلات' : 'تمت إضافة الحوالة')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}
