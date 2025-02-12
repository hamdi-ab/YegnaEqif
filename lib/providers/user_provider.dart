import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yegna_eqif_new/providers/auth_provider.dart';

import '../models/user.dart';
import '../services/auth_service.dart';
import '../utils/generic_dialog.dart';

final userProvider = StateNotifierProvider<UserNotifier, LocalUser?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return UserNotifier(authService, ref);
});

class LocalUser {
  const LocalUser({required this.id, required this.user});

  final String id;
  final FirebaseUser user;

  LocalUser copyWith({
    String? id,
    FirebaseUser? user,
  }) {
    return LocalUser(
      id: id ?? this.id,
      user: user ?? this.user,
    );
  }
}

class UserNotifier extends StateNotifier<LocalUser?> {
  final AuthService _authService;
  final Ref _ref;

  UserNotifier(this._authService, this._ref) : super(null) {
    _authService.user.listen((user) {
      if (user != null) {
        _loadUserData(user.uid);
      } else {
        state = null;
      }
    });
  }

  Future<void> _loadUserData(String uid) async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (doc.exists) {
      final data = doc.data()!;
      final firebaseUser = FirebaseUser.fromMap(data);
      state = LocalUser(id: uid, user: firebaseUser);
    }
  }

  Future<void> logIn(BuildContext context, String email, String password) async {
    try {
      final user = await _authService.signInWithEmailAndPassword(email, password);
      if (user != null) {
        _loadUserData(user.uid);
      } else {
        await showErrorDialog(context, 'Failed to log in. Please try again.');
      }
    } catch (e) {
      await showErrorDialog(context, e.toString());
    }
  }

  Future<void> signUp(BuildContext context, String email, String password) async {
    try {
      final user = await _authService.registerWithEmailAndPassword(email, password);
      if (user != null) {
        _loadUserData(user.uid);
      } else {
        await showErrorDialog(context, 'Failed to sign up. Please try again.');
      }
    } catch (e) {
      await showErrorDialog(context, e.toString());
    }
  }

  Future<void> updateName(BuildContext context, String name) async {
    if (state == null) return;
    try {
      await FirebaseFirestore.instance.collection('users').doc(state!.id).update({
        'name': name,
      });
      state = state!.copyWith(user: state!.user.copyWith(name: name));
    } catch (e) {
      await showErrorDialog(context, e.toString());
    }
  }

  Future<void> updateImage(BuildContext context, File image) async {
    if (state == null) return;
    try {
      Reference ref = FirebaseStorage.instance.ref().child('users').child(state!.id);
      TaskSnapshot snapshot = await ref.putFile(image);
      String profilePicture = await snapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('users').doc(state!.id).update({
        'profilePic': profilePicture,
      });
      state = state!.copyWith(user: state!.user.copyWith(profilePic: profilePicture));
    } catch (e) {
      await showErrorDialog(context, e.toString());
    }
  }

  void logout() {
    _authService.signOut();
    state = null;
  }
}
