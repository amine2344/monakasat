import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import '../models/tender_model.dart';
import '../models/tender_stage_model.dart';
import '../models/offer_model.dart';
import 'image_upload_service.dart';

class FirebaseService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  final ImageUploadService imageUploadService = ImageUploadService();

  Future<UserCredential?> signUp(
    String email,
    String password,
    String companyName,
    String role,
  ) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await firestore.collection('users').doc(userCredential.user!.uid).set({
        'companyName': companyName,
        'email': email,
        'role': role,
        'subscription': 'free',
      });
      return userCredential;
    } catch (e) {
      debugPrint("ERROR WHILE SIGNIN UP ==> ${e.toString()}");
      Get.snackbar('خطأ'.tr(), 'signup_failed'.tr());
      return null;
    }
  }

  Future<User?> login(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      Get.snackbar('خطأ'.tr(), 'login_failed'.tr());
      return null;
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
  }

  Stream<List<TenderModel>> getTenders() {
    return firestore.collection('projects').snapshots().asyncMap((
      snapshot,
    ) async {
      List<TenderModel> tenders = [];
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final userDoc = await firestore
            .collection('users')
            .doc(data['userId'])
            .get();
        final userData = userDoc.data();
        data['announcer'] = userData?['name'] ?? 'Unknown';
        tenders.add(TenderModel.fromJson(data, doc.id));
      }
      return tenders;
    });
  }

  /* Future<void> addTender(TenderModel tender) async {
    await firestore.collection('tenders').doc(tender.id).set(tender.toJson());
  } */

  Stream<List<TenderStageModel>> getTenderStages(String tenderId) {
    return firestore
        .collection('tender_stages')
        .where('tenderId', isEqualTo: tenderId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => TenderStageModel.fromJson(doc.data()))
              .toList(),
        );
  }

  Future<void> addTenderStage(TenderStageModel stage) async {
    await firestore
        .collection('tender_stages')
        .doc(stage.id)
        .set(stage.toJson());
  }

  Stream<List<OfferModel>> getOffers(String tenderId) {
    return firestore
        .collection('offers')
        .where('tenderId', isEqualTo: tenderId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => OfferModel.fromJson(doc.data()))
              .toList(),
        );
  }

  Future<void> addOffer(OfferModel offer) async {
    await firestore.collection('offers').doc(offer.id).set(offer.toJson());
    /* await messaging.sendMessage(
      to: '/topics/tender_${offer.tenderId}',
      data: {
        'title': 'New Offer'.tr(),
        'body': 'An offer has been submitted.'.tr(),
      },
    ); */
  }

  Future<String> uploadFile(File file, String path) async {
    return await imageUploadService.uploadImage(file);
  }

  Future<void> sendNotification(String topic, String title, String body) async {
    //TODO: IMPLEMENT NOTIFICATIONS
    /* await messaging.sendMessage(
      to: '/topics/$topic',
      data: {'title': title, 'body': body},
    ); */
  }
}
