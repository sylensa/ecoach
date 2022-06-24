import 'package:ecoach/helper/helper.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInApi {
  GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> signIn(Function(String? idToken) callback) async {
    try {
      await _googleSignIn.signIn().then((result) {
        result!.authentication.then((googleKey) async {
          // print(googleKey.accessToken);
          print(googleKey.idToken);
          // print(_googleSignIn.currentUser!.displayName);
          callback(googleKey.idToken);
        }).catchError((err) {
          print('inner error');
        });
      }).catchError((err, m) {
        print('error occured');
        print(err);
        print(m);
      });
    } catch (error) {
      print(error);
    }
  }
  Future<void> signOut() async {
    try {
     _googleSignIn.disconnect();
    } catch (err) {
      print("error:$err");
    }
  }

}
