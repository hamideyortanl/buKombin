// Minimal SHA-256 implementation (pure Dart, no extra dependencies).
//
// Not meant to be a full crypto toolkit; it's only used to avoid storing
// plaintext passwords in local demo storage.
//
// Reference: FIPS 180-4 (SHA-2). Constants are standard.

import 'dart:typed_data';

Uint8List sha256Bytes(Uint8List message) {
  final bytes = _pad(message);
  final w = Uint32List(64);

  // Initial hash values
  var h0 = 0x6a09e667;
  var h1 = 0xbb67ae85;
  var h2 = 0x3c6ef372;
  var h3 = 0xa54ff53a;
  var h4 = 0x510e527f;
  var h5 = 0x9b05688c;
  var h6 = 0x1f83d9ab;
  var h7 = 0x5be0cd19;

  for (var i = 0; i < bytes.length; i += 64) {
    // Prepare message schedule
    for (var t = 0; t < 16; t++) {
      final o = i + (t * 4);
      w[t] = (bytes[o] << 24) | (bytes[o + 1] << 16) | (bytes[o + 2] << 8) | bytes[o + 3];
    }
    for (var t = 16; t < 64; t++) {
      final s0 = _rotr(w[t - 15], 7) ^ _rotr(w[t - 15], 18) ^ (w[t - 15] >> 3);
      final s1 = _rotr(w[t - 2], 17) ^ _rotr(w[t - 2], 19) ^ (w[t - 2] >> 10);
      w[t] = _add32(_add32(_add32(w[t - 16], s0), w[t - 7]), s1);
    }

    // Working variables
    var a = h0;
    var b = h1;
    var c = h2;
    var d = h3;
    var e = h4;
    var f = h5;
    var g = h6;
    var h = h7;

    for (var t = 0; t < 64; t++) {
      final s1 = _rotr(e, 6) ^ _rotr(e, 11) ^ _rotr(e, 25);
      final ch = (e & f) ^ ((~e) & g);
      final temp1 = _add32(_add32(_add32(_add32(h, s1), ch), _k[t]), w[t]);
      final s0 = _rotr(a, 2) ^ _rotr(a, 13) ^ _rotr(a, 22);
      final maj = (a & b) ^ (a & c) ^ (b & c);
      final temp2 = _add32(s0, maj);

      h = g;
      g = f;
      f = e;
      e = _add32(d, temp1);
      d = c;
      c = b;
      b = a;
      a = _add32(temp1, temp2);
    }

    h0 = _add32(h0, a);
    h1 = _add32(h1, b);
    h2 = _add32(h2, c);
    h3 = _add32(h3, d);
    h4 = _add32(h4, e);
    h5 = _add32(h5, f);
    h6 = _add32(h6, g);
    h7 = _add32(h7, h);
  }

  final out = Uint8List(32);
  _writeU32(out, 0, h0);
  _writeU32(out, 4, h1);
  _writeU32(out, 8, h2);
  _writeU32(out, 12, h3);
  _writeU32(out, 16, h4);
  _writeU32(out, 20, h5);
  _writeU32(out, 24, h6);
  _writeU32(out, 28, h7);
  return out;
}

String sha256Hex(Uint8List message) {
  final b = sha256Bytes(message);
  final sb = StringBuffer();
  for (final v in b) {
    sb.write(v.toRadixString(16).padLeft(2, '0'));
  }
  return sb.toString();
}

Uint8List _pad(Uint8List message) {
  final bitLen = message.length * 8;
  // 1 byte 0x80 + padding zeros + 8 bytes length
  final withOne = message.length + 1;
  final padLen = (64 - ((withOne + 8) % 64)) % 64;
  final out = Uint8List(message.length + 1 + padLen + 8);
  out.setAll(0, message);
  out[message.length] = 0x80;
  // length in bits, big-endian 64-bit
  for (var i = 0; i < 8; i++) {
    out[out.length - 1 - i] = (bitLen >> (8 * i)) & 0xFF;
  }
  return out;
}

int _rotr(int x, int n) => ((x >> n) | (x << (32 - n))) & 0xFFFFFFFF;
int _add32(int a, int b) => (a + b) & 0xFFFFFFFF;

void _writeU32(Uint8List out, int offset, int v) {
  out[offset] = (v >> 24) & 0xFF;
  out[offset + 1] = (v >> 16) & 0xFF;
  out[offset + 2] = (v >> 8) & 0xFF;
  out[offset + 3] = v & 0xFF;
}

const List<int> _k = [
  0x428a2f98,
  0x71374491,
  0xb5c0fbcf,
  0xe9b5dba5,
  0x3956c25b,
  0x59f111f1,
  0x923f82a4,
  0xab1c5ed5,
  0xd807aa98,
  0x12835b01,
  0x243185be,
  0x550c7dc3,
  0x72be5d74,
  0x80deb1fe,
  0x9bdc06a7,
  0xc19bf174,
  0xe49b69c1,
  0xefbe4786,
  0x0fc19dc6,
  0x240ca1cc,
  0x2de92c6f,
  0x4a7484aa,
  0x5cb0a9dc,
  0x76f988da,
  0x983e5152,
  0xa831c66d,
  0xb00327c8,
  0xbf597fc7,
  0xc6e00bf3,
  0xd5a79147,
  0x06ca6351,
  0x14292967,
  0x27b70a85,
  0x2e1b2138,
  0x4d2c6dfc,
  0x53380d13,
  0x650a7354,
  0x766a0abb,
  0x81c2c92e,
  0x92722c85,
  0xa2bfe8a1,
  0xa81a664b,
  0xc24b8b70,
  0xc76c51a3,
  0xd192e819,
  0xd6990624,
  0xf40e3585,
  0x106aa070,
  0x19a4c116,
  0x1e376c08,
  0x2748774c,
  0x34b0bcb5,
  0x391c0cb3,
  0x4ed8aa4a,
  0x5b9cca4f,
  0x682e6ff3,
  0x748f82ee,
  0x78a5636f,
  0x84c87814,
  0x8cc70208,
  0x90befffa,
  0xa4506ceb,
  0xbef9a3f7,
  0xc67178f2,
];
