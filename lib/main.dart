import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: NfcHome(),
    );
  }
}

class NfcHome extends StatefulWidget {
  const NfcHome({super.key});

  @override
  State<NfcHome> createState() => _NfcHomeState();
}

class _NfcHomeState extends State<NfcHome> {
  bool _available = false;
  bool _scanning = false;
  Map<dynamic, dynamic>? _tag;

  @override
  void initState() {
    super.initState();
    _checkAvailability();
  }

  Future<void> _checkAvailability() async {
    final v = await NfcManager.instance.isAvailable();
    setState(() => _available = v);
  }

  void _startScan() {
    setState(() {
      _scanning = true;
      _tag = null;
    });

    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      // Tag discovered — update UI
      setState(() {
        _tag = tag.data;
      });

      // Stop the session after reading
      await NfcManager.instance.stopSession();
      setState(() => _scanning = false);
    }, onError: (error) async {
      // Ensure session is stopped on error
      await NfcManager.instance.stopSession(errorMessage: error.toString());
      setState(() => _scanning = false);
    });
  }

  Future<void> _stopScan() async {
    await NfcManager.instance.stopSession();
    setState(() => _scanning = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('RFID / NFC Test')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('NFC available: '),
                Text(_available ? 'Yes' : 'No', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _available && !_scanning ? _startScan : null,
                  child: const Text('Start Scan'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _scanning ? _stopScan : null,
                  child: const Text('Stop'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Last tag (raw):', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Text(
                    _tag != null ? const JsonEncoder.withIndent('  ').convert(_tag) : 'No tag read yet',
                    style: const TextStyle(fontFamily: 'monospace'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
