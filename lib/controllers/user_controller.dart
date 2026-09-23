import 'package:check_in/Services/user_services.dart';
import 'package:check_in/controllers/subscription_controller.dart';
import 'package:check_in/model/user_modal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  UserServices userServices;
  UserController(this.userServices);

  Rx<UserModel> userModel = UserModel().obs;
  RxList blockProfiles = [].obs;

  void updateGoldenCheckin(int newGoldenCheckin) {
    userModel.update((val) {
      val?.goldenCheckin = newGoldenCheckin;
    });
  }

  Future<void> getUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || uid.isEmpty) return;

    UserModel? userData = await userServices.getUserData(uid);
    if (userData == null) {
      // Auth session without Firestore profile — create a minimal one.
      await userServices.ensureUserProfile(
        uid: uid,
        email: FirebaseAuth.instance.currentUser?.email,
        userName: FirebaseAuth.instance.currentUser?.displayName,
      );
      userData = await userServices.getUserData(uid);
    }
    if (userData != null) {
      userModel.value = userData;
      userModel.value.isPremium =
          (Get.put(SubscriptionController()).hasActivePremiumSubscription());
      blockProfiles.addAll(userData.blockProfiles ?? []);
    }
  }

  /// block profile
  Future<bool> blockProfile(String profileId, String userId) async {
    final res = await userServices.blockProfile(profileId, userId);
    if (res) {
      blockProfiles.add(profileId);
      return true;
    } else {
      return false;
    }
  }
}
