// Copyright 2025 qcrg
// SPDX-License-Identifier: MPL-2.0

import 'dart:typed_data';
import 'dart:math';
import 'package:test/test.dart';
import 'package:uuid7/uuid7.dart';

void main() {
  group('Uuid7 generation', () {
    test('generated UUID is valid and has correct version/variant', () {
      final uuid = Uuid7.gen();

      // length
      expect(uuid.bytes.length, 16);

      // version == 7
      final version = (uuid.bytes[6] >> 4) & 0x0F;
      expect(version, 0x7);

      // variant == 0b10
      final variant = (uuid.bytes[8] >> 6) & 0x03;
      expect(variant, 2);

      // string format
      final re = RegExp(
        r'^[0-9a-fA-F]{8}-'
        r'[0-9a-fA-F]{4}-'
        r'7[0-9a-fA-F]{3}-'
        r'[89abAB][0-9a-fA-F]{3}-'
        r'[0-9a-fA-F]{12}$',
      );
      expect(re.hasMatch(uuid.toString()), isTrue);
    });

    test('two generated UUIDs are different', () {
      final u1 = Uuid7.gen();
      final u2 = Uuid7.gen();
      expect(u1, isNot(equals(u2)));
    });
  });

  group('Uuid7 parsing', () {
    test('fromString parses a valid UUID', () {
      final original = Uuid7.gen();
      final parsed = Uuid7.fromString(original.toString());

      expect(parsed, isNotNull);
      expect(parsed, equals(original));
    });

    test('fromString returns null for malformed input', () {
      expect(Uuid7.fromString('1234'), isNull);
      expect(Uuid7.fromString('zzzzzzzz-zzzz-7zzz-8zzz-zzzzzzzzzzzz'), isNull);
    });

    test('fromList validates length, version and variant', () {
      final rand = Random();
      final good = Uint8List(16);
      for (var i = 0; i < 16; i++) {
        good[i] = rand.nextInt(256);
      }
      // set correct version and variant
      good[6] = (good[6] & 0x0F) | 0x70;
      good[8] = (good[8] & 0x3F) | 0x80;

      final uuid = Uuid7.fromList(good);
      expect(uuid, isNotNull);

      // wrong length
      expect(Uuid7.fromList(Uint8List(15)), isNull);

      // wrong version
      final badVer = Uint8List.fromList(good);
      badVer[6] = (badVer[6] & 0x0F) | 0x60; // version 6
      expect(Uuid7.fromList(badVer), isNull);

      // wrong variant
      final badVar = Uint8List.fromList(good);
      badVar[8] = (badVar[8] & 0x3F) | 0x00; // variant 0b00
      expect(Uuid7.fromList(badVar), isNull);
    });
  });

  group('Equality and hashCode', () {
    test('identical objects are equal', () {
      final a = Uuid7.gen();
      final b = Uuid7.fromString(a.toString())!;
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('different UUIDs have different hashCodes (most of the time)', () {
      final a = Uuid7.gen();
      final b = Uuid7.gen();
      // hash collisions are theoretically possible, but extremely unlikely
      expect(a.hashCode, isNot(equals(b.hashCode)));
    });

    test('UUID can be used as a key in a Map', () {
      final map = <Uuid7, String>{};
      final key = Uuid7.gen();
      map[key] = 'value';
      expect(map[key], 'value');
    });

    test('UUID can be stored in a Set without duplicates', () {
      final set = <Uuid7>{};
      final a = Uuid7.gen();
      final b = Uuid7.fromString(a.toString())!;
      set.add(a);
      set.add(b); // should not add a duplicate
      expect(set.length, 1);
    });
  });

  group('String representation', () {
    test('toString produces canonical format', () {
      final bytes = Uint8List.fromList([
        0x01, 0x23, 0x45, 0x67,
        0x89, 0xAB,
        0x7C, 0xDE, // version 7 in high nibble
        0x8F, 0x00, // variant 0b10xxxxxx
        0x11, 0x22, 0x33, 0x44, 0x55, 0x66,
      ]);
      final uuid = Uuid7(bytes);
      expect(uuid.toString(), '01234567-89ab-7cde-8f00-112233445566');
    });
  });
}
