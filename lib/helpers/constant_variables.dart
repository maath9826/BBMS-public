const domain = '@bloodbanksystem.com';

const firebaseConfig = {
  "apiKey": "AIzaSyDWx6UktW7b08OoBmNFPdaopwflIMl_vGc",
  "authDomain": "bb-system-a4d9b.firebaseapp.com",
  "projectId": "bb-system-a4d9b",
  "storageBucket": "bb-system-a4d9b.appspot.com",
  "messagingSenderId": "50248671524",
  "appId": "1:50248671524:web:5c107d87c99a0926e893b1",
  "measurementId": "G-ME7GYN66ML"
};

const pagePadding = 50.0;

const searchButtonHeight = 40.0;

class CollectionsName{
  static const donorForms = 'donorForms';
  static const bags = 'bags';
}

const bloodGroups = [
  'A+',
  'A-',
  'B+',
  'B-',
  'AB+',
  'AB-',
  'O+',
  'O-',
];

const provinces = [
  'Al Anbar',
  'Babylon',
  'Baghdad',
  'Basra',
  'Dhi Qar',
  'Diyala',
  'Duhok',
  'Erbil',
  'Karbala',
  'Kirkuk',
  'Maysan',
  'Muthanna',
  'Najaf',
  'Saladin',
  'Sulaymaniyah',
  'Wasit',
];

const minHbFemale = 12;
const minHbMale = 13;

class UnbanDuration{
  static const hbDeficiency = 90;
  static const hBV = 60;
  static const hCV = 180;
  static const syphilis = 45;
}