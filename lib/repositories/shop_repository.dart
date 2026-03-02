import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flaguiz/models/shop_model.dart';

class ShopRepository {
  ShopRepository();

  final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

  Stream<List<ShopModel>> loadShopDataList(String category) {
    return firestoreInstance
        .collection(category)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return ShopModel.fromJson(doc.data());
      }).toList();
    });
  }

  Future<ShopModel?> getShopItemById(String id,String category) async {
    final doc = await firestoreInstance
        .collection(category)
        .doc(id)
        .get();
    if (doc.exists && doc.data() != null) {
      return ShopModel.fromJson(doc.data()!);
    } else {
      return null;
    }
  }
}
