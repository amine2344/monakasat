import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import '../../../data/services/firebase_service.dart';

class AnnounceController extends GetxController {
  final FirebaseService firebaseService = Get.find<FirebaseService>();
  var isLoading = false.obs;
  var startDate = Rxn<DateTime>();
  var endDate = Rxn<DateTime>();

  void setStartDate(DateTime date) {
    startDate.value = date;
  }

  void setEndDate(DateTime date) {
    endDate.value = date;
  }

  Future<void> announceTender(
    String legalRequirements,
    FilePickerResult? selectedFile, {
    String? projectId,
    required String projectName,
    required String serviceType,
    required String requirements,
    required double budget,
  }) async {
    isLoading.value = true;
    try {
      final userId = firebaseService.auth.currentUser?.uid;
      if (userId == null) {
        Get.snackbar('error'.tr(), 'user_not_authenticated'.tr());
        return;
      }
      if (startDate.value == null || endDate.value == null) {
        Get.snackbar('error'.tr(), 'please_select_dates'.tr());
        return;
      }
      if (endDate.value!.isBefore(startDate.value!)) {
        Get.snackbar('error'.tr(), 'end_date_before_start'.tr());
        return;
      }

      final tenderData = {
        'userId': userId,
        'projectName': projectName,
        'serviceType': serviceType,
        'requirements': requirements,
        'budget': budget,
        'legalRequirements': legalRequirements,
        'startDate': startDate.value,
        'endDate': endDate.value,
        'createdAt': DateTime.now(),
        'stage': 'announced',
        'documentName': selectedFile?.files.single.name,
      };

      if (projectId != null) {
        await firebaseService.firestore
            .collection('projects')
            .doc(projectId)
            .update(tenderData);
      } else {
        await firebaseService.firestore.collection('projects').add(tenderData);
      }
      Get.snackbar('success'.tr(), 'tender_published'.tr());
      Get.offAllNamed('/my_offers');
    } catch (e) {
      Get.snackbar('error'.tr(), 'publish_tender_failed'.tr());
    } finally {
      isLoading.value = false;
    }
  }
}
