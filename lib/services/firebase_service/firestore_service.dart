import 'package:agro_vision/models/farm_plot_model.dart';
import 'package:agro_vision/models/user_data_model.dart';
import 'package:agro_vision/services/gemini_service/models/crop_calendar_response_model.dart';
import 'package:agro_vision/services/gemini_service/models/recommendations_for_crop_response_model.dart';
import 'package:agro_vision/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:rxdart/rxdart.dart';

class FirestoreService {
  // Firebase Firestore and Auth instances
  static final _db = FirebaseFirestore.instance;
  static final _firebaseAuth = FirebaseAuth.instance;

  // 🔹 Add a single chat message and update request count if needed
  static addMessage({
    required types.Message message,
    required Function() onMessageAdded,
  }) async {
    try {
      WriteBatch batch = _db.batch();
      String userId = FirebaseAuth.instance.currentUser?.uid ?? "";

      var messageDoc = _db.collection(AppConstants.messages).doc(message.id);
      batch.set(messageDoc, message.toJson(), SetOptions(merge: true));

      // Update chatbot request count only if the message is from the user
      if (message.author.id == "user") {
        var userDataDoc = _db.collection(AppConstants.userData).doc(userId);

        // Check if 24+ hrs passed and reset limits if required
        bool resetSuccess =
            await FirestoreService().checkAndResetUserRequestLimits(
          userDataDoc: userDataDoc,
          batch: batch,
          chatbotRequestsLeft: 4,
        );

        // If not reset, decrement the count and update timestamp
        if (!resetSuccess) {
          batch.update(userDataDoc, {
            'chatBotRequestsLeft': FieldValue.increment(-1),
            'lastTimeRequestsUpdated': FieldValue.serverTimestamp(),
          });
        }
      }

      await batch.commit();
      onMessageAdded(); // Notify UI
    } catch (e) {
      if (kDebugMode) debugPrint("Error: $e");
    }
  }

  // 🔹 Delete all messages in batch
  static deleteAllMessages({
    required List<types.Message> messageList,
    required Function() onAllMessageDeleted,
  }) async {
    WriteBatch batch = _db.batch();
    var messagesCollection = _db.collection(AppConstants.messages);
    try {
      for (var message in messageList) {
        var docRef = messagesCollection.doc(message.id);
        batch.delete(docRef);
      }
      await batch.commit();
      onAllMessageDeleted(); // Notify UI
    } catch (e) {
      if (kDebugMode) debugPrint("Error: $e");
    }
  }

  // 🔹 Get stream of messages for the current user
  static Stream<QuerySnapshot<Map<String, dynamic>>> getMessageList() {
    return _firebaseAuth.userChanges().switchMap((user) {
      if (user != null && user.uid.isNotEmpty) {
        try {
          return _db
              .collection(AppConstants.messages)
              .where("roomId", isEqualTo: user.uid)
              .orderBy(AppConstants.createdAt, descending: true)
              .snapshots();
        } catch (e) {
          return Stream.error("Error occurred while fetching the messages");
        }
      } else {
        return const Stream.empty();
      }
    });
  }

  // 🔹 Add a new farm plot
  static addFarmPlot({
    required FarmPlotModel farmPlot,
    required Function() onFarmPlotAdded,
  }) async {
    try {
      await _db
          .collection(AppConstants.farmPlots)
          .doc(farmPlot.id)
          .set(farmPlot.toJson(), SetOptions(merge: true));

      await onFarmPlotAdded();
    } catch (e) {
      if (kDebugMode) debugPrint("Error: $e");
    }
  }

  // 🔹 Update an existing farm plot
  static updateFarmPlot({
    required FarmPlotModel farmPlot,
    required Function() onFarmPlotUpdated,
  }) async {
    try {
      await _db
          .collection(AppConstants.farmPlots)
          .doc(farmPlot.id)
          .update(farmPlot.toJson());

      await onFarmPlotUpdated();
    } catch (e) {
      if (kDebugMode) debugPrint("Error: $e");
    }
  }

  // 🔹 Delete a farm plot by ID
  static deleteFarmPlot({
    required FarmPlotModel farmPlot,
    required Function() onFarmPlotDeleted,
  }) async {
    try {
      await _db.collection(AppConstants.farmPlots).doc(farmPlot.id).delete();

      await onFarmPlotDeleted();
    } catch (e) {
      if (kDebugMode) debugPrint("Error: $e");
    }
  }

  // 🔹 Delete a farm plot and its associated crop calendar
  static deleteFarmPlotAndCropCalendar({
    required String farmPlotId,
    required Function() onFarmPlotAndCropCalendarDeleted,
  }) async {
    WriteBatch batch = _db.batch();

    try {
      var farmPlotDocRef =
          _db.collection(AppConstants.farmPlots).doc(farmPlotId);
      batch.delete(farmPlotDocRef);

      // Delete the crop calendar related to the same farmPlotId
      var cropCalendarDoc = await _db
          .collection(AppConstants.cropCalendars)
          .where("farmPlotId", isEqualTo: farmPlotId)
          .limit(1)
          .get();

      batch.delete(cropCalendarDoc.docs.first.reference);
      await batch.commit();
      onFarmPlotAndCropCalendarDeleted();
    } catch (e) {
      if (kDebugMode) debugPrint("Error: $e");
    }
  }

  // 🔹 Get list of farm plots for current user
  static Stream<QuerySnapshot<Map<String, dynamic>>> getFarmPlotList() {
    return _firebaseAuth.userChanges().switchMap((user) {
      if (user != null && user.uid.isNotEmpty) {
        try {
          return _db
              .collection(AppConstants.farmPlots)
              .where("userId", isEqualTo: user.uid)
              .snapshots();
        } catch (e) {
          return Stream.error("Error occurred while fetching the farm plots");
        }
      } else {
        return const Stream.empty();
      }
    });
  }

  // 🔹 Get list of crop calendar responses for current user
  static Stream<QuerySnapshot<Map<String, dynamic>>>
      getCropCalendarReponseList() {
    return _firebaseAuth.userChanges().switchMap((user) {
      if (user != null && user.uid.isNotEmpty) {
        try {
          return _db
              .collection(AppConstants.cropCalendars)
              .where("userId", isEqualTo: user.uid)
              .snapshots();
        } catch (e) {
          return Stream.error(
              "Error occurred while fetching the crop calendars");
        }
      } else {
        return const Stream.empty();
      }
    });
  }

  // 🔹 Add a crop calendar entry and update request limits
  static addCropCalendar({
    required CropCalendarResponseModel cropCalendarResponse,
    required Function() onCropCalendarAdded,
  }) async {
    try {
      WriteBatch batch = _db.batch();
      String userId = FirebaseAuth.instance.currentUser?.uid ?? "";

      var cropCalendarDoc = _db
          .collection(AppConstants.cropCalendars)
          .doc(cropCalendarResponse.id);
      var userDataDoc = _db.collection(AppConstants.userData).doc(userId);

      batch.set(cropCalendarDoc, cropCalendarResponse.toJson(),
          SetOptions(merge: true));

      bool resetSuccess =
          await FirestoreService().checkAndResetUserRequestLimits(
        userDataDoc: userDataDoc,
        batch: batch,
        cropCalendarRequestsLeft: 1,
      );

      if (!resetSuccess) {
        batch.update(userDataDoc, {
          'cropCalendarRequestsLeft': FieldValue.increment(-1),
          'lastTimeRequestsUpdated': FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();
      onCropCalendarAdded();
    } catch (e) {
      if (kDebugMode) debugPrint("Error in firestore crop calendar: $e");
    }
  }

  // 🔹 Update an existing crop calendar
  static updateCropCalendar({
    required CropCalendarResponseModel cropCalendarResponse,
    required Function() onCropCalendarUpdated,
  }) async {
    try {
      await _db
          .collection(AppConstants.cropCalendars)
          .doc(cropCalendarResponse.id)
          .update(cropCalendarResponse.toJson());

      onCropCalendarUpdated();
    } catch (e) {
      if (kDebugMode) debugPrint("Error in firestore crop calendar: $e");
    }
  }

  // 🔹 Get list of crop recommendations for current user
  static Stream<QuerySnapshot<Map<String, dynamic>>>
      getRecommendationsForCropList() {
    return _firebaseAuth.userChanges().switchMap((user) {
      if (user != null && user.uid.isNotEmpty) {
        try {
          return _db
              .collection(AppConstants.recommendationsForCrops)
              .where("userId", isEqualTo: user.uid)
              .snapshots();
        } catch (e) {
          return Stream.error("Error occurred while fetching recommendations");
        }
      } else {
        return const Stream.empty();
      }
    });
  }

  // 🔹 Add crop recommendation and update request limits
  static addRecommendationsForCrop({
    required RecommendationsForCropResponseModel recommendationsForCropResponse,
    required Function() onRecommendationsAdded,
  }) async {
    try {
      WriteBatch batch = _db.batch();
      String userId = FirebaseAuth.instance.currentUser?.uid ?? "";

      var recommendationsDoc = _db
          .collection(AppConstants.recommendationsForCrops)
          .doc(recommendationsForCropResponse.id);

      var userDataDoc = _db.collection(AppConstants.userData).doc(userId);

      bool resetSuccess =
          await FirestoreService().checkAndResetUserRequestLimits(
        userDataDoc: userDataDoc,
        batch: batch,
        cropSuggestionsRequestsLeft: 2,
      );

      batch.set(recommendationsDoc, recommendationsForCropResponse.toJson(),
          SetOptions(merge: true));

      if (!resetSuccess) {
        batch.update(userDataDoc, {
          'cropSuggestionsRequestsLeft': FieldValue.increment(-1),
          'lastTimeRequestsUpdated': FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();
      onRecommendationsAdded();
    } catch (e) {
      if (kDebugMode) {
        debugPrint("Error in firestore recommendations for crop: $e");
      }
    }
  }

  // 🔹 Add user data
  static addUserData({
    required UserDataModel userData,
    required Function() onUserDataAdded,
  }) async {
    try {
      await _db
          .collection(AppConstants.userData)
          .doc(userData.id)
          .set(userData.toJson(), SetOptions(merge: true));

      onUserDataAdded();
    } catch (e) {
      if (kDebugMode) {
        debugPrint("Error in firestore while adding user data: $e");
      }
    }
  }

  // 🔹 Update user data
  static updateUserData({
    required UserDataModel userData,
    required Function() onUserDataUpdated,
  }) async {
    try {
      await _db
          .collection(AppConstants.userData)
          .doc(userData.id)
          .update(userData.toJson());

      onUserDataUpdated();
    } catch (e) {
      if (kDebugMode) {
        debugPrint("Error in firestore while updating the user data: $e");
      }
    }
  }

  // 🔹 Get user data document stream for the current user
  static Stream<DocumentSnapshot<Map<String, dynamic>>> getUserDataById() {
    return _firebaseAuth.userChanges().switchMap((user) {
      if (user != null && user.uid.isNotEmpty) {
        try {
          return _db
              .collection(AppConstants.userData)
              .doc(user.uid)
              .snapshots();
        } catch (e) {
          return Stream.error("Error occurred while fetching user data");
        }
      } else {
        return const Stream.empty();
      }
    });
  }

  // 🔹 Check if request limits should be reset based on last updated time
  Future<bool> checkAndResetUserRequestLimits({
    required DocumentReference userDataDoc,
    required WriteBatch batch,
    int cropCalendarRequestsLeft = 2,
    int cropSuggestionsRequestsLeft = 3,
    int chatbotRequestsLeft = 5,
  }) async {
    final userSnapshot = await userDataDoc.get();

    if (!userSnapshot.exists) return false;

    final data = userSnapshot.data() as Map<String, dynamic>;

    final Timestamp? lastUpdatedTimestamp = data['lastTimeRequestsUpdated'];
    final DateTime lastUpdated =
        lastUpdatedTimestamp?.toDate() ?? DateTime(2000);
    final now = DateTime.now();

    // For production, change to `.inHours >= 24`
    if (now.difference(lastUpdated).inHours >= 24) {
      await userDataDoc.update({
        'cropCalendarRequestsLeft': cropCalendarRequestsLeft,
        'cropSuggestionsRequestsLeft': cropSuggestionsRequestsLeft,
        'chatBotRequestsLeft': chatbotRequestsLeft,
        'lastTimeRequestsUpdated': FieldValue.serverTimestamp(),
      });
      return true;
    } else {
      return false;
    }
  }
}
