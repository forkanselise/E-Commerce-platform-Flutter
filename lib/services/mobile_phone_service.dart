import '../models/mobile_phone.dart';
import 'api_service.dart';

class MobilePhoneService {
  static Future<List<MobilePhone>> fetchMobilePhones() async {
    final res = await ApiService.get('/MobilePhones');
    if (res != null && res is List && res.isNotEmpty) {
      return res.map((p) => MobilePhone.fromJson(p)).toList();
    }
    return INITIAL_PHONES;
  }
}
