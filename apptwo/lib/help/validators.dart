String? validateEmail(String? value) {
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(value ?? '')) {
    return 'Email Invalid';
  } else {
    return null;
  }
}

String? validatePassword(String? value) {
  RegExp uppercase = RegExp(r'^(?=.*?[A-Z])');
  RegExp numeric = RegExp(r'^(?=.*?[0-9])');

  if ((value?.length ?? 0) < 8) {
    return 'Password required at least 8 characters in length';
  } else if (!uppercase.hasMatch(value!)) {
    return "Password required at least on uppercase character";
  } else if (!numeric.hasMatch(value)) {
    return "Password required at least one digit";
  } else {
    return null;
  }
}

String? validateMobile(String? value) {
  String pattern = r'(^\+?[0-9]*$)';
  RegExp regExp = RegExp(pattern);
  if (value!.isEmpty) {
    return 'MobRequired';
  } else if (!regExp.hasMatch(value)) {
    return 'MobValid';
  }
  /*else if(value!.length<10 || value.length>10 ){
  return 'please enter valid number'.tr;
  }*/
  return null;
}

String? validateEmptyFieldD(String? text) =>
    text == null || text.isEmpty ? '' : null;

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}
