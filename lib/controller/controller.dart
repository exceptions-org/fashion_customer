import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_customer/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController{
UserModel userModel = UserModel(name: "", number: "", adress: []);

  Future<void> getUser()async{
   User? user = FirebaseAuth.instance.currentUser;
   if(user!=null){
     DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('users').doc(user.phoneNumber?.substring(2)).get();
        userModel = UserModel.fromMap(snapshot.data()!);
        (await SharedPreferences.getInstance())
            .setString('user', userModel.toJson());
   }
  }

}
                    