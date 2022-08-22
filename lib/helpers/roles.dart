import 'package:blood_bank_system/helpers/statics.dart';

bool get isDonationHallEmployee {
  return isConsultant ||
      isAdmin ||
      isPhlebotomist ||
      isExaminer ||
      isHbLabEmployee ||
      isBloodClassificationEmployee;
}

bool get isConsultant {
  return Variable.currentUser!.roles.isConsultant;
}

bool get isAdmin {
  return Variable.currentUser!.roles.isAdmin;
}

bool get isPhlebotomist {
  return Variable.currentUser!.roles.isPhlebotomist;
}

bool get isExaminer {
  return Variable.currentUser!.roles.isExaminer;
}

bool get isHbLabEmployee {
  return Variable.currentUser!.roles.isHbLabEmployee;
}

bool get isBloodClassificationEmployee {
  return Variable.currentUser!.roles.isBloodClassificationEmployee;
}

//

bool get isDiseasesDetectionEmployee {
  return Variable.currentUser!.roles.isDiseasesDetectionEmployee;
}

//
bool get isTemporaryStorageEmployee {
  return Variable.currentUser!.roles.isTemporaryStorageEmployee;
}

//
bool get isStorageEmployee {
  return Variable.currentUser!.roles.isTemporaryStorageEmployee;
}

