import "package:get/get.dart";
import 'package:picknpark/models/models.dart';
import 'package:picknpark/services/services.dart';

class UserController extends GetxController {
  RxInt currentTab = 1.obs;

  void changeTab(int newTabIndex) {
    currentTab.value = newTabIndex;
  }

  final RxBool _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  void startLoading() => _isLoading.value = true;

  void stopLoading() => _isLoading.value = false;

  //////////////////////////////////////////////////////////////////////////////

  final Rx<User> user = User.empty().obs;

  void bindUser() {
    user.bindStream(UserDatabase(uID: Auth().uID).user);
  }

  clear(){
    user.value = User.empty();
  }
}