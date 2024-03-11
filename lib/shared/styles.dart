import 'package:fluttertoast/fluttertoast.dart';

final style = Style.value;

class Style {
  static Style get value => Style._();
  Style._();

  showToast(String message) => Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        fontSize: 14.0,
    );
}
