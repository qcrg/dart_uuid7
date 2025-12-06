# dart_uuid7

A tiny, zero‑dependency Dart library that generates **UUID v7**
(time‑ordered, RFC 4122‑compatible) and provides parsing, equality,
hashing and a convenient string representation.



## Table of Contents
- [Features](#features)
- [Quick start](#quick-start)
- [Testing](#testing)
- [License](#license)



## Features
- **UUID v7 creation from raw bytes** - validate data only in debug mode.
- **UUID v7 generation** - time‑ordered, 48‑bit Unix‑epoch timestamp + random bits.
- **Parsing** from the canonical string (`xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`) or from a `List<int>`/`Uint8List`.
- **Value equality** (`==`) and proper `hashCode` so UUIDs can be used as keys in `Map` or members of `Set`.
- **Immutable** - the internal byte buffer is private; a copy is exposed via `bytes`.
- **No external dependencies** - works with the Dart SDK alone.



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

  // Create from raw bytes without validation
  final bytes = Uint8List.fromList([
    0x01, 0x23, 0x45, 0x67,
    0x89, 0xAB,
    0x7C, 0xDE, // version 7 in high nibble
    0x8F, 0x00, // variant 0b10xxxxxx
    0x11, 0x22, 0x33, 0x44, 0x55, 0x66,
  ]);
  final uuid_from_raw = Uuid7.raw(bytes);

  // Access raw bytes (copy)
  final raw = uuid.bytes;
  print(raw); // Uint8List(16) [...]
}
```



## Testing

The package includes a comprehensive test suite (`test/uuid7_test.dart`). To run the tests:

```bash
dart test
```

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
