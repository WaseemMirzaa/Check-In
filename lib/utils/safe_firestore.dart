import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// Safe cast for Firestore document payloads (null / wrong type → null).
Map<String, dynamic>? firestoreMap(Object? data) {
  if (data is Map<String, dynamic>) return data;
  if (data is Map) return Map<String, dynamic>.from(data);
  return null;
}

/// Only builds a [NetworkImage] when [url] is a usable http(s) URL.
ImageProvider? safeNetworkImage(String? url) {
  final value = url?.trim() ?? '';
  if (value.isEmpty) return null;
  if (!value.startsWith('http://') && !value.startsWith('https://')) {
    return null;
  }
  return NetworkImage(value);
}

/// Prefer merge-set so missing docs don't throw not-found.
Future<void> safeUserSet(
  DocumentReference<Map<String, dynamic>> ref,
  Map<String, dynamic> data,
) async {
  try {
    await ref.set(data, SetOptions(merge: true));
  } catch (e, st) {
    debugPrint('safeUserSet failed (${ref.path}): $e\n$st');
  }
}
