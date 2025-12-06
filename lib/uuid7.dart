// Copyright 2025 qcrg
// SPDX-License-Identifier: MPL-2.0

import 'dart:math';
import 'dart:typed_data';

const _uuidLength = 16;

class Uuid7 {
  final Uint8List _data;

  Uuid7._(this._data);

  Uuid7.raw(List<int> bytes) : _data = Uint8List.fromList(bytes) {
    assert(Uuid7.fromList(bytes) != null);
  }

  Uuid7.gen() : _data = Uint8List(_uuidLength) {
    final rand = Random();

    final timestamp = DateTime.now().millisecondsSinceEpoch;

    for (var i = 0; i < 6; i++) {
      _data[i] = (timestamp >> (40 - i * 8)) & 0xFF;
    }

    _data[6] = ((timestamp >> 8) & 0x0F) | 0x70;
    _data[7] = timestamp & 0xFF;

    _data[8] = 0x80 | (rand.nextInt(256) & 0x3F);

    for (var i = 9; i < _uuidLength; i++) {
      _data[i] = rand.nextInt(256);
    }
  }

  static Uuid7? fromString(String uuid) {
    const uuidStrLen = 36;
    if (uuid.length != uuidStrLen) return null;
    final hex = uuid.replaceAll('-', '');
    final bytes = Uint8List(_uuidLength);
    for (int i = 0; i < _uuidLength; i++) {
      final int? tmp = int.tryParse(hex.substring(i * 2, i * 2 + 2), radix: 16);
      if (tmp == null) return null;
      bytes[i] = tmp;
    }
    return fromList(bytes);
  }

  static Uuid7? fromList(List<int> bytes) {
    if (bytes.length != _uuidLength) {
      return null;
    }
    final int version = (bytes[6] >> 4) & 0x0F;
    if (version != 0x7) {
      return null;
    }
    final int variant = (bytes[8] >> 6) & 0x03;
    if (variant != 2) {
      return null;
    }
    return Uuid7._(Uint8List.fromList(bytes));
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Uuid7) return false;
    for (int i = 0; i < _uuidLength; i++) {
      if (_data[i] != other._data[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode {
    int hash = 0;
    for (int i = 0; i < _uuidLength; i += 4) {
      final part =
          (_data[i] << 24) |
          (_data[i + 1] << 16) |
          (_data[i + 2] << 8) |
          _data[i + 3];
      hash = 0x1fffffff & (hash * 31 + part);
    }
    return hash;
  }

  @override
  String toString() {
    String f(int i) {
      final h = _data[i].toRadixString(16);
      return h.length == 1 ? '0$h' : h;
    }

    var buf = StringBuffer()
      ..write("${f(0)}${f(1)}${f(2)}${f(3)}-")
      ..write("${f(4)}${f(5)}-")
      ..write("${f(6)}${f(7)}-")
      ..write("${f(8)}${f(9)}-")
      ..write("${f(10)}${f(11)}${f(12)}${f(13)}${f(14)}${f(15)}");
    return buf.toString();
  }

  Uint8List get bytes {
    return Uint8List.fromList(_data);
  }
}
