# dart_uuid7

A tiny, zero‑dependency Dart library that generates **UUID v7**
(time‑ordered, RFC 4122‑compatible) and provides parsing, equality,
hashing and a convenient string representation.

---

## Table of Contents
- [Features](#features)
- [Installation](#installation)
- [Quick start](#quick-start)
- [API reference](#api-reference)
- [Testing](#testing)
- [License](#license)

---

## Features
- **UUID v7 generation** – time‑ordered, 48‑bit Unix‑epoch timestamp + random bits.
- **Parsing** from the canonical string (`xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`) or from a `List<int>`/`Uint8List`.
- **Value equality** (`==`) and proper `hashCode` so UUIDs can be used as keys in `Map` or members of `Set`.
- **Immutable** – the internal byte buffer is private; a copy is exposed via `bytes`.
- **No external dependencies** – works with the Dart SDK alone.

---

## Quick start

```dart
import 'package:dart_uuid7/uuid7.dart';

void main() {
  // Generate a new UUID v7
  final uuid = Uuid7.gen();
  print('Generated: ${uuid.toString()}');   // e.g. 0189b5a0-7c3e-7f1b-8a2d-3c4e5f6a7b8c

  // Parse from a string
  final parsed = Uuid7.fromString(uuid.toString())!;
  print(parsed == uuid); // true

  // Use as a map key
  final map = <Uuid7, String>{uuid: 'my value'};
  print(map[uuid]); // 'my value'

  // Access raw bytes (copy)
  final raw = uuid.bytes;
  print(raw); // Uint8List(16) [...]
}
```

---

## API reference

### `class Uuid7`

| Constructor | Description |
|-------------|-------------|
| `Uuid7(this._data)` | Private; creates a UUID from an existing 16‑byte buffer. |
| `Uuid7.gen()` | Generates a new UUID v7 using the current timestamp and secure random bytes. |

| Static method | Description |
|---------------|-------------|
| `static Uuid7? fromString(String uuid)` | Parses a canonical UUID string. Returns `null` on malformed input. |
| `static Uuid7? fromList(List<int> bytes)` | Validates length, version (`7`) and variant (`0b10`). Returns `null` if checks fail. |

| Instance members | Description |
|------------------|-------------|
| `Uint8List get bytes` | Returns a **copy** of the internal 16‑byte buffer (immutable). |
| `@override String toString()` | Returns the canonical UUID string (`xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`). |
| `@override bool operator ==(Object other)` | Value equality – compares all 16 bytes. |
| `@override int get hashCode` | Combines the bytes into a 32‑bit hash suitable for `Map`/`Set`. |

---

## Testing

The package includes a comprehensive test suite (`test/uuid7_test.dart`). To run the tests:

```bash
dart test
```

The tests cover:

- Generation validity (length, version, variant, format)
- Parsing from string and list
- Equality & `hashCode`
- Usage as keys in `Map` and members of `Set`
- Canonical string output

---

## License

```
Mozilla Public License Version 2.0
=================================

Copyright 2025 qcrg
This source code is licensed under the Mozilla Public License 2.0 (MPL-2.0).
See https://www.mozilla.org/MPL/2.0/ for the full license text.
```

The full license text is available in the repository’s `LICENSE` file.
