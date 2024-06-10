import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:nfc_manager/nfc_manager.dart';
import '../shared/strings.dart';
import '../shared/styles.dart';
import '../utils/debug.dart';

class NFC {
  static NFC get instance => NFC._();
  NFC._();

  Future<bool> isAvailable() async => await NfcManager.instance.isAvailable();

  Future<void> read({Function(Ndef, Map<String, dynamic>)? callback}) async {
    if (await isAvailable()) {
      NfcManager.instance.startSession(
        onDiscovered: (NfcTag tag) async {
          Ndef? ndef = Ndef.from(tag);
          if (ndef == null) return;
          final data = {
            'serialNo': String.fromCharCodes(tag.data['ndef']?['identifier'] ??
                ndef.additionalData['identifier']),
            'atqa': utf8.decode(tag.data['nfca']?['atqa'] ?? []),
            'type': tag.data['ndef']?['type'] ?? ndef.additionalData['type'],
            'canMakeReadOnly': tag.data['ndef']?['canMakeReadOnly'] ??
                ndef.additionalData['canMakeReadOnly'] ??
                false,
            'records': (() {
              List records =
                  tag.data['ndef']?['cachedMessage']?['records'] ?? [];
              return records.isEmpty
                  ? null
                  : records
                      .map((record) => String.fromCharCodes(record['payload']))
                      .toList();
            }()),
          };
          _log(jsonEncode(data['records']), tag: 'Read Data', logOnly: true);
          callback?.call(ndef, data);
        },
      );
    } else {
      _log(string.nfcNotAvailable);
    }
  }

  Future<void> write({
    required List<NdefRecord> records,
    Function(Ndef)? callback,
  }) async {
    if (await isAvailable()) {
      NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
        Ndef? ndef = Ndef.from(tag);
        if (ndef != null) callback?.call(ndef);

        if (ndef == null || !ndef.isWritable) {
          _log(string.notWritableNfc);
          stop();
          return;
        }
        /*
          NdefRecord.createText(title!),
          NdefRecord.createUri(Uri.parse(url!)),
          NdefRecord.createMime(mime.key, mime.value),
          NdefRecord.createExternal(external.key, external.value.key, external.value.value),
        */

        NdefMessage message = NdefMessage(records);

        if (ndef.maxSize < message.byteLength) {
          _log(string.nfcSizeExceeded);
          stop();
          return;
        }

        try {
          await ndef.write(message);
          Uint8List payload = message.records.first.payload;
          String text = String.fromCharCodes(payload);
          _log('Success to Ndef Write: $text', logOnly: true);
          stop();
        } catch (e) {
          _log(e.toString(), tag: 'Write Data Execption');
          stop();
        }
      });
    } else {
      _log(string.nfcNotAvailable);
    }
  }

  Future<void> lock({Function(Ndef)? callback}) async {
    if (await isAvailable()) {
      NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
        Ndef? ndef = Ndef.from(tag);
        if (ndef != null) callback?.call(ndef);

        if (ndef == null) {
          _log(string.notLockableNfc);
          stop();
          return;
        }

        try {
          await ndef.writeLock();
          _log('Success to Ndef Write Lock', logOnly: true);
          stop();
        } catch (e) {
          _log(e.toString(), tag: 'Permanently Lock Execption');
          stop();
          return;
        }
      });
    } else {
      _log(string.nfcNotAvailable);
    }
  }

  _log(String message, {String? tag, bool logOnly = false}) {
    debug.print(message, tag: tag);
    if (!logOnly) style.showToast(message);
  }

  Future<void> stop() async => await NfcManager.instance.stopSession();
}
