// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

@TestOn('vm') // Uses dart:io

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cross_file_dart/cross_file_dart.dart';
import 'package:flutter_test/flutter_test.dart';

final String pathPrefix =
    Directory.current.path.endsWith('test') ? './assets/' : './test/assets/';
final String path = pathPrefix + 'hello.txt';
const String expectedStringContents = 'Hello, world!';
final Uint8List bytes = Uint8List.fromList(utf8.encode(expectedStringContents));
final File textFile = File(path);
final String textFilePath = textFile.path;

void main() {
  group('Create with a path', () {
    final XFileDart file = XFileDart(textFilePath);

    test('Can be read as a string', () async {
      expect(await file.readAsString(), equals(expectedStringContents));
    });
    test('Can be read as bytes', () async {
      expect(await file.readAsBytes(), equals(bytes));
    });

    test('Can be read as a stream', () async {
      expect(await file.openRead().first, equals(bytes));
    });

    test('Stream can be sliced', () async {
      expect(await file.openRead(2, 5).first, equals(bytes.sublist(2, 5)));
    });

    test('saveTo(..) creates file', () async {
      final File removeBeforeTest = File(pathPrefix + 'newFilePath.txt');
      if (removeBeforeTest.existsSync()) {
        await removeBeforeTest.delete();
      }

      await file.saveTo(pathPrefix + 'newFilePath.txt');
      final File newFile = File(pathPrefix + 'newFilePath.txt');

      expect(newFile.existsSync(), isTrue);
      expect(newFile.readAsStringSync(), 'Hello, world!');

      await newFile.delete();
    });
  });

  group('Create with data', () {
    final XFileDart file = XFileDart.fromData(bytes);

    test('Can be read as a string', () async {
      expect(await file.readAsString(), equals(expectedStringContents));
    });
    test('Can be read as bytes', () async {
      expect(await file.readAsBytes(), equals(bytes));
    });

    test('Can be read as a stream', () async {
      expect(await file.openRead().first, equals(bytes));
    });

    test('Stream can be sliced', () async {
      expect(await file.openRead(2, 5).first, equals(bytes.sublist(2, 5)));
    });

    test('Function saveTo(..) creates file', () async {
      final File removeBeforeTest = File(pathPrefix + 'newFileData.txt');
      if (removeBeforeTest.existsSync()) {
        await removeBeforeTest.delete();
      }

      await file.saveTo(pathPrefix + 'newFileData.txt');
      final File newFile = File(pathPrefix + 'newFileData.txt');

      expect(newFile.existsSync(), isTrue);
      expect(newFile.readAsStringSync(), 'Hello, world!');

      await newFile.delete();
    });
  });
}
