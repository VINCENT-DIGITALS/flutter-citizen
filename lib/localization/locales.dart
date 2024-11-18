import 'package:flutter_localization/flutter_localization.dart';

const List<MapLocale> LOCALES = [
  MapLocale("en", LocaleData.EN),
  MapLocale("tl", LocaleData.TL),
];

mixin LocaleData {
  //FRIENDSS
  static const String addfriends = 'addfriends';
  static const String searchnSendfriends = 'searchnSendfriends';
  static const String searchFriends = 'searchFriends';
  static const String sendFriends = 'sendFriends';
  static const String sendFriendsPrompt = 'sendFriendsPrompt';
  static const String friendrequestSuccess = 'friendrequestSuccess';
  static const String friendrequest = 'friendrequest';
  static const String friendrequestManage = 'friendrequestManage';
  static const String friendrequestNoPending = 'friendrequestNoPending';
  static const String friendList = 'friendList';
  static const String friendManage = 'friendManage';
  static const String friendShow = 'friendShow';
  static const String friendRemove = 'friendRemove';
  static const String friendNothing = 'friendNothing';

  // report page
  static const String howtousereport = 'howtousereport';
  static const String howtousereportDesc = 'howtousereportDesc';
  static const String reportImage = 'reportImage';
  static const String reportCurrentAddress = 'reportCurrentAddress';
  static const String locationSuccess = 'locationSuccess';
  static const String locationError = 'locationError';
  static const String reportLandmark = 'reportLandmark';
  static const String reportLandmarkDesc = 'reportLandmarkDesc';
  static const String reportTypeAccident = 'reportTypeAccident';
  static const String reportInjured = 'reportInjured';
  static const String reportSeriousness = 'reportSeriousness';
  static const String reportDesc = 'reportDesc';
  static const String reportSubmit = 'reportSubmit';
  static const String reportSubmittedSuccess = 'reportSubmittedSuccess';

  static const String sosTriggered = 'sosTriggered';
  static const String after10 = 'after10';
  static const String cancel = 'cancel';
  static const String yourSos = 'yourSos';
  static const String close = 'close';
  static const String weather = 'weather';
  static const String report = 'report';
  static const String evacuationCenter = 'evacuationCenter';
  static const String hotlineDirec = 'hotlineDirec';
  static const String announcements = 'announcements';
  static const String title = 'title';
  static const String body = 'body';
  static const String welcomeMessage = 'welcomeMessage';
  static const String signInTextT = 'signInTextT';
  static const String signUpTextT = 'signUpTextT';
  static const String continueWith = 'continueWith';
  static const String forgotPass = 'forgotPass';
  static const String notAMember = 'notAMember';
  static const String registerNow = 'registerNow';
  static const String internetConnect = 'internetConnect';
  static const String internetDisconnect = 'internetDisconnect';
  static const String homeLocal = 'homeLocal';
  static const String createAccount = 'createAccount';
  static const String alreadyHaveAccount = 'alreadyHaveAccount';
  static const String loginNow = 'loginNow';
  static const String completeForm = 'completeForm';

  static const String validEmail = 'validEmail';
  static const String filloutAllFields = 'filloutAllFields';
  static const String emaillPassWrong = 'emaillPassWrong';

  static const String enteremaill = 'enteremaill';
  static const String passwordresetbeensent = 'passwordresetbeensent';
  // static const String passwordresetbeensent = 'passwordresetbeensent';

  static const String send = 'send';
  static const String guest = 'guest';
  //SIGN UP PAGE
  static const String fullName = 'fullName';
  static const String confirmPass = 'confirmPass';
  static const String passwordNotMatch = 'passwordNotMatch';
  static const String phonenumber = 'phonenumber';
  static const String accountCreated = 'accountCreated';
  static const String accountExist = 'accountExist';
  //Drawer
  static const String hello = 'hello';
  static const String justhello = 'justhello';
  static const String general = 'general';
  static const String hotlineDirectories = 'hotlineDirectories';
  static const String emergencyGuides = 'emergencyGuides';
  static const String firstAidTips = 'firstAidTips';
  static const String fireSafetyTips = 'fireSafetyTips';
  static const String cPR = 'cPR';
  static const String personalSafety = 'personalSafety';
  static const String mentalHealth = 'mentalHealth';
  static const String moreGuides = 'moreGuides';
  static const String account = 'account';
  static const String userProfile = 'userProfile';
  static const String friendsCircle = 'friendsCircle';
  static const String app = 'app';
  static const String aboutCDRRMO = 'aboutCDRRMO';
  static const String privacyPolicy = 'privacyPolicy';
  static const String aboutApp = 'aboutApp';

  //Bottom Navbar
  static const String home = 'home ';
  static const String reports = 'reports';
  static const String updates = 'updates';
  static const String friends = 'friends';
  static const String settings = 'settings';

  //First Aid Tips page
  static const String cPRDesc = 'cPRDesc';
  static const String bleedingDesc = 'bleedingDesc';
  static const String burnDesc = 'burnDesc';
  static const String chokingDesc = 'chokingDesc';
  static const String poisoningDesc = 'poisoningDesc';
  static const String cardiopulmonaryR = 'cardiopulmonaryR';
  static const String bleeding = 'bleeding';
  static const String burns = 'burns';
  static const String choking = 'choking';
  static const String poisoning = 'poisoning';

  //Fire safety tips page
  static const String installSmokeAlarms = 'installSmokeAlarms';
  static const String createAnEscapePlan = 'createAnEscapePlan';
  static const String installSmokeAlarmsDesc = 'installSmokeAlarmsDesc';
  static const String createAnEscapePlanDesc = 'createAnEscapePlanDesc';

  //CPR PAGE
  static const String cprPage = 'cprPage';
  static const String cprPageDesc = 'cprPageDesc';
  static const String cprPageDescNum = 'cprPageDescNum';

  //Personal Safety page
  static const String personalSafetyTips = 'personalSafetyTips';
  static const String personalSafetyTipsDesc = 'personalSafetyTipsDesc';

  //Mental Health Page
  static const String mentalHealthAwareness = 'mentalHealthAwareness';
  static const String mentalHealthAwarenessDesc = 'mentalHealthAwarenessDesc';
  static const String selfCareTips = 'selfCareTips';
  static const String selfCareTipsDesc = 'selfCareTipsDesc';

  //Natural Disaster
  static const String naturalDisaster = 'naturalDisaster';
  static const String naturalDisasterGuide = 'naturalDisasterGuide';
  static const String naturalDisasterGuideDesc = 'naturalDisasterGuideDesc';
  static const String naturalDisasterprep = 'naturalDisasterprep';
  static const String naturalDisasterprepdesc = 'naturalDisasterprepdesc';
  static const String naturalDisasterDuring = 'naturalDisasterDuring';
  static const String naturalDisasterDuringdesc = 'naturalDisasterDuringdesc';
  static const String naturalDisasterAfter = 'naturalDisasterAfter';
  static const String naturalDisasterAfterdesc = 'naturalDisasterAfterdesc';
  static const String naturalDisasterContacts = 'naturalDisasterContacts';
  static const String naturalDisasterContactsdesc =
      'naturalDisasterContactsdesc';

  //Social Disaster
  static const String socialDisaster = 'socialDisaster';
  static const String socialDisasterGuide = 'socialDisasterGuide';
  static const String socialDisasterGuideDesc = 'socialDisasterGuideDesc';
  static const String socialDisasterprep = 'socialDisasterprep';
  static const String socialDisasterprepdesc = 'socialDisasterprepdesc';
  static const String socialDisasterDuring = 'socialDisasterDuring';
  static const String socialDisasterDuringdesc = 'socialDisasterDuringdesc';
  static const String socialDisasterAfter = 'socialDisasterAfter';
  static const String socialDisasterAfterdesc = 'socialDisasterAfterdesc';
  static const String socialDisasterContacts = 'socialDisasterContacts';
  static const String socialDisasterContactsdesc = 'socialDisasterContactsdesc';

  //Life safety
  static const String lifeSafety = 'lifeSafety';
  static const String lifeSafetyGuide = 'lifeSafetyGuide';
  static const String lifeSafetyDesc = 'lifeSafetyDesc';
  static const String firstAidBasics = 'firstAidBasics';
  static const String firstAidBasicsDesc = 'firstAidBasicsDesc';
  static const String trafficAccidentResponse = 'trafficAccidentResponse';
  static const String trafficAccidentResponseDesc =
      'trafficAccidentResponseDesc';
  static const String homeSafetyTips = 'homeSafetyTips';
  static const String homeSafetyTipsDesc = 'homeSafetyTipsDesc';
  static const String lifeSafetyContacts = 'lifeSafetyContacts';
  static const String lifeSafetyContactsDesc = 'lifeSafetyContactsDesc';

  //Emergency preparedness
  static const String emergencyPreparedness = 'emergencyPreparedness';
  static const String emergencyPreparednessGuide = 'emergencyPreparednessGuide';
  static const String emergencyPreparednessGuideDesc =
      'emergencyPreparednessGuideDesc';
  static const String emergencyPreparednessKit = 'emergencyPreparednessKit';
  static const String emergencyPreparednessKitDesc =
      'emergencyPreparednessKitDesc';
  static const String emergencyPreparednessFamilyPlan =
      'emergencyPreparednessFamilyPlan';
  static const String emergencyPreparednessFamilyPlanDesc =
      'emergencyPreparednessFamilyPlanDesc';
  static const String emergencyPreparednessprepHome =
      'emergencyPreparednessprepHome';
  static const String emergencyPreparednessprepHomeDesc =
      'emergencyPreparednessprepHomeDesc';
  static const String emergencyPreparednessContacts =
      'emergencyPreparednessContacts';
  static const String emergencyPreparednessContactsDesc =
      'emergencyPreparednessContactsDesc';

  //SafetyGuides
  static const String safetyGuides = 'safetyGuides';
//About CDRMMO
  static const String aboutCDRRMOGuide = 'aboutCDRRMOGuide';
  static const String aboutCDRRMOGuideDesc = 'aboutCDRRMOGuideDesc';
  static const String aboutCDRRMOMission = 'aboutCDRRMOMission';
  static const String aboutCDRRMOMissionDesc = 'aboutCDRRMOMissionDesc';
  static const String aboutCDRRMOVission = 'aboutCDRRMOVission';
  static const String aboutCDRRMOVissionDesc = 'aboutCDRRMOVissionDesc';

//About APP
  static const String aboutAppguide = 'aboutAppguide';
  static const String aboutAppguideDesc = 'aboutAppguideDesc';
  static const String aboutAppKeyfeatures = 'aboutAppKeyfeatures';
  static const String aboutAppKeyfeaturesDesc = 'aboutAppKeyfeaturesDesc';
  static const String aboutAppMission = 'aboutAppMission';
  static const String aboutAppMissionDesc = 'aboutAppMissionDesc';
  static const String aboutAppContactUs = 'aboutAppContactUs';
  static const String aboutAppContactUsDesc = 'aboutAppContactUsDesc';

  //PRIVACY POLICY
  static const String privacyPolicyDate = 'privacyPolicyDate';
  static const String privacyPolicyContactUs = 'privacyPolicyContactUs';
  static const String privacyPolicyContactUsDesc = 'privacyPolicyContactUsDesc';
  static const String privacyPolicydatacontroller =
      'privacyPolicydatacontroller';
  static const String privacyPolicyContactdatacontrollerDesc =
      'privacyPolicyContactdatacontrollerDesc';
  static const String privacyPolicyContactEmail = 'privacyPolicyContactEmail';
  static const String privacyPolicydatacollected = 'privacyPolicydatacollected';
  static const String privacyPolicydatacollectedDesc =
      'privacyPolicydatacollectedDesc';
  static const String privacyPolicydatacollectedContactInfo =
      'privacyPolicydatacollectedContactInfo';
  static const String privacyPolicydatacollectedContactInfoDesc =
      'privacyPolicydatacollectedContactInfoDesc';
  static const String privacyPolicydatacollectedProfileInfo =
      'privacyPolicydatacollectedProfileInfo';
  static const String privacyPolicydatacollectedProfileInfoDesc =
      'privacyPolicydatacollectedProfileInfoDesc';
  static const String privacyPolicydatacollectedIncidentDetails =
      'privacyPolicydatacollectedIncidentDetails';
  static const String privacyPolicydatacollectedIncidentDetailsDesc =
      'privacyPolicydatacollectedIncidentDetailsDesc';
  static const String privacyPolicydatacollectedLocationData =
      'privacyPolicydatacollectedLocationData';
  static const String privacyPolicydatacollectedLocationDataDesc =
      'privacyPolicydatacollectedLocationDataDesc';
  static const String privacyPolicyWhycollectdata =
      'privacyPolicyWhycollectdata';
  static const String privacyPolicyWhycollectdataDesc =
      'privacyPolicyWhycollectdataDesc';
  static const String privacyPolicyWhycollectdataPurposes =
      'privacyPolicyWhycollectdataPurposes';
  static const String privacyPolicyDataVisibility =
      'privacyPolicyDataVisibility';
  static const String privacyPolicyDataVisibilityDesc =
      'privacyPolicyDataVisibilityDesc';
  static const String privacyPolicyyourRights = 'privacyPolicyyourRights';
  static const String privacyPolicyyourRightsDesc =
      'privacyPolicyyourRightsDesc';
  static const String privacyPolicyyourRightsAccessToData =
      'privacyPolicyyourRightsAccessToData';
  static const String privacyPolicyyourRightsAccessToDataDesc =
      'privacyPolicyyourRightsAccessToDataDesc';
  static const String privacyPolicyyourRightsDataCorrection =
      'privacyPolicyyourRightsDataCorrection';
  static const String privacyPolicyyourRightsDataCorrectionDesc =
      'privacyPolicyyourRightsDataCorrectionDesc';
  static const String privacyPolicyyourRightsDataDeletion =
      'privacyPolicyyourRightsDataDeletion';
  static const String privacyPolicyyourRightsDataDeletionDesc =
      'privacyPolicyyourRightsDataDeletionDesc';
  static const String privacyPolicyyourRightsUsageRestrict =
      'privacyPolicyyourRightsUsageRestrict';
  static const String privacyPolicyyourRightsUsageRestrictDesc =
      'privacyPolicyyourRightsUsageRestrictDesc';
  static const String privacyPolicyyourRightsLocationSettings =
      'privacyPolicyyourRightsLocationSettings';
  static const String privacyPolicyyourRightsLocationSettingsDesc =
      'privacyPolicyyourRightsLocationSettingsDesc';
  static const String privacyPolicyDisclaimer = 'privacyPolicyDisclaimer';
  static const String privacyPolicyDisclaimerDesc =
      'privacyPolicyDisclaimerDesc';
  static const String privacyPolicyDisclaimerDescLast =
      'privacyPolicyDisclaimerDescLast';
  static const String allrightreserved = 'allrightreserved';
  static const String reportAddressIcon = 'reportAddressIcon';
  static const String reportDescDesc = 'reportDescDesc';

  static const Map<String, dynamic> EN = {
    //FRIENDSS
    addfriends: 'Add Friends',
    searchnSendfriends: 'Search and send friend requests',
    searchFriends: 'Search for friends',
    sendFriends: 'Send Friend Request',
    sendFriendsPrompt: 'Are you sure you want to send a friend request?',
    friendrequestSuccess: 'Friend request sent successfully!',
    friendrequest: 'Friend Requests',
    friendrequestManage: 'View and manage friend requests',
    friendrequestNoPending: 'No pending friend requests',
    friendList: 'Friends List',
    friendManage: 'View and manage friends',
    friendShow: 'Show Location',
    friendRemove: 'Remove Friend',
    friendNothing: 'No friends yet',

    // report page
    howtousereport: 'How to Use?',
    howtousereportDesc:
        'Complete all fields if possible, and turning on location is required. Video is limited to 5 seconds only.',
    reportImage: 'Image',
    reportCurrentAddress: 'This is your current address:',
    reportAddressIcon: 'Click the icon to find your location ->',
    locationSuccess: 'SUCCESS: Access to your location has been granted.',
    locationError: 'Failed to retrieve your location. Please try again.',
    reportLandmark: 'Landmark',
    reportLandmarkDesc: 'Enter an easily recognizable establishment…',
    reportTypeAccident: 'Type of Incident',
    reportInjured: '# of Injured',
    reportSeriousness: 'Seriousness',
    reportDesc: 'Report Description',
    reportDescDesc: 'Enter a short description of the report here…',
    reportSubmit: 'Submit Report',
    reportSubmittedSuccess:
        'Report is submitted successfully. Media was also added to the gallery.',

    sosTriggered: 'SOS Triggered!',
    after10:
        'After 10 seconds, your SOS and location will be sent to your Friends.',
    cancel: 'Cancel',
    yourSos:
        'Your SOS with the location has been sent. Please wait for help or take the necessary actions.',
    close: 'Close',
    title: 'ENGLISH',
    body: 'Welcome to this localized Flutter application, %a',
    welcomeMessage: 'Welcome to our BAYANi app!',
    signInTextT: 'Sign In',
    signUpTextT: 'Sign up',
    continueWith: ' Or continue with',
    forgotPass: 'Forgot Password?',
    notAMember: 'Not a member yet?',
    registerNow: 'Register now',
    internetConnect: 'You are connected to the internet',
    internetDisconnect: 'You are not connected to the internet.',
    homeLocal: 'Home',
    createAccount: 'Create Account',
    alreadyHaveAccount: 'Already Have an Account?',
    loginNow: 'Login here',
    completeForm: 'Complete the Form',
    hello: 'Hello, %s!',
    justhello: 'Hello!',

    validEmail: 'Please enter a valid email address.',
    filloutAllFields: 'Fill out all fields.',
    emaillPassWrong: 'Please enter the correct Email/Password',
    enteremaill: 'Please enter a valid email address.',
    passwordresetbeensent: 'Password reset has been sent to your email.',
    // static const String passwordresetbeensent = 'passwordresetbeensent';
    accountExist: 'Account does not exist!',
    send: 'Send',
    guest: 'Guest',

    //SIGN UP PAGE
    fullName: 'Full Name',
    confirmPass: 'Confirm Password',
    passwordNotMatch: 'Password did Not Match, Please try again',
    phonenumber: 'Phone Number',
    accountCreated: "Account Successfully Created And Email Verification Has been sent to your Email!",

    general: 'general',
    hotlineDirectories: 'Hotline Directories',
    emergencyGuides: 'Emergency Guides',
    firstAidTips: 'First Aid Tips',
    fireSafetyTips: 'Fire Safety Tips',
    cPR: 'CPR',
    personalSafety: 'Personal Safety',
    mentalHealth: 'Mental Health',
    moreGuides: 'More Guides',
    account: 'Account',
    userProfile: 'User Profile',
    friendsCircle: 'Friends/Circle',
    app: 'App',
    aboutCDRRMO: 'About CDRRMO',
    privacyPolicy: 'Privacty Policy',
    aboutApp: 'About App',
    home: 'Home',
    reports: 'History Reports',
    updates: 'Updates',
    friends: 'Friends',
    settings: 'Settings',
    cPRDesc:
        '1. Call for help immediately.\n2. Push hard and fast in the center of the chest (100-120 compressions per minute)\n3. Open the airway and give rescue breaths if trained.',
    bleedingDesc:
        '1. Apply direct pressure to the wound with a clean cloth or bandage.\n2. Elevate the injured area above the heart if possible.\n3. Seek medical attention if bleeding does not stop.',
    burnDesc:
        '1. Cool the burn with running water for at least 10 minutes.\n2. Cover the burn with a sterile, non-stick bandage or cloth.\n3. Avoid using ice as it can cause further damage.',
    chokingDesc:
        '1. Encourage the person to keep coughing if they can.\n2. Perform back blows and abdominal thrusts (Heimlich maneuver) if the person cannot breathe.\n3. Call for emergency help if the obstruction persists.',
    poisoningDesc:
        '1. Call emergency services or a poison control center immediately.\n2. Do not induce vomiting unless directed by a healthcare professional.\n3. Provide as much information as possible about the substance ingested.',
    cardiopulmonaryR: 'CPR (Cardiopulmonary Resuscitation)',
    bleeding: 'Bleeding',
    burns: 'Burns',
    choking: 'Choking',
    poisoning: 'Poisoning',

    //Fire safety tips page
    installSmokeAlarms: 'Install Smoke Alarms',
    createAnEscapePlan: 'Create an Escape Plan',
    installSmokeAlarmsDesc:
        'Ensure there are working smoke alarms on every level of your home, especially near bedrooms. Test them monthly and replace batteries yearly.',
    createAnEscapePlanDesc:
        'Identify two ways out of every room in your home, and ensure all members of your household practice the escape plan.',

    //CPR PAGE
    cprPage: 'CPR (Cardiopulmonary Resuscitation)',
    cprPageDesc:
        "CPR is a life-saving procedure used when someone's breathing or heart stops. Here are the basaic steps:",
    cprPageDescNum:
        '1. Call emergency services immediately.\n2. Begin chest compressions: Push hard and fast in the center of the chest, 100-120 times per minute.\n3. If trained, alternate with rescue breaths: Tilt the head back, lift the chin, and give two breaths after every 30 compressions.',

    //Personal Safety page
    personalSafetyTips: 'Personal Safety Tips',
    personalSafetyTipsDesc:
        '1. Always be aware of your surroundings, especially in unfamiliar areas.\n2. Trust your instincts. If something doesn’t feel right, leave the situation.\n3. Carry a personal safety device, such as a whistle or pepper spray, if needed.',

    //Mental Health Page
    mentalHealthAwareness: 'Mental Health Awareness',
    mentalHealthAwarenessDesc:
        'Mental Health is just as important as physical health. It includes our emotional, psychological, and social well-being. Mental health affects how we think, feel, and act, and it plays a role in how we handle stress, relate to others, and make choices.',
    selfCareTips: 'Self-Care Tips for Mental Health',
    selfCareTipsDesc:
        "1. Stay Connected\nReach out to family and friends, and try not to isolate yourself.\n\n2. Exercise Regularly\nPhysical activity can help reduce anxiety and improve mood.\n\n3. Practice Mindfulness\nMeditation, deep breathing, and yoga can helo you stay grounded.\n\n4. Get Enough Sleep\nMake sure to have a regular sleep schedule and get enough rest.\n\n5. Seek Help\nIf you feel overwhelmed, don't hesitate to talk to a professional.",

    naturalDisaster: 'NATURAL DISASTER',
    naturalDisasterGuide: 'Natural Disater Guide',
    naturalDisasterGuideDesc:
        'Natural disasters such as earthquakes, hurricanes, and floods can strike with little or no warning. This guide will help you prepare for, respond to, and recover from these events.',
    naturalDisasterprep: 'Preparation',
    naturalDisasterprepdesc:
        '1. Create an emergency plan for your family, including evacuation routes and communication methods.\n2. Prepare an emergency kit with essentials such as water, food, medications, and important documents.\n3. Stay informed about the risks in your area and sign up for emergency alerts.\n',
    naturalDisasterDuring: 'During a Natural Disaster',
    naturalDisasterDuringdesc:
        '1. Follow evacuation orders and move to higher ground if necessary.\n2. Stay indoors and away from windows during severe weather.\n3. Listen to local authorities and follow their instructions.',
    naturalDisasterAfter: 'After a Natural Disaster',
    naturalDisasterAfterdesc:
        '1. Check for injuries and provide first aid as needed.\n2. Avoid downed power lines and flooded areas.\n3. Contact your insurance company to report any damage.',
    naturalDisasterContacts: 'Emergency Contacts',
    naturalDisasterContactsdesc:
        'Keep a list of emergency contacts, including local authorities, hospitals, and family members, in your emergency kit.',

    //Social Disaster
    socialDisaster: 'SOCIAL DISASTER',
    socialDisasterGuide: 'Social Disaster Guide',
    socialDisasterGuideDesc:
        'Social disasters such as civil unrest, mass gatherings, or pnademics can have significant impacts on communities. This guide provides strategies for staying safe and informed.',
    socialDisasterprep: 'Before a Social Disaster',
    socialDisasterprepdesc:
        '1. Stay informed about potential social disruptions in your area through news outlets and social media.\n2. Develop a communication plan with your family in case of an emergency.\n3, Keep an emergency kit ready, including masks, sanitizers, and non-perishable food.',
    socialDisasterDuring: 'During a Social Disaster',
    socialDisasterDuringdesc:
        "1. Avoid areas where large crowds are gathering to reduce the risk of injury or exposure to dangerous situations.\n2. Follow local authorities’ instructions. Including curfews and evacuation orders.\n3. Stay connected with friends and family to ensure everyone's safety.",
    socialDisasterAfter: 'After a Social Disaster',
    socialDisasterAfterdesc:
        '1. Check on your family or neighbors, especially those who are elderly or disabled.\n2. Report any damage or suspicious activity to local authorities.\n3. Seek support from community organizations if you are in need of assistance.',
    socialDisasterContacts: 'Emergency Contacts',
    socialDisasterContactsdesc:
        'Keep a list of important contacts, including local authorities, emergency services, and family members, readily available.',

    //Social Disaster
    lifeSafety: 'Life Safety',
    lifeSafetyGuide: 'Life Safety Guide',
    lifeSafetyDesc:
        'Life safety involves taking precautions to protect yourself and others from accidents, injuries, and other emergencies. This guide covers essential tips and best practices.',
    firstAidBasics: 'First Aid Basics',
    firstAidBasicsDesc:
        '1. Learn basic first aid skills, including CPR, wound care, and how to treat burns.\n2, Keep a well-stocked first aid kit at home, in your car, and at work.\n3. Know the emergency numbers for your area and when to call for professional help.',
    trafficAccidentResponse: 'Traffic Accident Response',
    trafficAccidentResponseDesc:
        '1. If you witness an accident, pull over safely and call emergency services immdiately.\n2. Provide assistance it it is safe to do so, such as moving victims out of immediate dnager and administering first aid.\n3. Stay on the scene until help arrives and provide information to authorities.',
    homeSafetyTips: 'Home Safety Tips',
    homeSafetyTipsDesc:
        '1. Install smoke detectors on every floor of your home and test them monthly.\n2. Create and practice a fire escape plan with your family, ensuring everyone knows at least two ways to exit every room.\n3. Keep a fire extinguisher in an accessible location and learn how to use it properly.',
    lifeSafetyContacts: 'Émergecny Contacts',
    lifeSafetyContactsDesc:
        'Ensure you have a list of emergency contacts, including local emergency services, family members, and nearby neigbors who can assist in an emergency.',

    //Emergency preparedness
    emergencyPreparedness: 'EMERGENCY PREPAREDNESS',
    emergencyPreparednessGuide: 'Emergency Preparedness Guide',
    emergencyPreparednessGuideDesc:
        'Being prepared for emergencies can make all the difference when disaster strikes. This guide offers tips on how to prepare for various emergencies and what to include in your emergency kit.',
    emergencyPreparednessKit: 'Creating an Emergency Kit',
    emergencyPreparednessKitDesc:
        '1. Water\nHave at least one gallon of water per person per day for at least three days.\n\n2. Food\nStore at least a three-day supply of non-perishable food.\n\n3. Medications\nInclude a supply of necessary medications, as well as basic first aid supplies.\n\n4. Tools\nKeep a flashlight, extra batteries, a multi-tool, and a manual can opener.\n\n5. Important Documents\nKeep copies of personal documents, including IDs, insurance policies, and bank information, in a waterproof container.',
    emergencyPreparednessFamilyPlan: 'Developing a Family Communication Plan',
    emergencyPreparednessFamilyPlanDesc:
        '1. Choose an out-of-town contact person whom all family members can check in with during an emergency.\n2. Establish a meeting place near your home in case of a sudden emergency.\n3. Make sure everyone in your household knows how to send text messages, phone lines may be overloaded during a disaster.',
    emergencyPreparednessprepHome: 'Preparing Your Home',
    emergencyPreparednessprepHomeDesc:
        '1. Secure heavy items such as bookcases, refrigerators, televisions, and objects that hang on walls. These can cause injuries during an earthquake or other emergencies.\n2. Install smoke alarms and carbon monoxide detectors on every level of your home and check them regularly.\n3. Know how to shut off utilities such as gas, water, and electricity.',
    emergencyPreparednessContacts: 'Emergency Contacts',
    emergencyPreparednessContactsDesc:
        'Ensure you have a list of emergency contacts, including local authorities, utility companies, and family members, easily accessible.',

    safetyGuides: 'Safety Guides',

    aboutAppguide: 'BAYANi - Emergency Response App',
    aboutAppguideDesc:
        'BAYANi is a mobile application designed specifically for the residents of Science City of Muñoz. The emergency response app aims to provide fast and reliable assistance during various emergencies, including natural disasters, medical situations, fire incidents, and other critical situations.',
    aboutAppKeyfeatures: 'Key Features',
    aboutAppKeyfeaturesDesc:
        '• Quick emergency contact with local authorities and responders.\n•Real-time notifications and alerts for city-wide emergencies.\n•First aid guides and safety tips for various emergency situations.\n•GPS location sharing for fast and accurate response.\n•Access to important resources like evacuation maps and emergency hotlines.',
    aboutAppMission: 'Our Mission',
    aboutAppMissionDesc:
        'BAYANi aims to empower the community of Science City of Muñoz by providing a reliable, easy-to use tool that ensures immediate response and proper guidance during emergencies. We believe in the importance of community safety and preparedness, string to be a beacon of help in times of need.',
    aboutAppContactUs: 'Contact Us',
    aboutAppContactUsDesc:
        'For feedback, suggestions, or assistance, please reach us out at:',

    //About CDRMMO
    aboutCDRRMOGuide: 'About CDRRMO',
    aboutCDRRMOGuideDesc:
        'The City Disaster Risk Reduction and Management Office (CDRRMO) is responsible for disaster preparedness, risk mitigation, response, recovery, initiatives within the city. It operates in coordination with local, national, and international partners to ensure effective disaster management. The key areas of focus include emergency response, capacity building, and public education.',
    aboutCDRRMOMission: 'Mission',
    aboutCDRRMOMissionDesc:
        'To enhance the safety and resilience of the community by implementing effective disaster risk management strategies.',
    aboutCDRRMOVission: 'Vision',
    aboutCDRRMOVissionDesc:
        'A disaster-resilient city where citizens are prepared and informed about disaster risks and management protocols.',

    //PRIVACY POLICY
    privacyPolicyDate: 'Effective Date: 11/09/2024',
    privacyPolicyContactUs: 'CONTACT US',
    privacyPolicyContactUsDesc:
        'For questions about data protection or requests regarding your personal data, please reach out to us. We aim to address inquiries promptly to ensure a smooth and secure experience with BAYANi.',
    privacyPolicydatacontroller: 'Data Controller: ',
    privacyPolicyContactdatacontrollerDesc:
        'City Disaster Risk Reduction Management Office (CDRRMO), Science City of Muñoz, Nueva Ecija',
    privacyPolicyContactEmail: 'Email: ',
    privacyPolicydatacollected: 'THE DATA WE COLLECT',
    privacyPolicydatacollectedDesc:
        'The BAYANi application collects data to enhance emergency response and ensure accurate, timely communication between users and emergency responders. This includes:',
    privacyPolicydatacollectedContactInfo: '• Contact Information',
    privacyPolicydatacollectedContactInfoDesc:
        '(e.g., name, phone number, and email address) for identification and to establish contact during emergencies.',
    privacyPolicydatacollectedProfileInfo: '• Profile Information ',
    privacyPolicydatacollectedProfileInfoDesc:
        'for user recognition within the application.',
    privacyPolicydatacollectedIncidentDetails: '• Incident Details ',
    privacyPolicydatacollectedIncidentDetailsDesc:
        '(e.g., photos, videos, and locations) to provide real-time updates on reported incidents.',
    privacyPolicydatacollectedLocationData: '• Location Data ',
    privacyPolicydatacollectedLocationDataDesc:
        'for the accurate tracking and mapping of incidents in real time.',
    privacyPolicyWhycollectdata: 'WHY WE COLLECT YOUR DATA',
    privacyPolicyWhycollectdataDesc:
        'To provide effective emergency response services, BAYANi collects and processes the following data for the purposes of:',
    privacyPolicyWhycollectdataPurposes:
        '• Account Creation and Management - Ensuring that users can create and manage accounts securely.\n• Emergency Services Operation - Collecting incident information to help responders assess and address emergencies quickly.\n• Service Improvement - Analyzing usage data to refine application features and improve service efficiency.\n• Communication - Sending service-related notifications and updates relevant to ongoing emergencies or community safety.',
    privacyPolicyDataVisibility: 'DATA VISIBILITY AND SHARING',
    privacyPolicyDataVisibilityDesc:
        'Only authorized personnel within the City Disaster Risk Reduction Management Office (CDRRMO) and responding emergency units have access to the data you share within BAYANi. Select information, such as verified incident reports, may be visible to registered users and relevant authorities to maintain community awareness and safety.',
    privacyPolicyyourRights: 'YOUR RIGHTS AND OPTIONS',
    privacyPolicyyourRightsDesc:
        'Users of BAYANi are entitled to the following rights concerning their personal data:',
    privacyPolicyyourRightsAccessToData: '• Access to Data',
    privacyPolicyyourRightsAccessToDataDesc:
        '- Request an electronic copy of your personal data.',
    privacyPolicyyourRightsDataCorrection: '• Data Correction',
    privacyPolicyyourRightsDataCorrectionDesc:
        '- Update any inaccurate information in your profile.',
    privacyPolicyyourRightsDataDeletion: '• Data Deletion',
    privacyPolicyyourRightsDataDeletionDesc:
        '- Request deletion of your data (subject to limitations related to ongoing emergencies).',
    privacyPolicyyourRightsUsageRestrict: '• Usage Restriction',
    privacyPolicyyourRightsUsageRestrictDesc:
        '- Restrict or object to how we process your data',
    privacyPolicyyourRightsLocationSettings: '• Location Settings',
    privacyPolicyyourRightsLocationSettingsDesc:
        '- Adjust or disable GPS-based location sharing on your device (disabling this may limit certain emergency response functions of the app).',
    privacyPolicyDisclaimer: 'DISCLAIMER',
    privacyPolicyDisclaimerDesc:
        "Any images, videos, or information you upload may be verified according to emergency response protocols. However, BAYANi and the City Disaster Risk Reduction Management Office (CDRRMO) bear no responsibility for the accuracy of user-uploaded information.\nBy using this application, users consent to the visibility of their reported incidents, including any associated images or videos, to relevant authorities and users within the application's system.\nThe CDRRMO is not liable for any damages arising directly or indirectly from inaccuracies in user-provided information.",
    privacyPolicyDisclaimerDescLast:
        'Thank you for using BAYANi to help strengthen community safety in Science City of Muñoz. Please contact us with any questions regarding this policy or to exercise your rights related to personal data.',
    allrightreserved: 'All rights reserved.',
    weather: 'Weather',
    report: 'File a Report',
    evacuationCenter: 'Evacuation Center',
    hotlineDirec: 'Hotline Directories',
    announcements: 'Announcements',
  };

  static const Map<String, dynamic> TL = {
       //FRIENDSS
    addfriends: 'Magdagdag ng Kaibigan',
    searchnSendfriends: 'Maghanap at magpadala ng request sa kaibigan',
    searchFriends: 'Maghanap ng kaibigan',
    sendFriends: 'Magpadala ng friend request',
    sendFriendsPrompt: 'Sigurado ka bang gusto mong magpadala ng kahilingan sa kaibigan?',
    friendrequestSuccess: 'Matagumpay na naipadala ang friend request!  ',
    friendrequest: 'Mga Friend Request',
    friendrequestManage: 'Tingnan at pamahalaan ang mga friend request',
    friendrequestNoPending: 'Walang mga naka-pending na request',
    friendList: 'Listahan ng mga Kaibigan',
    friendManage: 'Tingnan at pamahalaan ang mga kaibigan',
    friendShow: 'Ipakita ang Lokasyon',
    friendRemove: 'Alisin ang Kaibigan',
    friendNothing: 'Wala pang mga kaibigan',
    // report page
    howtousereport: 'Paano Gamitin?',
    howtousereportDesc:
        'Kumpletuhin ang lahat ng mga patlang kung maaari, at kinakailangang buksan ang lokasyon. Ang video ay limitado sa 5 segundo lamang.',
    reportImage: 'Larawan',
    reportCurrentAddress: 'Ito ang iyong kasalukuyang address:',
    reportAddressIcon: 'I-click ang icon upang mahanap ang iyong lokasyon ->',
    locationSuccess: 'TAGUMPAY: May access na sa iyong lokasyon.',
    locationError: 'Nabigong makuha ang iyong lokasyon. Pakisubukang muli.',
    reportLandmark: 'Palatandaan',
    reportLandmarkDesc: 'Maglagay ng madaling makilalang establisyemento…',
    reportTypeAccident: 'Uri ng Insidente',
    reportInjured: '# ng mga Nasugatan',
    reportSeriousness: 'Tindi',
    reportDesc: 'Deskripsyon ng Ulat',
    reportDescDesc: 'Maglagay ng maikling deskripsyon ng ulat dito…',
    reportSubmit: 'Ipadala ang Ulat',
    reportSubmittedSuccess:
        'Matagumpay na naipadala ang ulat. Ang media ay idinagdag din sa gallery.',

    sosTriggered: 'Na-trigger ang SOS!',
    after10:
        'Pagkatapos ng 10 segundo, ang iyong SOS at lokasyon ay ipapadala sa iyong mga Kaibigan.',
    cancel: 'Kanselahin',
    yourSos:
        ' Naipadala na ang iyong SOS kasama ang lokasyon. Mangyaring maghintay ng tulong o gawin ang kinakailangang aksyon.',
    close: 'Isara',
    weather: 'Panahon',

    report: 'Mag-ulat',
    evacuationCenter: 'Mapa ng Paglikas',
    hotlineDirec: 'Mga Directory ng Hotline',
    announcements: 'Mga Anunsyo',
    title: 'TAGALOG',
    body: 'Maligayang pagdating sa lokal na aplikasyong Flutter na ito, %a',
    welcomeMessage: 'Maligayang Pagdating sa BAYANi App!',
    signInTextT: 'Mag Sign In',
    signUpTextT: 'Mag Sign up',
    continueWith: ' O magpatuloy sa',
    forgotPass: 'Nakalimutan ang Password?',
    notAMember: 'Hindi pa miyembro?',
    registerNow: 'Magparehistro dito',
    internetConnect: 'Ikaw ay konektado sa internet',
    internetDisconnect: 'Ikaw ay hindi konektado sa internet.',
    homeLocal: 'Home',
    createAccount: 'Gumawa ng Account',
    alreadyHaveAccount: 'May Account na?',
    loginNow: 'Mag Login dito',
    completeForm: 'Kompletohin ang Pormularyo',
    hello: 'Pagbati, %s!',
    justhello: 'Pagbati!',

    validEmail: 'Pakilagay ang wastong email address.',
    filloutAllFields: 'Punan ang lahat ng mga patlang.',
    emaillPassWrong: 'Ilagay ang wastong Email/Password',
    enteremaill: 'Pakilagay ang wastong email address.',
    passwordresetbeensent:
        'Ang pag-reset ng password ay ipinadala sa iyong email.',
    // static const String passwordresetbeensent = 'passwordresetbeensent';
    accountExist: 'Wala ka pang account na nagagawa!',
    send: 'Ipadala',
    guest: 'Bisita',

    //SIGN UP PAGE
    fullName: 'Buong Pangalan',
    confirmPass: 'Kumpirmahin ang Password',
    passwordNotMatch: 'Hindi tumutugma ang password. Pakisubukang muli.',
    phonenumber: 'Numero ng Telepono',
    accountCreated: 'Tagumpay na nagawa ang iyong account at ang Pagpapatunay ng Email ay Ipinadala na sa Iyong Email!!',

    general: 'Pangkalahatan',
    hotlineDirectories: 'Mga Directory ng Hotline',
    emergencyGuides: 'Mga Gabay sa Emergency',
    firstAidTips: 'Mga Tip sa Unang Lunas',
    fireSafetyTips: 'Mga Tip sa Kaligtasan sa Sunog',
    cPR: 'CPR',
    personalSafety: 'Personal na Kaligtasan',
    mentalHealth: 'Kalusugang Pangkaisipan',
    moreGuides: 'Mas Maraming Gabay',
    account: 'Account',
    userProfile: 'Profile ng Gumagamit',
    friendsCircle: 'Mga Kaibigan',
    app: 'App',
    aboutCDRRMO: 'Tungkol sa CDRRMO',
    privacyPolicy: 'Pribadong Patnubay',
    aboutApp: 'Tungkol sa App',
    home: 'Home',
    reports: 'Mga Na-Ulat',
    updates: 'Updates',
    friends: 'Kaibigan',
    settings: 'Settings',
    cPRDesc:
        '1. Humingi ng tulong agad-agad.\n2. Pindutin nang malakas at mabilis sa gitna ng dibdib (100-120 na pagdiin kada minuto).\n3. Buksan ang daanan ng hangin at bigyan ng rescue breaths kung ikaw ay may pagsasanay.',
    bleedingDesc:
        '1. Maglagay ng direktang presyon sa sugat gamit ang malinis na tela o benda.\n2. Itaas ang nasugatang bahagi sa itaas ng puso kung maaari.\n3. Maghanap ng medikal na tulong kung hindi humihinto ang pagdurugo.',
    burnDesc:
        '1. Palamigin ang paso gamit ang dumadaloy na tubig nang hindi bababa sa 10 minuto.\n2. Takpan ang paso gamit ang sterile at hindi-dikit na benda o tela.\n3. Iwasang gumamit ng yelo dahil maaari itong magdulot ng karagdagang pinsala.',
    chokingDesc:
        '1. Himukin ang tao na patuloy na umubo kung kaya pa niya.\n2. Gumawa ng pagbuga sa likod at pagtulak sa tiyan (Heimlich maneuver) kung hindi na makahinga ang tao.\n3. Tumawag ng emergency help kung nananatili ang bara.',
    poisoningDesc:
        "1. Tumawag agad ng mga serbisyong pang-emergency o poison control center.\n2. Huwag piliting magsuka maliban na lamang kung sinabihan ng propesyonal na medikal.\n3. Magbigay ng maraming impormasyon hangga't maaari tungkol sa nilunok na substansya.",
    cardiopulmonaryR: 'CPR (Cardiopulmonary Resuscitation)',
    bleeding: 'Bleeding',
    burns: 'Mga Paso',
    choking: 'Pagkakabara',
    poisoning: 'Pagkalason',

    //Fire safety tips page
    installSmokeAlarms: 'Maglagay ng mga Smoke Alarm ',
    createAnEscapePlan: 'Gumawa ng Plano sa Paglikas',
    installSmokeAlarmsDesc:
        'Siguraduhing may gumaganang smoke alarm sa bawat palapag ng iyong tahanan, lalo na malapit sa mga silid-tulugan. Subukin ito buwan-buwan at palitan ang baterya taun-taon.',
    createAnEscapePlanDesc:
        'Maghanap ng dalawang daan palabas sa bawat silid ng iyong tahanan, at tiyaking ang lahat ng miyembro ng pamilya ay nasasanay sa plano ng paglikas.',

    //CPR PAGE
    cprPage: 'CPR (Cardiopulmonary Resuscitation)',
    cprPageDesc:
        "Ang CPR ay isang pamamaraang panglunas na ginagamit kapag ang paghinga o tibok ng puso ng isang tao ay huminto. Narito ang mga pangunahing hakbang:",
    cprPageDescNum:
        '1. Tumawag agad sa mga serbisyong pang-emergency.\n2. Magsimula ng pagdiin sa dibdib: Pindutin nang malakas at mabilis sa gitna ng dibdib, 100-120 beses kada minuto.\n3. Kung may pagsasanay, magbigay ng rescue breaths: Itingala ang ulo, itaas ang baba, at magbigay ng dalawang paghinga pagkatapos ng bawat 30 na pagdiin.',

    //Personal Safety page
    personalSafetyTips: 'Mga Tip sa Personal na Kaligtasan',
    personalSafetyTipsDesc:
        '1. Laging maging alerto sa iyong paligid, lalo na sa mga hindi pamilyar na lugar.\n2. Pakinggan ang iyong kutob. Kung may hindi magandang pakiramdam, umalis sa sitwasyon.\n3. Magdala ng personal na kagamitang pangkaligtasan tulad ng pito o pepper spray kung kinakailangan.',

    //Mental Health Page
    mentalHealthAwareness: 'Kamayaman sa Kalusugang Pangkaisipan',
    mentalHealthAwarenessDesc:
        'Ang kalusugang pangkaisipan ay kasinghalaga ng pisikal na kalusugan. Kasama nito ang ating emosyonal, sikolohikal, at panlipunang kagalingan. Ang kalusugang pangkaisipan ay nakakaapekto kung paano tayo nag-iisip, nararamdaman, at kumikilos, at ito rin ay may papel sa kung paano tayo humaharap sa stress, nakikisalamuha sa iba, at gumagawa ng mga desisyon.',
    selfCareTips: 'Mga Tip sa Pag-aalaga para sa Kalusugang Pangkaisipan',
    selfCareTipsDesc:
        '1. Manatiling Konektado\nMakipag-ugnayan sa pamilya at mga kaibigan, at iwasan ang pag-iisa.\n\n2. Mag-ehersisyo nang Regular\nAng pisikal na aktibidad ay makakatulong sa pagpapababa ng stress at pagpapabuti ng mood.\n\n3. Magsanay ng Mindfulness\nAng meditasyon, malalim na paghinga, at yoga ay makakatulong upang manatiling kalmado.\n\n4. Matulog nang Sapat\nSiguraduhing may regular na iskedyul sa pagtulog at sapat na pahinga.\n\n5. Humingi ng Tulong\nKung pakiramdam mo ay lubos kang nabibigatan, huwag mag-atubiling kumonsulta sa propesyonal.',

    naturalDisaster: 'LIKAS NA SAKUNA',
    naturalDisasterGuide: 'Gabay sa Likas na Sakuna',
    naturalDisasterGuideDesc:
        'Ang mga likas na sakuna tulad ng lindol, bagyo, at pagbaha ay maaaring mangyari nang biglaan o walang babala. Ang gabay na ito ay makakatulong sa iyo na maghanda, tumugon, at makabangon mula sa mga ganitong pangyayari.',
    naturalDisasterprep: 'Paghahanda',
    naturalDisasterprepdesc:
        '1. Gumawa ng emergency plan para sa iyong pamilya, kabilang ang mga ruta ng paglikas at paraan ng komunikasyon.\n2. Maghanda ng emergency kit na naglalaman ng mga pangunahing pangangailangan tulad ng tubig, pagkain, gamot, at mahahalagang dokumento.\n3. Manatiling may kaalaman sa mga panganib sa iyong lugar at magparehistro para sa emergency alerts.',
    naturalDisasterDuring: 'Habang may Likas na Sakuna',
    naturalDisasterDuringdesc:
        '1. Sundin ang mga utos ng paglikas at pumunta sa mas mataas na lugar kung kinakailangan.\n2. Manatili sa loob ng bahay at lumayo sa mga bintana sa panahon ng matinding lagay ng panahon.\n3. Makinig sa mga lokal na awtoridad at sundin ang kanilang mga tagubilin.',
    naturalDisasterAfter: 'Pagkatapos ng Likas na Sakuna',
    naturalDisasterAfterdesc:
        '1. Suriin kung may mga sugat at magbigay ng unang lunas kung kinakailangan.\n2. Iwasan ang mga nakahandusay na linya ng kuryente at mga binahang lugar.\n3. Makipag-ugnayan sa iyong kompanya ng insurance upang iulat ang anumang pinsala.',
    naturalDisasterContacts: 'Mga Emergency Contact ',
    naturalDisasterContactsdesc:
        'Magkaroon ng listahan ng mga emergency contact, kabilang ang mga lokal na awtoridad, ospital, at mga miyembro ng pamilya, sa iyong emergency kit.',

    //Social Disaster
    socialDisaster: 'SOSYAL NA SAKUNA',
    socialDisasterGuide: 'Gabay sa Sosyal na Sakuna',
    socialDisasterGuideDesc:
        'Ang mga sosyal na sakuna tulad ng kaguluhang sibil, malalaking pagtitipon, o pandemya ay maaaring magkaroon ng malaking epekto sa mga komunidad. Ang gabay na ito ay nagbibigay ng mga estratehiya upang manatiling ligtas at may kaalaman.',
    socialDisasterprep: 'Bago ang Sosyal na Sakuna',
    socialDisasterprepdesc:
        '1. Manatiling may kaalaman tungkol sa mga posibleng abalang pang-sosyal sa iyong lugar sa pamamagitan ng balita at social media.\n2. Gumawa ng plano ng komunikasyon kasama ang iyong pamilya sakaling magkaroon ng emergency.\n3. Maghanda ng emergency kit na may kasamang mga mask, sanitizer, at hindi madaling masirang pagkain.',
    socialDisasterDuring: 'Habang may Sosyal na Sakuna',
    socialDisasterDuringdesc:
        '1. Iwasan ang mga lugar kung saan may malalaking pagtitipon upang mabawasan ang panganib ng pinsala o mapanganib na sitwasyon.\n2. Sundin ang mga tagubilin ng lokal na awtoridad, kabilang ang mga curfew at utos ng paglikas./n3. Manatiling nakikipag-ugnayan sa mga kaibigan at pamilya upang matiyak ang kaligtasan ng bawat isa.',
    socialDisasterAfter: 'Pagkatapos ng Sosyal na Sakuna',
    socialDisasterAfterdesc:
        '1. Suriin ang kalagayan ng iyong pamilya o mga kapitbahay, lalo na ang mga matatanda o may kapansanan.\n2. Iulat ang anumang pinsala o kahina-hinalang aktibidad sa mga lokal na awtoridad.\n3. Humingi ng suporta mula sa mga organisasyong pangkomunidad kung kailangan ng tulong.',
    socialDisasterContacts: 'Mga Emergency Contact ',
    socialDisasterContactsdesc:
        'Magkaroon ng listahan ng mga importanteng contact, kabilang ang mga lokal na awtoridad, emergency services, at mga miyembro ng pamilya, na madaling makuha.',

    //Social Disaster
    lifeSafety: 'KALIGTASAN SA BUHAY',
    lifeSafetyGuide: 'Gabay sa Kaligtasan sa Buhay',
    lifeSafetyDesc:
        'Ang kaligtasan sa buhay ay nangangahulugan ng pag-iingat upang maprotektahan ang sarili at ang iba mula sa aksidente, pinsala, at iba pang emerhensya. Ang gabay na ito ay naglalaman ng mga mahahalagang tip at tamang gawain.',
    firstAidBasics: 'Mga Batayang Kaalaman sa Unang Lunas',
    firstAidBasicsDesc:
        '1. Matutunan ang mga pangunahing kasanayan sa unang lunas tulad ng CPR, pangangalaga sa sugat, at paggamot sa paso.\n2. Magkaroon ng kumpletong first aid kit sa bahay, sa sasakyan, at sa trabaho.\n3. Alamin ang mga emergency numbers sa iyong lugar at kailan tatawag para sa propesyonal na tulong.',
    trafficAccidentResponse: 'Pagtugon sa Aksidente sa Kalsada',
    trafficAccidentResponseDesc:
        '1. Kung saksi ka sa aksidente, huminto sa ligtas na lugar at tumawag ng emergency services agad.\n2. Magbigay ng tulong kung ligtas itong gawin, tulad ng pag-alis sa mga biktima mula sa panganib at pagbibigay ng unang lunas.\n3. Manatili sa lugar hanggang sa dumating ang tulong at magbigay ng impormasyon sa mga awtoridad.',
    homeSafetyTips: 'Mga Tip sa Kaligtasan sa Bahay',
    homeSafetyTipsDesc:
        '1. Maglagay ng smoke detectors sa bawat palapag ng iyong bahay at subukin ito buwan-buwan.\n2. Gumawa at magsanay ng plano sa paglikas mula sa sunog kasama ang iyong pamilya, na sinisiguro ang hindi bababa sa dalawang daan palabas sa bawat silid.\n3. Magkaroon ng fire extinguisher sa madaling maabot na lugar at alamin ang tamang paggamit nito.',
    lifeSafetyContacts: 'Mga Emergency Contact ',
    lifeSafetyContactsDesc:
        'Siguraduhing may listahan ka ng mga emergency contact, kabilang ang lokal na emergency services, mga miyembro ng pamilya, at mga kalapit na kapitbahay na maaaring makatulong sa oras ng emergency.',

    //Emergency preparedness
    emergencyPreparedness: 'PAGHAHANDA SA EMERHENSIYA',
    emergencyPreparednessGuide: 'Gabay sa Paghahanda sa Emerhensya',
    emergencyPreparednessGuideDesc:
        'Ang pagiging handa sa mga emerhensya ay maaaring maging malaking tulong kapag dumating ang sakuna. Ang gabay na ito ay nagbibigay ng mga tip kung paano maghanda para sa iba’t ibang emerhensya at kung ano ang dapat isama sa iyong emergency kit.',
    emergencyPreparednessKit: 'Pagbuo ng Emergency Kit',
    emergencyPreparednessKitDesc:
        '1. Tubig\nMagkaroon ng hindi bababa sa isang galon ng tubig bawat tao kada araw para sa hindi bababa sa tatlong araw.\n\n2. Pagkain\nMag-imbak ng hindi bababa sa tatlong araw na suplay ng hindi madaling masirang pagkain.\n\n3. Gamot\nMagdala ng sapat na suplay ng mga kinakailangang gamot, pati na rin ang mga pangunahing gamit sa unang lunas.\n\n4. Kagamitan\nMagdala ng flashlight, ekstrang baterya, multi-tool, at manual can opener.\n\n5. Mahalagang Dokumento\nMag-imbak ng mga kopya ng personal na dokumento tulad ng ID, mga polisiyang pang-insurance, at impormasyon sa bangko sa isang waterproof na lalagyan.',
    emergencyPreparednessFamilyPlan:
        'Pagbuo ng Planong Pangkomunikasyon ng Pamilya',
    emergencyPreparednessFamilyPlanDesc:
        '1. Pumili ng contact na nasa ibang bayan na maaaring makipag-ugnayan ang lahat ng miyembro ng pamilya sa panahon ng emergency.\n2. Magtakda ng lugar na pagtatagpuan malapit sa inyong bahay sakaling magkaroon ng biglaang emergency.\n3. Siguraduhin na alam ng lahat sa pamilya kung paano mag-text dahil maaaring maging abala ang mga linya ng telepono sa oras ng sakuna.',
    emergencyPreparednessprepHome: 'Paghahanda sa Bahay',
    emergencyPreparednessprepHomeDesc:
        '1. Siguraduhing naka-secure ang mga mabibigat na bagay tulad ng mga bookshelf, refrigerator, telebisyon, at mga nakasabit na bagay. Ito ay maaaring magdulot ng pinsala sa panahon ng lindol o ibang emerhensya.\n2. Mag-install ng smoke alarms at carbon monoxide detectors sa bawat palapag ng bahay at regular itong subukin.\n3. Alamin kung paano isara ang mga utilities tulad ng gas, tubig, at kuryente.',
    emergencyPreparednessContacts: 'Mga Emergency Contact ',
    emergencyPreparednessContactsDesc:
        'Siguraduhing may listahan ka ng mga emergency contact, kabilang ang mga lokal na awtoridad, kumpanya ng utilities, at mga miyembro ng pamilya na madaling ma-access.',

    safetyGuides: 'Gabay sa Kaligtasan',
    aboutAppguide: 'BAYANi - Emergency Response App',
    aboutAppguideDesc:
        'Ang BAYANi ay isang mobile application na dinisenyo partikular para sa mga residente ng Science City of Muñoz. Layunin ng emergency response app na magbigay ng mabilis at maaasahang tulong sa iba’t ibang emergency, kabilang ang mga likas na sakuna, medikal na sitwasyon, insidente ng sunog, at iba pang kritikal na pangyayari.',
    aboutAppKeyfeatures: 'Mga Pangunahing Tampok',
    aboutAppKeyfeaturesDesc:
        "• Mabilisang pakikipag-ugnayan sa mga lokal na awtoridad at tagapagligtas.\n• Mga real-time na notipikasyon at alerto para sa mga emergency sa buong lungsod.\n• Mga gabay sa first aid at mga tip sa kaligtasan para sa iba't ibang sitwasyon ng emergency.\n• GPS location sharing para sa mabilis at tumpak na pagtugon.\n• Access sa mga mahahalagang mapagkukunan tulad ng mga mapa ng paglikas at emergency hotlines.",
    aboutAppMission: 'Aming Misyon',
    aboutAppMissionDesc:
        'Layunin ng BAYANi na bigyang-lakas ang komunidad ng Science City of Muñoz sa pamamagitan ng pagbibigay ng isang maaasahan at madaling gamitin na kasangkapan na tumutulong sa agarang pagtugon at tamang gabay sa panahon ng emergency. Naniniwala kami sa kahalagahan ng kaligtasan at kahandaan ng komunidad, at layunin naming maging tanglaw ng tulong sa oras ng pangangailangan.',
    aboutAppContactUs: 'Makipag-ugnayan sa Amin',
    aboutAppContactUsDesc:
        'Para sa mga puna, mungkahi, o tulong, maaari kaming makontak sa:',

    //About CDRMMO
    aboutCDRRMOGuide: 'Tungkol sa CDRRMO',
    aboutCDRRMOGuideDesc:
        'Ang City Disaster Risk Reduction and Management Office (CDRRMO) ay responsable para sa kahandaan sa sakuna, pag-iwas sa panganib, pagtugon, at pagbawi sa mga sakuna sa lungsod. Ito ay nakikipagtulungan sa mga lokal, nasyonal, at internasyonal na katuwang upang matiyak ang mabisang pamamahala sa mga sakuna. Ang mga pangunahing pokus nito ay ang pagtugon sa emergency, pagpapaunlad ng kakayahan, at edukasyon ng publiko.',
    aboutCDRRMOMission: 'Misyon',
    aboutCDRRMOMissionDesc:
        'Mapalakas ang kaligtasan at katatagan ng komunidad sa pamamagitan ng mabisang estratehiya sa pamamahala sa panganib ng sakuna.',
    aboutCDRRMOVission: 'Pangitain',
    aboutCDRRMOVissionDesc:
        'Isang lungsod na handa sa sakuna kung saan ang mga mamamayan ay may sapat na kaalaman sa mga panganib at protokol sa pamamahala ng sakuna.',

    //PRIVACY POLICY
    privacyPolicyDate: 'Petsa ng Pagiging Epektibo: 11/09/2024',
    privacyPolicyContactUs: 'MAKIPAG-UGNAYAN SA AMIN',
    privacyPolicyContactUsDesc:
        'Kung may tanong ka tungkol sa proteksyon ng iyong impormasyon o may kahilingan tungkol sa iyong personal na data, huwag mag-atubiling makipag-ugnayan sa amin. Layunin namin na agad tugunan ang iyong mga katanungan upang maging ligtas at maayos ang iyong karanasan sa paggamit ng BAYANi.',
    privacyPolicydatacontroller: 'Tagapangasiwa ng Data:',
    privacyPolicyContactdatacontrollerDesc:
        'City Disaster Risk Reduction Management Office (CDRRMO), Science City of Muñoz, Nueva Ecija',
    privacyPolicyContactEmail: 'Email:',
    privacyPolicydatacollected: 'MGA DATOS NA KINOKOLEKTA NAMIN',
    privacyPolicydatacollectedDesc:
        'Ang BAYANi ay nangongolekta ng impormasyon upang mapabuti ang tugon sa mga emergency at masiguro ang mabilis at tumpak na komunikasyon sa pagitan ng mga gumagamit at mga tagapagresponde. Ang mga datos na ito ay kasama ang:',
    privacyPolicydatacollectedContactInfo: '• Impormasyon sa Pakikipag-ugnayan',
    privacyPolicydatacollectedContactInfoDesc:
        '(hal., pangalan, numero ng telepono, at email address) upang makilala at makontak ka sa oras ng emergency.',
    privacyPolicydatacollectedProfileInfo: '•	Impormasyon sa Profile ',
    privacyPolicydatacollectedProfileInfoDesc:
        'upang madaling makilala ka sa app.',
    privacyPolicydatacollectedIncidentDetails: '• Mga Detalye ng Insidente ',
    privacyPolicydatacollectedIncidentDetailsDesc:
        '(hal., mga larawan, video, at lokasyon) upang makatulong sa pagbigay ng real-time na impormasyon sa mga insidente.',
    privacyPolicydatacollectedLocationData: '• Lokasyon ',
    privacyPolicydatacollectedLocationDataDesc:
        'upang matiyak na tumpak ang pagsubaybay sa mga insidente.',
    privacyPolicyWhycollectdata: 'BAKIT NAMIN KINOKOLEKTA ANG IYONG DATOS',
    privacyPolicyWhycollectdataDesc:
        'Upang maibigay ang maayos at mabilis na tugon sa mga emergency, kinokolekta at pinoproseso ng BAYANi ang iyong datos para sa mga sumusunod na layunin:',
    privacyPolicyWhycollectdataPurposes:
        '• Paglikha at Pamamahala ng Account - Upang makagawa at mapanatili ng mga gumagamit ang kanilang account sa app nang ligtas.\n• Operasyon ng Serbisyo sa Emergency - Upang makalikom ng impormasyon para makatulong sa mabilisang aksyon sa mga insidente.\n• Pagpapabuti ng Serbisyo - Upang mapahusay pa ang mga tampok ng app batay sa paggamit at karanasan ng mga tao.\n• Komunikasyon - Upang makapagpadala ng mga abiso at update na may kinalaman sa mga emergency o kaligtasan ng komunidad.',
    privacyPolicyDataVisibility: 'PAGIGING BUKAS AT PAGBABAHAGI NG DATOS',
    privacyPolicyDataVisibilityDesc:
        'Ang mga datos na ibinabahagi mo sa BAYANi ay makikita lamang ng mga awtorisadong tao sa City Disaster Risk Reduction Management Office (CDRRMO) at mga tagapagresponde sa emergency. Ang ilang piling impormasyon, tulad ng mga kumpirmadong ulat ng insidente, ay maaaring makita ng mga rehistradong gumagamit at kaukulang mga awtoridad upang mapanatili ang kaligtasan ng komunidad.',
    privacyPolicyyourRights: 'IYONG MGA KARAPATAN AT OPSYON',
    privacyPolicyyourRightsDesc:
        'Ang mga gumagamit ng BAYANi ay may mga sumusunod na karapatan tungkol sa kanilang personal na datos:',
    privacyPolicyyourRightsAccessToData: '• Pag-access sa Datos ',
    privacyPolicyyourRightsAccessToDataDesc:
        '- Maaaring humiling ng kopya ng iyong personal na datos.',
    privacyPolicyyourRightsDataCorrection: '• Pagwawasto ng Datos ',
    privacyPolicyyourRightsDataCorrectionDesc:
        '- Maaaring i-update o itama ang anumang maling impormasyon sa iyong profile.',
    privacyPolicyyourRightsDataDeletion: '• Pag-delete ng Datos',
    privacyPolicyyourRightsDataDeletionDesc:
        '- Maaaring humiling na tanggalin ang iyong datos (may mga limitasyon kapag may kasalukuyang emergency).',
    privacyPolicyyourRightsUsageRestrict: '• Paghihigpit sa Paggamit',
    privacyPolicyyourRightsUsageRestrictDesc:
        '- Maaaring limitahan o tutulan kung paano ginagamit ang iyong datos.',
    privacyPolicyyourRightsLocationSettings: '• Mga Setting ng Lokasyon',
    privacyPolicyyourRightsLocationSettingsDesc:
        '- Maaaring baguhin o i-disable ang GPS sa iyong device (maaari itong makaapekto sa ilang pangunahing gamit ng app sa emergency).',
    privacyPolicyDisclaimer: 'PAALALA',
    privacyPolicyDisclaimerDesc:
        'Ang anumang mga larawan, video, o impormasyon na iyong ia-upload ay maaaring kumpirmahin ayon sa mga panuntunan ng pagtugon sa emergency. Gayunpaman, ang BAYANi at ang City Disaster Risk Reduction Management Office (CDRRMO) ay hindi mananagot sa anumang pagkakamali sa impormasyong ibinigay ng mga gumagamit.\nSa paggamit ng app na ito, sumasang-ayon ang gumagamit na ang kanilang nai-report na mga insidente, kasama ang mga larawang ipinasa, ay maaaring makita ng mga kaukulang awtoridad at ng ibang gumagamit ng app.\nHindi mananagot ang CDRRMO para sa anumang pinsala na direktang o di-tuwirang nagmumula sa maling impormasyon na ibinigay ng mga gumagamit.',
    privacyPolicyDisclaimerDescLast:
        'Maraming salamat sa paggamit ng BAYANi upang mapalakas ang kaligtasan ng komunidad sa Science City of Muñoz. Mangyaring makipag-ugnayan sa amin para sa mga tanong tungkol sa patakaran na ito o upang magamit ang iyong mga karapatan kaugnay ng personal na datos.',
    allrightreserved: 'All rights reserved.',
  };
}
