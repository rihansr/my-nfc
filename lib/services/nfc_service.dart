import 'dart:convert';
import 'package:flutter/services.dart' show PlatformException;
import 'package:nfc_manager/ndef_record.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager_ndef/nfc_manager_ndef.dart';
import '../shared/strings.dart';
import '../shared/styles.dart';
import '../utils/debug.dart';

final nfc = _NFC.instance;

class _NFC {
  static final _NFC instance = _NFC._();

  _NFC._();

  bool _isSessionActive = false;
  bool _isProcessingTag = false;

  Future<bool> isAvailable() async {
    return await NfcManager.instance.checkAvailability() ==
        NfcAvailability.enabled;
  }

  Future<void> _startSession(
    Future<void> Function(NfcTag tag) onDiscovered,
  ) async {
    if (_isSessionActive) {
      _log('An NFC session is already active.');
      return;
    }

    _isSessionActive = true;
    _isProcessingTag = false;

    try {
      await NfcManager.instance.startSession(
        pollingOptions: {NfcPollingOption.iso14443},
        onDiscovered: (NfcTag tag) async {
          // Avoid processing the same session multiple times.
          if (_isProcessingTag) return;

          _isProcessingTag = true;
          await onDiscovered(tag);
        },
      );
    } catch (e) {
      _isSessionActive = false;
      _isProcessingTag = false;
      rethrow;
    }
  }

  Future<void> read({
    Function(Ndef, Map<String, dynamic>)? callback,
  }) async {
    if (!await isAvailable()) {
      _log(string.nfcNotAvailable);
      return;
    }

    try {
      await _startSession((NfcTag tag) async {
        try {
          final Ndef? ndef = Ndef.from(tag);

          if (ndef == null) {
            _log(string.notWritableNfc);
            return;
          }

          final NdefMessage? message = ndef.cachedMessage;

          final records = message?.records
              .map((record) => String.fromCharCodes(record.payload))
              .toList();

          final data = <String, dynamic>{
            'canMakeReadOnly': ndef.isWritable,
            'records':
                records == null || records.isEmpty ? null : records,
          };

          _log(
            jsonEncode(data['records']),
            tag: 'Read Data',
            logOnly: true,
          );

          callback?.call(ndef, data);
        } catch (e) {
          _log(e.toString(), tag: 'Read Data Exception');
        } finally {
          await stop();
        }
      });
    } catch (e) {
      _log(e.toString(), tag: 'Start NFC Read Exception');
    }
  }

  Future<void> write({
    required List<NdefRecord> records,
    Function(Ndef)? callback,
  }) async {
    if (!await isAvailable()) {
      _log(string.nfcNotAvailable);
      return;
    }

    try {
      await _startSession((NfcTag tag) async {
        try {
          final Ndef? ndef = Ndef.from(tag);

          if (ndef == null || !ndef.isWritable) {
            _log(string.notWritableNfc);
            return;
          }

          callback?.call(ndef);

          final message = NdefMessage(records: records);

          if (ndef.maxSize < message.byteLength) {
            _log(string.nfcSizeExceeded);
            return;
          }

          await ndef.write(message: message);

          final payload = message.records.isNotEmpty
              ? String.fromCharCodes(message.records.first.payload)
              : '';

          _log('Success to Ndef Write: $payload', logOnly: true);
        } catch (e) {
          _log(e.toString(), tag: 'Write Data Exception');
        } finally {
          await stop();
        }
      });
    } catch (e) {
      _log(e.toString(), tag: 'Start NFC Write Exception');
    }
  }

  Future<void> lock({Function(Ndef)? callback}) async {
    if (!await isAvailable()) {
      _log(string.nfcNotAvailable);
      return;
    }

    try {
      await _startSession((NfcTag tag) async {
        try {
          final Ndef? ndef = Ndef.from(tag);

          if (ndef == null) {
            _log(string.notLockableNfc);
            return;
          }

          callback?.call(ndef);

          await ndef.writeLock();

          _log('Success to Ndef Write Lock', logOnly: true);
        } catch (e) {
          _log(e.toString(), tag: 'Permanently Lock Exception');
        } finally {
          await stop();
        }
      });
    } catch (e) {
      _log(e.toString(), tag: 'Start NFC Lock Exception');
    }
  }

  void _log(
    String message, {
    String? tag,
    bool logOnly = false,
  }) {
    debug.print(message, tag: tag);

    if (!logOnly) {
      style.showToast(message);
    }
  }

  Future<void> stop() async {
    if (!_isSessionActive) return;

    // Reset before awaiting to prevent concurrent stop calls.
    _isSessionActive = false;

    try {
      await NfcManager.instance.stopSession();
    } on PlatformException catch (e) {
      if (e.code != 'no_active_sessions') {
        _log(e.message ?? e.code, tag: 'Stop NFC Session Exception');
      }
      // iOS may have already invalidated the session.
    } catch (e) {
      _log(e.toString(), tag: 'Stop NFC Session Exception');
    } finally {
      _isProcessingTag = false;
    }
  }
}
