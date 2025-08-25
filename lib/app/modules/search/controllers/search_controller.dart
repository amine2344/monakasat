import 'package:get/get.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';

import '../../../data/models/tender_model.dart';
import '../../../data/services/firebase_service.dart';

class SearchController extends GetxController {
  final FirebaseService _firebaseService = Get.find<FirebaseService>();
  var searchResults = <TenderModel>[].obs;
  var searchQuery = ''.obs;
  var selectedWilayas = <String>[].obs;
  var selectedCategories = <String>[].obs;
  var selectedTenderType = ''.obs;
  var selectedDateRange = Rxn<DatePeriod>();
  var showFilters = false.obs;

  final List<String> categories = [
    'الزراعة والغابات والثروة الحيوانية',
    'المواد الغذائية',
    'الأثاث والمفروشات والاجهزة الكهرومنزلية',
    'الهندسة المعمارية و التصميم',
    'الخدمات البنكية و التأمين',
    'أشغال البناء والهندسة المدنية',
    'مواد كيمياوية',
    'مكائن ,تجهيزات ولوازم صناعية وقطع الغيار',
    'أجهزة مختبرية و معدات علمية',
    'معدات للمجتمعات ومعدات المدينة',
    'الصناعة الكهربائية ,أشغال الكهرباء و الإنارة العمومية',
    'الطاقة و الخدمات النفطية',
    'الدراسات و الإستشارات',
    'أعمال السباكة ، تبريد وتكييف وتسخين',
    'الملابس و النسيج',
    'الصرف الصحي وأشغال المياه',
    'الخدمات العقارية و التأجير',
    'طباعة و اعلام ,تعبئة و تغليف',
    'صناعة الورق والكرتون',
    'صناعات المعدات الإلكترونية و السمعية والبصرية',
    'الصناعات التحويلية',
    'تجهيزات ولوازم الكمبيوتر و الادوات المكتبية',
    'تكنولوجيا المعلومات و برمجة الحاسوب',
    'صناعات الصلب والمعادن ومواد البناء',
    'اجهزة وخدمات طبية وادوية',
    'مطارات, موانئ وسكك الحديد',
    'نجارة الخشب، الألمنيوم، الزجاج و أشغال ال PVC',
    'خدمات فندقية ومطاعم',
    'اعمال الترميم والتشطيب',
    'خدمات أمنية، الحراسة و المراقبة',
    'مجال الخدمات',
    'ادوات رياضية والعاب',
    'الشحن والنقل والخدمات الوجستية',
    'الأشغال العمومية (طرق, أرصفة ,جسور و أنفاق)',
    'أخرى',
    'الخدمات الإدارية ,المحاسبة و الإستشارية المالية',
    'التدريب وإصدار الشهادات',
    'السياحة والسفر',
    'خدمات الصيانة و النظافة',
    'صيانة المعدات الصناعية',
    'Consulting', // Added to match provided data
  ];

  final List<String> wilayas = [
    'ولاية أدرار',
    'ولاية الشلف',
    'ولاية الأغواط',
    'ولاية أم البواقي',
    'ولاية باتنة',
    'ولاية بجاية',
    'ولاية بسكرة',
    'ولاية بشار',
    'ولاية البليدة',
    'ولاية البويرة',
    'ولاية تمنراست',
    'ولاية تبسة',
    'ولاية تلمسان',
    'ولاية تيارت',
    'ولاية تيزي وزو',
    'ولاية الجزائر العاصمة',
    'ولاية الجلفة',
    'ولاية جيجل',
    'ولاية سطيف',
    'ولاية سعيدة',
    'ولاية سكيكدة',
    'ولاية سيدي بلعباس',
    'ولاية عنابة',
    'ولاية قالمة',
    'ولاية قسنطينة',
    'ولاية المدية',
    'ولاية مستغانم',
    'ولاية المسيلة',
    'ولاية معسكر',
    'ولاية ورقلة',
    'ولاية وهران',
    'ولاية البيض',
    'ولاية إليزي',
    'ولاية برج بوعريريج',
    'ولاية بومرداس',
    'ولاية الطارف',
    'ولاية تندوف',
    'ولاية تيسمسيلت',
    'ولاية الوادي',
    'ولاية خنشلة',
    'ولاية سوق أهراس',
    'ولاية تيبازة',
    'ولاية ميلة',
    'ولاية عين الدفلى',
    'ولاية النعامة',
    'ولاية عين تموشنت',
    'ولاية غرداية',
    'ولاية غليزان',
    'ولاية تيميمون',
    'ولاية برج باجي مختار',
    'ولاية بني عباس',
    'ولاية أولاد جلال',
    'ولاية عين صالح',
    'ولاية عين قزام',
    'ولاية تقرت',
    'ولاية جانت',
    'ولاية المغير',
    'ولاية المنيعة',
    'Constantine', // Added to match provided data
  ];

  final List<String> tenderTypes = [
    'نوع المناقصات',
    'مناقصات دولية محدودة',
    'مناقصات دولية مفتوحة',
    'مناقصات وطنية محدودة',
    'مناقصات وطنية مفتوحة',
    'مناقصات وطنية و دولية محدودة',
    'مناقصات وطنية و دولية مفتوحة',
    'استشارة وطنية مفتوحة',
    'استشارة وطنية محدودة',
    'استشارة دولية محدودة',
    'استشارة دولية مفتوحة',
    'مسابقة وطنية محدودة',
    'مسابقة وطنية مفتوحة',
    'اعلان عن تاهيل',
    'اشعاروطني مسبق محدود',
    'اشعاروطني مسبق مفتوح',
    'اشعاروطني و دولي مسبق محدود',
    'اشعاروطني و دولي مسبق مفتوح',
    'تمديد الاجال للمناقصة الوطنية المحدودة',
    'تمديد الاجال للمناقصة الوطنية المفتوحة',
    'تمديد الاجال للمناقصة الدولية المحدودة',
    'تمديد الاجال للمناقصة الدولية المفتوحة',
    'تمديد الاجال للمناقصة الوطنية و الدولية المحدودة',
    'تمديد الاجال للمناقصة الوطنية و الدولية المفتوحة',
    'التعبير عن اهتمام',
  ];

  @override
  void onInit() {
    super.onInit();
    searchTenders();
  }

  void toggleFilters() {
    showFilters.value = !showFilters.value;
  }

  void resetFilters() {
    searchQuery.value = '';
    selectedWilayas.clear();
    selectedCategories.clear();
    selectedTenderType.value = '';
    selectedDateRange.value = null;
    searchTenders();
  }

  void searchTenders() {
    _firebaseService.getTenders().listen((tenderList) {
      searchResults.assignAll(
        tenderList.where((tender) {
          final matchesQuery =
              searchQuery.value.isEmpty ||
              tender.projectName.toLowerCase().contains(
                searchQuery.value.toLowerCase(),
              ) ||
              (tender.requirements?.toLowerCase().contains(
                    searchQuery.value.toLowerCase(),
                  ) ??
                  false);
          final matchesWilaya =
              selectedWilayas.isEmpty ||
              (tender.wilaya != null &&
                  selectedWilayas.contains(tender.wilaya));
          final matchesCategory =
              selectedCategories.isEmpty ||
              (tender.category != null &&
                  selectedCategories.contains(tender.category));
          final matchesTenderType =
              selectedTenderType.value.isEmpty ||
              selectedTenderType.value == 'نوع المناقصات' ||
              tender.serviceType == selectedTenderType.value;
          final matchesDateRange =
              selectedDateRange.value == null ||
              (tender.startDate.isAfter(
                    selectedDateRange.value!.start.subtract(Duration(days: 1)),
                  ) &&
                  tender.endDate.isBefore(
                    selectedDateRange.value!.end.add(Duration(days: 1)),
                  ));
          return matchesQuery &&
              matchesWilaya &&
              matchesCategory &&
              matchesTenderType &&
              matchesDateRange;
        }).toList(),
      );
    });
  }
}
