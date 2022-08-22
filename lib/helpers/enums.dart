enum Gender{
  male,
  female,
}

enum ClientStatus{
  available,
  banned,
}

enum DonorFormStatus{
  accepted,
  rejected,
  pending,
}

enum DonorFormStage{
  bloodClassificationAndHbLab,
  examining,
  bloodDrawing,
  diseasesDetection,
  temporaryStorage,
  finnish,
}

enum BagStatus{
  pending,
  accepted,
  rejected,
}

enum BagStage{
  temporaryStorage,
  storage,
  disposed,
}

enum RejectionCause{
  hbDeficiency,

  //
  hIV,
  hBV,
  hCV,
  syphilis,
  //

  other
}

enum Disease{
  noDisease,
  //Human immunodeficiency virus (HIV)
  hIV,
  //Hepatitis B virus (HBV)
  hBV,
  //Hepatitis C virus (HCV)
  hCV,
  //Treponema pallidum (syphilis)
  syphilis
}

enum MaskType{
  date
}


