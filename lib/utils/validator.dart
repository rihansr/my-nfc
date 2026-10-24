import 'package:flutter/material.dart';
import '../shared/strings.dart';

abstract class Validator {
  bool isEmpty(Object? value);
  bool isNotEmpty(Object? value);
  bool isMatch(Object? value1, Object? value2, {bool ignoreCase = true});
  bool isNotMatch(Object? value1, Object? value2, {bool ignoreCase = true});
  bool isContain(Object? value1, Object? value2, {bool ignoreCase = true});
  bool isNotContain(Object? value1, Object? value2, {bool ignoreCase = true});
  String? validateField(Object? value, {String? errorMessage});
  String? validateUrl(Object? value, {String? errorMessage});
  String? validateEmail(Object? value);
  String? validatePassword(Object? value, {String? field, String? matchValue});
  String? validateString(Object? value);
  bool isValidUrl(Object? value);
}

final validator = CustomValidator.validator;

class CustomValidator implements Validator {
  static CustomValidator get validator => CustomValidator._();

  CustomValidator._();

  @override
  String? validateString(
    Object? value, {
    String orElse = '',
    bool lowercase = false,
  }) {
    if (isEmpty(value)) return orElse;

    final text = value is TextEditingController ? value.text : value.toString();
    final result = text.trim();

    return lowercase ? result.toLowerCase() : result;
  }

  @override
  bool isEmpty(Object? value) {
    if (value == null) return true;

    if (value is String) return value.trim().isEmpty;
    if (value is bool) return value;
    if (value is TextEditingController) return value.text.trim().isEmpty;
    if (value is Iterable) return value.isEmpty;
    if (value is Map) return value.isEmpty;

    return false;
  }

  @override
  bool isNotEmpty(Object? value) => !isEmpty(value);

  @override
  bool isContain(Object? value1, Object? value2, {bool ignoreCase = true}) {
    if (isEmpty(value1) || isEmpty(value2)) return false;

    final search = validateString(value2, lowercase: ignoreCase)!;

    if (value1 is Iterable) {
      return value1.any(
        (item) => validateString(item, lowercase: ignoreCase) == search,
      );
    }

    return validateString(value1, lowercase: ignoreCase)!.contains(search);
  }

  @override
  bool isNotContain(Object? value1, Object? value2, {bool ignoreCase = true}) =>
      !isContain(value1, value2, ignoreCase: ignoreCase);

  @override
  bool isMatch(Object? value1, Object? value2, {bool ignoreCase = true}) {
    if (isEmpty(value1) || isEmpty(value2)) return false;

    return validateString(value1, lowercase: ignoreCase) ==
        validateString(value2, lowercase: ignoreCase);
  }

  @override
  bool isNotMatch(Object? value1, Object? value2, {bool ignoreCase = true}) =>
      !isMatch(value1, value2, ignoreCase: ignoreCase);

  @override
  String? validateField(
    Object? value, {
    String? field,
    String? errorMessage,
    int? minLength,
    int? maxLength,
    String? valueSymbol,
    String? matchValue,
  }) {
    final text = validateString(value);

    if (isEmpty(value)) {
      return errorMessage ?? string.emptyField('$field');
    }

    if (minLength != null && text!.length < minLength) {
      return string.inputMinLengthError('$field', minLength);
    }

    if (maxLength != null && text!.length > maxLength) {
      return string.inputMaxLengthError('$field', maxLength);
    }

    if (matchValue != null && text != matchValue) {
      return string.fieldNotMatch('$field');
    }

    return null;
  }

  @override
  String? validateUrl(Object? value, {String? field, String? errorMessage}) {
    if (isEmpty(value)) {
      return errorMessage ?? string.emptyField('$field');
    }

    final text = validateString(value)!;
    final uri = Uri.tryParse(text.contains('://') ? text : 'https://$text');

    if (uri == null ||
        !uri.hasAuthority ||
        uri.host.isEmpty ||
        !uri.host.contains('.')) {
      return string.invalidUrl;
    }

    return null;
  }

  @override
  String? validateEmail(Object? value) {
    if (isEmpty(value)) {
      return string.emptyField(string.emailHint);
    }

    final text = validateString(value)!;
    final emailRegex = RegExp(
      r"^[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?$",
      caseSensitive: false,
    );

    if (!emailRegex.hasMatch(text)) {
      return string.notValidField(string.emailHint);
    }

    return null;
  }

  @override
  String? validatePassword(
    Object? value, {
    String? field,
    String? matchValue,
    int? minLength = 6,
    int? maxLength = 40,
  }) {
    final passwordField = field ?? string.passwordHint;

    final message = validateField(
      value,
      field: passwordField,
      minLength: minLength,
      maxLength: maxLength,
    );

    if (message != null) return message;

    if (matchValue != null && validateString(value) != matchValue) {
      return string.fieldNotMatch(passwordField);
    }

    return null;
  }

  @override
  bool isValidUrl(Object? value) {
    if (isEmpty(value)) return false;

    final text = validateString(value)!;
    final uri = Uri.tryParse(text.contains('://') ? text : 'https://$text');

    return uri != null &&
        uri.hasAuthority &&
        uri.host.isNotEmpty &&
        uri.host.contains('.');
  }
}
