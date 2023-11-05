import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:go_router/go_router.dart';
import 'package:ndef/ndef.dart';

class NfcAttendaceCheckDialog extends StatefulWidget {
  const NfcAttendaceCheckDialog({
    super.key,
    required this.roomCode,
  });

  final String roomCode;

  @override
  State<NfcAttendaceCheckDialog> createState() =>
      _NfcAttendaceCheckDialogState();
}

class _NfcAttendaceCheckDialogState extends State<NfcAttendaceCheckDialog> {
  bool hasNfc = true;
  bool scanError = false;

  String test = "";

  @override
  void initState() {
    FlutterNfcKit.nfcAvailability.then(
      (availability) => setState(() {
        hasNfc = availability == NFCAvailability.available;
      }),
    );
    FlutterNfcKit.poll(timeout: const Duration(seconds: 10)).then(
      (tag) async {
        final records = await FlutterNfcKit.readNDEFRecords(cached: false);
        if (records.isNotEmpty) {
          final record = records[0];
          if (record is TextRecord && record.text == widget.roomCode) {
            setState(() => context.pop(true));
            return;
          }
        }

        setState(() => scanError = true);
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    FlutterNfcKit.finish();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Scan Tag'),
            centerTitle: false,
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => context.pop(),
            ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                !hasNfc || scanError ? Icons.close : Icons.nfc,
                size: 64.0,
              ),
              Text(
                scanError
                    ? 'Error scanning tag'
                    : !hasNfc
                        ? 'NFC not avalable'
                        : 'Scan attendance tag',
                textAlign: TextAlign.center,
              ),
              Text(test),
            ],
          ),
        ),
      ),
    );
  }
}
