import 'package:get/get.dart';

class ProviderAccountController extends GetxController {
  //TODO: Implement ProviderAccountController
  RxBool showServiceCard = false.obs;
  RxString selectedProfession = "Choose Your Profession".obs;
  RxString selectCategory = "Choose Category".obs;
  RxString selectSubCategory = "Choose Sub-category".obs;
  RxString selectCharge = "₹ ".obs;
  void toggleServiceCard() {
    showServiceCard.value = !showServiceCard.value;
  }
  var charge = "250".obs;
  void setCharge(String charge) {
    selectCharge.value = charge;
  }
  void setProfession(String profession) {
    selectedProfession.value = profession;
  }
  void setSubCategory(String SubCategory) {
    selectSubCategory.value = SubCategory;
  }
  void setCategory(String category) {
    selectCategory.value = category;
  }

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
