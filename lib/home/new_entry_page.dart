import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewEntryPage extends StatefulWidget {
  const NewEntryPage({super.key});
  @override
  State<NewEntryPage> createState() => _NewEntryPageState();
}

class _NewEntryPageState extends State<NewEntryPage> {
  final _formKey = GlobalKey<FormState>();
  final _brand = TextEditingController();
  final _model = TextEditingController();
  final _reference = TextEditingController();
  DateTime? _purchaseDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Neue Uhr')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(
              controller: _brand,
              decoration: const InputDecoration(labelText: 'Marke *'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Pflichtfeld' : null,
            ),
            TextFormField(
              controller: _model,
              decoration: const InputDecoration(labelText: 'Modell *'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Pflichtfeld' : null,
            ),
            TextFormField(
              controller: _reference,
              decoration: const InputDecoration(labelText: 'Referenz (optional)'),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              icon: const Icon(Icons.date_range),
              label: Text(_purchaseDate == null
                  ? 'Kaufdatum wählen (optional)'
                  : 'Kaufdatum: ${_purchaseDate!.toLocal().toString().split(' ').first}'),
              onPressed: () async {
                final d = await showDatePicker(
                  context: context,
                  firstDate: DateTime(1970),
                  lastDate: DateTime.now().add(const Duration(days: 1)),
                  initialDate: _purchaseDate ?? DateTime.now(),
                );
                if (d != null) setState(() => _purchaseDate = d);
              },
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () {
                if (!(_formKey.currentState?.validate() ?? false)) return;
                Navigator.pop<Map<String, dynamic>>(context, {
                  'brand': _brand.text.trim(),
                  'model': _model.text.trim(),
                  'reference': _reference.text.trim(),
                  'purchaseDate': _purchaseDate == null
                      ? null
                      : Timestamp.fromDate(_purchaseDate!),
                });
              },
              child: const Text('Speichern'),
            ),
          ]),
        ),
      ),
    );
  }
}
