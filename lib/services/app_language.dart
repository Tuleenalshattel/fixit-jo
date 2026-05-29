import 'package:flutter/material.dart';

class AppLanguage extends ChangeNotifier {
  static final AppLanguage _instance = AppLanguage._internal();
  factory AppLanguage() => _instance;
  AppLanguage._internal();

  bool _isArabic = false;
  bool get isArabic => _isArabic;

  void toggleLanguage() {
    _isArabic = !_isArabic;
    notifyListeners();
  }

  void setArabic(bool value) {
    _isArabic = value;
    notifyListeners();
  }

  // Dashboard translations
  String get login => _isArabic ? 'تسجيل الدخول' : 'Login';
  String get heroTitle => _isArabic
      ? 'صلحها مع جو \nشريكك الموثوق\nلصيانة منزلك'
      : 'Fix It With Jo\nYour Trusted\nHome Partner';
  String get whyChooseTitle =>
      _isArabic ? 'لماذا تختار FixIt Jo' : 'Why Choose FixIt Jo?';
  String get whyChooseDesc => _isArabic
      ? 'نربطك بمحترفين موثوقين لأفضل تجربة صيانة منزلية بجودة عالية وخدمة موثوقة.'
      : 'We will connect you with a group of specialised technicians to ensure hassle-free home maintenance with the highest standards of accuracy and professionalism.';
  String get completeServicesTitle =>
      _isArabic ? 'خدمات شاملة' : 'Complete Services';
  String get completeServicesDesc => _isArabic
      ? 'من السباكة إلى الكهرباء والتكييف ، نقدم حلولا متكاملة تغطي كافة احتياجات منزلك مع ضمان للجودة العالية والسرعة بالتنفيذ .'
      : 'From plumbing to electricity and air conditioning, we offer integrated solutions that cover all the needs of your home while ensuring high quality and speed of execution.';
  String get service1 => _isArabic
      ? ' صيانة أنظمة الكهرباء والإنارة الذكية'
      : 'Maintenance of smart electricity and lighting systems';
  String get service2 => _isArabic
      ? 'حلول السباكة المتقدمة وفلاتر المياه'
      : 'Advanced plumbing solutions and water filters';
  String get service3 => _isArabic
      ? 'صيانة أجهزة التكييف والتدفئة المركزية  '
      : 'maintenance of central air conditioning or heating devices';
  String get service4 => _isArabic
      ? ' ...والمزيد من الخدمات المتاحة حسب طلبك'
      : 'And more services available according to your request';
  String get service5 =>
      _isArabic ? 'فنيون سريعون وموثوقون' : 'Professional Technicians';

  String get feature1Desc => _isArabic
      ? 'نحن نتحقق بعناية من كفاءة وخبرة جميع الفنيين المنضمين إلينا لضمان راحتك وأمان منزلك وتقديم خمة تليق بكم'
      : 'We carefully verify the competence and experience of all the technicians who join us to ensure your comfort and the safety of your home and provide a service that befits you.';
  String get feature2Title => _isArabic
      ? 'تحكم في صيانة منزلك بكل سهولة'
      : 'Control the maintenance of your home with ease';
  String get feature2Desc => _isArabic
      ? '  .من خلال حسابك الشخصي يمكنك تتبع طلبات الصيانة, مراجعة الفواتير, والتواصل مباشرة مع الفنيين المخصصين لك في أي وقت'
      : 'Track your maintenance requests easily and communicate directly with specialized technicians.';
  String get team => _isArabic ? 'الفريق' : 'Team';
  String get Amneh => _isArabic ? 'امنة' : 'Amneh';
  String get Tuleen => _isArabic ? 'تولين' : 'Tuleen';
  String get Noor => _isArabic ? 'نور' : 'Noor';
  String get footerHome => _isArabic ? 'الرئيسية' : 'Home';
  String get footerServices => _isArabic ? 'الخدمات' : 'Services';
  String get footerHowItWorks => _isArabic ? 'كيف يعمل' : 'How It Works';
  String get footerContact => _isArabic ? 'تواصل معنا' : 'Contact';
  String get footerRights =>
      _isArabic ? '© 2026 جميع الحقوق محفوظة' : '© 2026 All Rights Reserved';
  String get langLabel => _isArabic ? 'عربي' : 'EN';

  // Login Screen translations
  String get welcomeBack => _isArabic ? 'مرحباً بعودتك' : 'Welcome back';
  String get loginToContinue =>
      _isArabic ? 'سجل دخولك للمتابعة' : 'Login to continue using the app';
  String get phoneNumber => _isArabic ? 'رقم الهاتف' : 'Phone Number';
  String get enterPhone =>
      _isArabic ? 'أدخل رقم هاتفك' : 'Enter your phone number';
  String get loginButton => _isArabic ? 'تسجيل الدخول' : 'Login';
  String get dontHaveAccount =>
      _isArabic ? 'ليس لديك حساب؟' : "Don't have an account?";
  String get register => _isArabic ? 'إنشاء حساب' : 'Register';
  String get orLoginWith =>
      _isArabic ? 'أو سجل دخول باستخدام' : 'Or login with';
  String get google => _isArabic ? 'جوجل' : 'Google';

  // Home Screen translations
  String get home => _isArabic ? 'الرئيسية' : 'Home';
  String get request => _isArabic ? 'طلب' : 'Request';
  String get completed => _isArabic ? 'مكتمل' : 'Completed';
  String get searchServices =>
      _isArabic ? 'ابحث عن خدمات...' : 'Search services...';
  String get ourServices => _isArabic ? 'خدماتنا' : 'Our Services';
  String get viewAll => _isArabic ? 'عرض الكل' : 'View All';
  String get plumbing => _isArabic ? 'سباكة' : 'Plumbing';
  String get electrical => _isArabic ? 'كهرباء' : 'Electrical';
  String get painting => _isArabic ? 'دهان' : 'Painting';
  String get ac => _isArabic ? 'تكييف' : 'AC';
  String get cleaning => _isArabic ? 'تنظيف' : 'Cleaning';
  String get carpentry => _isArabic ? 'نجارة' : 'Carpentry';
  String get recentRequests => _isArabic ? 'طلباتي الأخيرة' : 'Recent Requests';
  String get noRequests => _isArabic ? 'لا توجد طلبات بعد' : 'No requests yet';
  String get hello => _isArabic ? 'مرحباً' : 'Hello';

  // Register Screen translations
  String get createAccount => _isArabic ? 'إنشاء حساب جديد' : 'Create Account';
  String get fullName => _isArabic ? 'الاسم الكامل' : 'Full Name';
  String get enterName =>
      _isArabic ? 'أدخل اسمك الكامل' : 'Enter your full name';
  String get email => _isArabic ? 'البريد الإلكتروني' : 'Email';
  String get enterEmail =>
      _isArabic ? 'أدخل بريدك الإلكتروني' : 'Enter your email';
  String get password => _isArabic ? 'كلمة المرور' : 'Password';
  String get enterPassword =>
      _isArabic ? 'أدخل كلمة المرور' : 'Enter your password';
  String get confirmPassword =>
      _isArabic ? 'تأكيد كلمة المرور' : 'Confirm Password';
  String get alreadyHaveAccount =>
      _isArabic ? 'لديك حساب بالفعل؟' : 'Already have an account?';

  String get nameExample => _isArabic ? "عمر حسن" : "Omar Hassan";
  String get selectone => _isArabic ? ' اختر واحداً' : 'SELECT ONE';
  String get professionalTerms => _isArabic
      ? 'بالضغط على تسجيل، فإنك توافق على الشروط وسياسات التحقق'
      : 'BY CLICKING REGISTER, YOU AGREE TO OUR PROFESSIONAL TERMS OF SERVICE AND IDENTITY VERIFICATION POLICIES.';

  // Settings translations
  String get settings => _isArabic ? 'الإعدادات' : 'Settings';
  String get editProfile => _isArabic ? 'تعديل الملف الشخصي' : 'Edit Profile';
  String get notifications => _isArabic ? 'الإشعارات' : 'Notifications';
  String get language => _isArabic ? 'اللغة' : 'Language';
  String get logout => _isArabic ? 'تسجيل الخروج' : 'Logout';
  String get about => _isArabic ? 'حول التطبيق' : 'About';
  String get darkMode => _isArabic ? 'الوضع الداكن' : 'Dark Mode';

  // Request Service translations
  String get requestService => _isArabic ? 'طلب خدمة' : 'Request Service';
  String get selectService => _isArabic ? 'اختر الخدمة' : 'Select Service';
  String get describeProblem =>
      _isArabic ? 'صف المشكلة' : 'Describe your problem';
  String get selectDate => _isArabic ? 'اختر التاريخ' : 'Select Date';
  String get selectTime => _isArabic ? 'اختر الوقت' : 'Select Time';
  String get submit => _isArabic ? 'إرسال' : 'Submit';
  String get cancel => _isArabic ? 'إلغاء' : 'Cancel';

  // Profile translations
  String get profile => _isArabic ? 'الملف الشخصي' : 'Profile';
  String get save => _isArabic ? 'حفظ' : 'Save';
  String get changePhoto => _isArabic ? 'تغيير الصورة' : 'Change Photo';

  // Notification translations
  String get noNotifications =>
      _isArabic ? 'لا توجد إشعارات' : 'No notifications';
  String get markAllRead =>
      _isArabic ? 'تحديد الكل كمقروء' : 'Mark all as read';

  // Chatbot translations
  String get whatwrong =>
      _isArabic ? 'ما الخطأ في هذا؟' : 'What is wrong with this?';

  String get chatAssistant => _isArabic ? 'المساعد الذكي' : 'Chat Assistant';
  String get typeMessage =>
      _isArabic ? 'اكتب رسالتك...' : 'Type your message...';
  String get describeissue =>
      _isArabic ? 'صف مشكلتك...' : 'Describe your issue...';
  String get couldNotUnderstand => _isArabic
      ? 'عذراً، لم أستطع فهم المشكلة.'
      : 'Sorry, I could not understand that.';

  String get error => _isArabic ? 'خطأ' : 'Error';
  // Rating translations
  String get rateService => _isArabic ? 'قيم الخدمة' : 'Rate Service';
  String get submitRating => _isArabic ? 'إرسال التقييم' : 'Submit Rating';
  String get writeReview =>
      _isArabic ? 'اكتب مراجعتك...' : 'Write your review...';

  // Map translations
  String get yourLocation => _isArabic ? 'موقعك' : 'Your Location';
  String get confirmLocation => _isArabic ? 'تأكيد الموقع' : 'Confirm Location';

  // OTP translations
  String get accountBlocked => _isArabic
      ? 'تم حظر هذا الحساب من قبل الإدارة'
      : 'This account has been blocked by admin';
  String get pendingadminapproval => _isArabic
      ? ' حسابك بانتظار موافقة الإدارة '
      : 'Your account is pending admin approval';

  String get enter6DigitCode =>
      _isArabic ? 'أدخل رمز مكوّن من 6 أرقام' : 'Enter 6-digit code';
  String get verifyOTP => _isArabic ? 'تحقق من الرمز' : 'Verify OTP';
  String get Coderesent => _isArabic ? 'إعادة إرسال الكود' : 'Code resent';
  String get invalidOtp => _isArabic ? 'رمز غير صحيح' : 'Invalid OTP';
  String get OTPverification =>
      _isArabic ? 'التحقق من كلمة المرور لمرة واحدة' : 'OTP Verification';
  String enterCodeSentTo(String phone) =>
      _isArabic ? 'أدخل الرمز المرسل إلى $phone' : 'Enter code sent to $phone';
  String get enterOTP => _isArabic ? 'أدخل رمز التحقق' : 'Enter the OTP code';
  String get resend => _isArabic ? 'إعادة إرسال' : 'Resend';
  String get adminapproval => _isArabic
      ? ' تم تقديم طلب التسجيل. في انتظار موافقة الإدارة'
      : 'Registration submitted. Waiting for admin approval.';
  String get seconds => _isArabic ? 'ثانية' : 's';
  String get verificationfailed =>
      _isArabic ? 'فشل التحقق' : 'Verification failed';
  String get verify => _isArabic ? 'تحقق من' : 'Verify ';
  String get resendcode => _isArabic ? 'إعادة إرسال الرمز' : 'Resend Code';
  String resendIn(int seconds) =>
      _isArabic ? 'إعادة الإرسال خلال $seconds ث' : 'Resend in $seconds s';
  // Splash Screen
  String get loading => _isArabic ? 'جاري التحميل...' : 'Loading...';

  // Login Screen
  String get admin => _isArabic ? 'أدمن' : 'Admin';
  String get welcomeBackTitle => _isArabic ? 'مرحباً بعودتك' : 'Welcome back';
  String get enterMobileToStart => _isArabic
      ? 'أدخل رقم هاتفك للبدء.'
      : 'Enter your mobile number to start fixing.';
  String get mobileNumber => _isArabic ? 'رقم الهاتف' : 'MOBILE NUMBER';
  String get sendOTP => _isArabic ? 'إرسال الرمز' : 'Send OTP';
  String get secureLogin => _isArabic ? 'تسجيل دخول آمن' : 'SECURE LOGIN';
  String get enterValidPhone =>
      _isArabic ? 'أدخل رقم هاتف صحيح' : 'Enter valid phone number';
  String get verificationFailed =>
      _isArabic ? 'فشل التحقق' : 'Verification failed';
  String get termsAndPrivacy => _isArabic
      ? 'بالمتابعة، أنت توافق على شروط الخدمة وسياسة الخصوصية لـ FixIt Jo.'
      : "By continuing, you agree to FixIt Jo's Terms of Service and Privacy Policy.";
  String get accountType => _isArabic ? 'نوع الحساب' : 'ACCOUNT TYPE';

  // Register Screen
  String get createAnAccount => _isArabic ? 'إنشاء حساب' : 'Create an Account';
  String get joinFixIt => _isArabic
      ? 'انضم إلى FixIt Jo وابدأ بتطوير عملك.'
      : 'Join FixIt Jo and start growing your business.';
  String get profilePicture => _isArabic ? 'الصورة الشخصية' : 'Profile Picture';
  String get photoRecommendation => _isArabic
      ? 'موصى به: صورة واضحة للوجه في ضوء النهار.'
      : 'Recommended: Clear face photo in daylight.';
  String get iAmA => _isArabic ? 'أنا...' : 'I am a...';
  String get customer => _isArabic ? 'زبون' : 'Customer';
  String get technician => _isArabic ? 'فني' : 'Technician';
  String get digitalConcierge =>
      _isArabic ? 'المساعد الرقمي' : 'Digital Concierge';
  String get specializations => _isArabic ? 'التخصصات' : 'Specializations';
  String get plumbing1 => _isArabic ? 'السباكة' : 'Plumbing';
  String errorMessage(String error) =>
      _isArabic ? 'خطأ: $error' : 'Error: $error';
  String get electrical1 => _isArabic ? 'الكهرباء' : 'Electrical';
  String get carpentry1 => _isArabic ? 'النجارة' : 'Carpentry';
  String get acRepair1 => _isArabic ? 'تصليح التكييف' : 'AC Repair';
  String get painting1 => _isArabic ? 'الدهان' : 'Painting';
  String get blacksmith => _isArabic ? 'الحدادة' : 'Blacksmith';
  String get furnitureCarpentry =>
      _isArabic ? 'الأثاث والنجارة' : 'Furniture & Carpentry';
  String get yearsofexperiance =>
      _isArabic ? 'سنوات الخبرة' : 'Years of Experience';
  String get homeCleaning => _isArabic ? 'تنظيف المنازل' : 'Home Cleaning';
  String get experience => _isArabic ? 'الخبرة' : 'Experience';
  String get oneYear => _isArabic ? 'سنة' : '1 YEAR';
  String get fifteenYears => _isArabic ? '15 سنة' : '15 YEARS';
  String get thirtyYears => _isArabic ? '30 سنة' : '30 YEARS';
  String get years => _isArabic ? 'سنوات' : 'years';
  String get pleasefillallfields =>
      _isArabic ? 'يرجى ملء جميع الحقول' : 'Please fill all fields';

  String get registerTerms => _isArabic
      ? 'بالضغط على إنشاء الحساب، فإنك توافق على\n'
            'شروط الخدمة المهنية الخاصة بنا\n'
            'وسياسات التحقق من الهوية.'
      : 'BY CLICKING REGISTER, YOU AGREE TO OUR\n'
            'PROFESSIONAL TERMS OF SERVICE AND\n'
            'IDENTITY VERIFICATION POLICIES.';

  // Home Screen
  String get welcomeBackHome => _isArabic ? 'مرحباً بعودتك' : 'WELCOME BACK';
  String get needAFix => _isArabic ? 'تحتاج الى اصلاح؟ ' : 'Need a fix?';
  String get findBestPros => _isArabic
      ? 'اعثر على أفضل المحترفين في ثوانٍ.'
      : 'Find the best pros in seconds.';
  String get searchFor => _isArabic
      ? 'ابحث عن كهرباء، سباكة...'
      : 'Search for electrical, plumbing...';
  String get serviceCategories =>
      _isArabic ? 'فئات الخدمات' : 'Service Categories';
  String get ongoingRequests =>
      _isArabic ? 'الطلبات الجارية' : 'Ongoing Requests';
  String get noOngoingRequests =>
      _isArabic ? 'لا توجد طلبات جارية' : 'No ongoing requests';
  String get waitingForTechnician =>
      _isArabic ? 'في انتظار الفني...' : 'Waiting for technician...';
  String get serviceCompleted =>
      _isArabic ? 'تم إنجاز الخدمة' : 'Service completed';
  String get arrivingIn => _isArabic ? 'الوصول خلال:' : 'Arriving in:';
  String get trackTechnician => _isArabic ? 'تتبع الفني' : 'Track Technician';
  String get rateTechnician => _isArabic ? 'تقييم الفني' : 'Rate Technician';
  String get acRepair => _isArabic ? 'صيانة تكييف' : 'AC Repair';
  String helloUser(String name) => _isArabic ? 'مرحباً $name' : 'Hello $name';

  // Request Service Screen

  String get activeRequestExists =>
      _isArabic ? 'لديك طلب نشط بالفعل' : 'You already have an active request';

  String get noTechnicianFound =>
      _isArabic ? 'لا يوجد فني متاح' : 'No available technician found';
  String get submitting => _isArabic ? 'جاري الإرسال...' : 'Submitting...';

  String get description => _isArabic ? 'الوصف' : 'Description';
  String get takephoto => _isArabic ? 'التقط صورة' : 'Take Photo';
  String get choosefromgallery =>
      _isArabic ? ' اختر من المعرض' : 'Choose from Gallery';
  String get describeIssueHint => _isArabic
      ? 'صف المشكلة باختصار (مثال: حوض مطبخ يسرب الماء)...'
      : 'Briefly describe the issue (e.g., leaky kitchen sink faucet)...';
  String get location => _isArabic ? 'الموقع' : 'Location';
  String get editLocation => _isArabic ? 'تعديل الموقع' : 'Edit Location';
  String get cameraOrGallery => _isArabic
      ? ' اختار الكاميرا أو المعرض - بحد أقصى 5 صور'
      : ' choose camera or Gallery - Maximum 5 photos';
  String get uploadPhotos => _isArabic ? 'رفع صور' : 'Upload Photos';
  String get addPhoto => _isArabic ? 'إضافة صورة' : 'Add Photo';
  String get heating => _isArabic ? 'تدفئة' : 'Heating';

  String get furniture => _isArabic ? 'أثاث' : 'Furniture';
  String get submitRequest => _isArabic ? 'إرسال الطلب' : 'Submit Request';
  String get attachImages =>
      _isArabic ? 'أضف صور للمشكلة' : 'Attach images of the issue';
  String photosAdded(int count) =>
      _isArabic ? 'تمت إضافة $count/5 صور' : '$count/5 photos added';
  String get noAvailableTechnician =>
      _isArabic ? 'لا يوجد فني متاح' : 'No available technician found';
  String get requestSubmitted =>
      _isArabic ? 'لا تتوفر خدمات' : 'No services available';
  String get Noservicesavailable =>
      _isArabic ? 'تم إرسال الطلب بنجاح' : 'Request submitted successfully';
  String get sud =>
      _isArabic ? 'تم إرسال الطلب بنجاح' : 'Request submitted successfully';
  String get selectServices => _isArabic ? 'اختر الخدمة' : 'Select Service';
  String get imageAdded => _isArabic ? 'تم إضافة الصورة' : 'Image added';
  String get userNotLoggedIn =>
      _isArabic ? 'المستخدم غير مسجل الدخول' : 'User not logged in';
  String get pleaseEnterDescription =>
      _isArabic ? 'يرجى إدخال الوصف' : 'Please enter description';

  // Notification Screen
  String get noNotificationsYet =>
      _isArabic ? 'لا توجد إشعارات بعد' : 'No notifications yet';
  //String get userNotLoggedIn => _isArabic ? 'المستخدم غير مسجل الدخول' : 'User not logged in';

  // Profile Screen
  String get defaultAddress =>
      _isArabic ? 'العنوان الافتراضي' : 'Default Address';
  String get myRequests => _isArabic ? 'طلباتي' : 'My Requests';
  String get noRequestsYet =>
      _isArabic ? 'لا توجد طلبات بعد' : 'No requests yet';
  String get noDate => _isArabic ? 'لا يوجد تاريخ' : 'No date';

  // Settings Screen
  String get version => _isArabic ? "الإصدار" : "Version";
  String get accountInformation =>
      _isArabic ? 'معلومات الحساب' : 'Account Information';
  String get changePassword =>
      _isArabic ? 'تغيير كلمة المرور / الأمان' : 'Change Password / Security';
  String get languageSelection =>
      _isArabic ? 'اختيار اللغة' : 'Language selection';
  String get helpSupport => _isArabic ? 'المساعدة والدعم' : 'Help & Support';
  String get aboutApp => _isArabic ? 'حول التطبيق' : 'About the App';
  String get logOut => _isArabic ? 'تسجيل الخروج' : 'LOG OUT';

  // Chatbot Screen
  String get joAssistantGreeting => _isArabic
      ? 'مرحباً! أنا المساعد FixIt  🔧\nكيف يمكنني مساعدتك في صيانة منزلك اليوم؟'
      : 'Hello! I am FixIt Assistant 🔧\nHow can I help you with your home maintenance today?';
  String get assistant => _isArabic ? 'مساعد FixIt' : 'FixIt Assistant';
  String get online => _isArabic ? 'متصل ' : 'Online';
  String get imageselected => _isArabic ? 'تم اختيار الصورة' : 'Image selected';

  // Technician Home Screen
  String get available => _isArabic ? 'متاح' : 'Available';
  String get unavailable => _isArabic ? 'غير متاح' : 'Unavailable';
  String get incomingRequests =>
      _isArabic ? 'الطلبات الواردة' : 'Incoming Requests';
  String get activeRequest => _isArabic ? 'طلب نشط' : 'Active Request';
  String get noActiveRequests =>
      _isArabic ? 'لا توجد طلبات نشطة' : 'No active requests';
  String get accept => _isArabic ? 'قبول' : 'Accept';
  String get decline => _isArabic ? 'رفض' : 'Decline';
  String get complete => _isArabic ? 'إكمال' : 'Complete';
  String get noIncomingRequests =>
      _isArabic ? 'لا توجد طلبات واردة' : 'No incoming requests';
  String get user => _isArabic ? 'مستخدم' : 'User';
  Locale get locale => _isArabic ? const Locale('ar') : const Locale('en');

  String get technicianAssigned =>
      _isArabic ? "تم تعيين فني" : "Technician assigned";

  String get locationNotAvailable =>
      isArabic ? "الموقع غير متوفر" : "Location not available";
  String get reportType => isArabic ? "نوع البلاغ" : "Report Type";
  String get reason => isArabic ? "السبب" : "Reason";
  String get technicianDataNotFound =>
      _isArabic ? 'بيانات الفني غير موجودة' : 'Technician data not found';
  String get serviceStatus => _isArabic ? 'حالة الخدمة' : 'Service Status';
  String get manageVisibility =>
      _isArabic ? 'إدارة ظهورك للعملاء' : 'Manage your visibility to customers';
  String get busy => _isArabic ? 'مشغول' : 'Busy';
  String get liveRequest => _isArabic ? 'مباشر' : 'Live';
  String get noCurrentJob => _isArabic ? 'لا يوجد طلب حالي' : 'No current job';
  String get trackCustomer => _isArabic ? 'تتبع العميل' : 'Track Customer';
  String get jobsDone => _isArabic ? 'الطلبات المكتملة' : 'JOBS DONE';

  String get completedJobs => _isArabic ? 'طلبات مكتملة' : 'Completed jobs';

  String get rating => _isArabic ? 'التقييم' : 'RATING';

  String get reviews => _isArabic ? 'تقييمات' : 'reviews';

  // Admin Scrren
  String get pendingApproval =>
      _isArabic ? 'بانتظار الموافقة' : 'PENDING APPROVAL';
  String get livejob => _isArabic
      ? 'تتبع الوظائف مباشرةً ونظرة عامة على الخدمة.'
      : 'Live job tracking and service overview.';

  String get noPendingTechnicians =>
      _isArabic ? 'لا يوجد فنيون معلقون' : 'No pending technicians';

  String get pendingVerificationsTitle =>
      _isArabic ? 'في انتظار التحقق' : 'PENDING VERIFICATIONS';

  String get liveServiceRequests =>
      _isArabic ? 'طلبات الخدمة المباشرة' : 'Live service requests';

  String get totaltechnicians =>
      _isArabic ? 'إجمالي الفنيين' : 'TOTAL TECHNICIANS';
  String get platformHealth => _isArabic
      ? 'حالة المنصة الصحية والتشغيلية.'
      : 'Platform health and operational status.';
  String get Service => _isArabic ? 'خدمة' : 'Service';
  String get notAssigned => _isArabic ? 'لم يتم التعيين' : 'Not assigned';
  String get adminHome => _isArabic ? 'الرئيسية' : 'Home';
  String get technicianverified =>
      _isArabic ? 'التحقق من فني' : 'Technician verified';
  String get technicianRejected =>
      _isArabic ? 'رفض الفني ' : 'Technician rejected';
  String get reject => _isArabic ? 'رفض ' : 'Reject';

  String get report => _isArabic ? 'تقرير ' : 'Report';
  String get professions => _isArabic ? 'المهن' : 'Professions';
  String get systemOverview =>
      _isArabic ? 'نظرة عامة على النظام' : 'System Overview';
  String get platformStatus => _isArabic
      ? 'حالة المنصة والتشغيل العامة.'
      : 'Platform health and operational status.';
  String get totalTechnicians =>
      _isArabic ? 'إجمالي الفنيين' : 'TOTAL TECHNICIANS';
  String get activeRequestsAdmin =>
      _isArabic ? 'الطلبات النشطة' : 'ACTIVE REQUESTS';
  String get lastWeekStats =>
      _isArabic ? '+12% مقارنة بالأسبوع الماضي' : '+12% vs last week';
  String get pendingVerifications =>
      _isArabic ? 'طلبات التقارير المعلقة' : 'PENDING REPORT';
  String get reviewQueue => _isArabic ? 'قائمة المراجعة' : 'REVIEW QUEUE';
  String get pendingVerificationProfiles =>
      _isArabic ? 'طلبات التقارير المعلقة' : 'Pending Report';
  String get profilesRequireApproval => _isArabic
      ? 'الملفات الشخصية التي تحتاج موافقة الإدارة.'
      : 'Profiles requiring administrative approval.';
  String get activeServiceRequests =>
      _isArabic ? 'طلبات الخدمة النشطة' : 'Active Service Requests';
  String get liveTrackingFinancial => _isArabic
      ? 'متابعة مباشرة للطلبات والإشراف المالي.'
      : 'Live job tracking and financial oversight.';
  String get clientAndService =>
      _isArabic ? 'العميل والخدمة' : 'CLIENT & SERVICE';
  String get technicianAdmin => _isArabic ? 'الفني' : 'TECHNICIAN';
  String get level3Certified => _isArabic ? 'شهادة مستوى 3' : 'LVL 3 CERTIFIED';
  String get fullBackgroundCheck =>
      _isArabic ? 'فحص أمني كامل' : 'FULL BACKGROUND CHECK';
  String get epaCertified => _isArabic ? 'شهادة EPA' : 'EPA CERTIFIED';
  String get masterElectrician => _isArabic
      ? 'كهربائي محترف • خبرة 12 سنة'
      : 'Master Electrician • 12 yrs exp';
  String get hvacPlumbingSpecialist =>
      _isArabic ? 'متخصص تكييف وسباكة' : 'HVAC & Plumbing Specialist';
  String get emergencyPipeBurst => _isArabic
      ? 'انفجار أنبوب طارئ • #REQ-9012'
      : 'Emergency Pipe Burst • #REQ-9012';
  String get fullHomeRewiring => _isArabic
      ? 'إعادة تمديد كهرباء المنزل • #REQ-8845'
      : 'Full Home Rewiring • #REQ-8845';

  // Report Screen
  String get paymentMonitoring =>
      _isArabic ? 'مراقبة المدفوعات' : 'Payment Monitoring';
  String get paymentOverdue => _isArabic ? 'دفعة متأخرة' : 'PAYMENT OVERDUE';
  String get blockCustomerAccess =>
      _isArabic ? 'حظر وصول العميل' : 'Block Customer Access';
  String get blockingCustomerMessage => _isArabic
      ? 'سيؤدي حظر هذا العميل إلى إلغاء وصوله مباشرة إلى تطبيق FixIt Jo. يجب اتخاذ هذا الإجراء فقط عند تكرار عدم دفع الخدمات المؤكدة.'
      : 'Blocking this customer will immediately revoke their access to the FixIt Jo mobile application. This action should only by taken for repeated non-payment of verified services.';
  String get unpaidRequests =>
      _isArabic ? 'الطلبات غير المدفوعة' : 'Unpaid Requests';
  String get pendingItems => _isArabic ? 'عنصران معلقان' : '2 Pending Items';
  String get currency => _isArabic ? 'د.أ' : 'JD';
  String get roofRepair =>
      _isArabic ? 'إصلاح سقف القرميد' : 'Roof Shingle Repair';
  String get roofRepairDesc => _isArabic
      ? 'استبدال كامل لجزء القرميد الشمالي بعد أضرار العاصفة الهوائية. تم تأكيد الخدمة...'
      : 'Complete replacement of northern section shingles following wind storm damage. Service confirmed...';
  String get emergencyPipeLeak =>
      _isArabic ? 'تسرب أنبوب طارئ' : 'Emergency Pipe Leak';
  String get emergencyPipeLeakDesc => _isArabic
      ? 'إصلاح عاجل لتصريف حوض المطبخ. قطع الغيار واليد العاملة مشمولة في عرض سعر الخدمة النهائي.'
      : 'Urgent fix for kitchen sink drainage. Parts and labor included in the final service quote.';
  String get pending => _isArabic ? 'معلق' : 'Pending';
  String get unpaid => _isArabic ? 'غير مدفوع' : 'Unpaid';
  String get viewInvoice => _isArabic ? 'عرض الفاتورة' : 'View Invoice';
  String get totalOutstanding =>
      _isArabic ? 'إجمالي المستحقات' : 'Total Outstanding';
  String get daysPastDue => _isArabic ? 'أيام التأخير' : 'Days Past Due';
  String get days14 => _isArabic ? '14 يوم' : '14 Days';
  String get actionTaken => _isArabic ? 'الإجراء المتخذ' : 'Action Taken';
  String get monitoringActive =>
      _isArabic ? 'المراقبة مفعلة' : 'Monitoring Active';
  String get noPhoneNumber =>
      _isArabic ? 'لا يوجد رقم هاتف' : 'No phone number';
  String get dueOct12 => _isArabic ? 'مستحق 12 أكتوبر' : 'DUE OCT 12';
  String get dueOct05 => _isArabic ? 'مستحق 05 أكتوبر' : 'DUE OCT 05';
  String get robertHenderson =>
      _isArabic ? 'روبرت هندرسون' : 'Robert Henderson';

  // profeesion_screen
  String get manageProfessions =>
      _isArabic ? "إدارة المهن" : "Manage Professions";
  String get professionalCategories =>
      _isArabic ? "الفئات المهنية" : "Professional Categories";
  String get addNewProfession =>
      _isArabic ? "إضافة مهنة جديدة" : "Add New Profession";
  String get searchProfessions =>
      _isArabic ? "بحث عن المهن..." : "Search professions...";
  String get add => _isArabic ? "إضافة" : "Add";
  String get ProfessioName => _isArabic ? "اسم المهنة " : "Profession name";

  String get editProfession => _isArabic ? "تعديل المهنة" : "Edit Profession";
  String get addProfession => _isArabic ? "إضافة مهنة" : "Add Profession";
  String get noProfessionFound =>
      _isArabic ? "لم يتم العثور على أي مهن " : "No professions found";

  String get plumbingDesc => _isArabic
      ? "إصلاح الأنابيب، التركيب، وحلول الصرف"
      : "Includes pipe repair, installation, and drainage solutions";
  String get electricalDesc => _isArabic
      ? "تمديدات كهربائية وصيانة الإنارة"
      : "Wiring, lighting, and general electrical maintenance work";
  String get hvac => _isArabic ? "تكييف" : "HVAC";
  String get hvacDesc => _isArabic
      ? "تدفئة وتبريد وأنظمة تكييف"
      : "Heating, ventilation, and air conditioning specialists";
  String get carpentryDesc => _isArabic
      ? "تصليح الأثاث والأعمال الخشبية"
      : "Furniture repair, cabinetry, and structural wood work";
  String get activePros => _isArabic ? "محترف نشط" : " Active Pros";

  //setting screen

  // technicans by profesion
  String get technicians => isArabic ? "فنيون" : "Technicians";
  String get techniciansTitle => isArabic ? "فنيي" : "Technicians";

  String get managementPortall =>
      isArabic ? "بوابة الإدارة" : "MANAGEMENT PORTAL";

  String get experts => isArabic ? "خبراء" : "Experts";

  String get manageServiceQuality => isArabic
      ? "إدارة ومراقبة جودة الخدمات. مراجعة أداء الفنيين والتعامل مع الملاحظات والتقييمات."
      : "Manage and monitor service quality. Review technician performance and handle feedback.";

  String get noTechniciansFound =>
      isArabic ? "لا يوجد فنيون" : "No technicians found";

  String get jobs => isArabic ? "مهمة" : "jobs";

  String get lowRatingAlert =>
      isArabic ? "تنبيه تقييم منخفض" : "LOW RATING ALERT";

  String get activeTechnician => isArabic ? "فني نشط" : "ACTIVE TECHNICIAN";

  String get lowRatingDescription => isArabic
      ? "هذا الفني يمتلك تقييمًا منخفضًا. يمكن للمشرف مراجعة الأداء واتخاذ قرار بحظر الحساب."
      : "This technician has a low rating. Admin can review performance and decide whether to block the account.";

  String get acceptablePerformance => isArabic
      ? "أداء الفني حاليًا ضمن المستوى المقبول."
      : "Technician performance is currently acceptable.";

  // Plumbing Screen
  String get plumbingTechnicians =>
      _isArabic ? "فنيين السباكة" : "Plumbing Technicians";
  String get managementPortal =>
      _isArabic ? "لوحة الإدارة" : "MANAGEMENT PORTAL";
  String get expertPlumbers => _isArabic ? "خبراء السباكة" : "Expert Plumbers";
  String get plumbingDescription => _isArabic
      ? "إدارة ومراقبة جودة الخدمة لقسم السباكة."
            "\nمراجعة أداء الفنيين والتعامل مع ملاحظات المستخدمين."
      : "Manage and monitor plumbing service quality.\nReview technician performance and handle feedback.";
  String get totalPros => _isArabic ? "إجمالي الفنيين" : "TOTAL PRO'S";
  String get masterPlumber => _isArabic ? "خبير سباكة" : "MASTER PLUMBER";
  String get deainSpecialist =>
      _isArabic ? " أخصائي تصريف المياه" : "DRAIN SPECIALIST ";
  String get juniorPlumber => _isArabic ? "سباك مبتدئ" : "JUNIOR PLUMBER";
  String get plumber => _isArabic
      ? "يحظى باستمرار بالثناء على التزامه بالمواعيد وإصلاحاته المتخصصة للصمامات."
      : "Consistently receives praise for punctuality\nand specialized valve repairs.";
  String get deain => _isArabic
      ? "معدل حل عالي لمشاكل الصرف المعقدة في المباني متعددة الطوابق."
      : "High resolution rate for complex multi-storydrainage issues.";
  String get junior => _isArabic
      ? "تقارير متكررة عن تأخر وصول الفرق وعمليات تنظيف غير مكتملة"
      : "Frequent reports of delayed arrivals and\nincomplete cleanups.";
  String get message => _isArabic ? "رسالة" : "Message";
  String get sendMessage => _isArabic ? "إرسال الرسالة" : " Send Message";
  String get feedback => _isArabic ? "تقييم" : "Feedback";
  String get feedbackClicked => _isArabic ? "تقييم" : "Feedback";
  String get blockTechnician => _isArabic ? "حظر الفني" : "Block Technician";
  String get unblockTechnician =>
      _isArabic ? "إلغاء حظر الفني " : "UnBlock Technician";
  String get performanceAlert => _isArabic ? "تنبيه أداء" : "PERFORMANCE ALERT";
  String get latestAdminNote =>
      _isArabic ? "آخر ملاحظة إدارية" : "LATEST ADMIN NOTE";

  String techniciansIn(String service) => _isArabic
      ? 'فنيي ${translateService(service)}'
      : '${translateService(service)} Technicians';
  String expertsIn(String service) => _isArabic
      ? 'خبراء ${translateService(service)}'
      : '${translateService(service)} Experts';
  // customer repoort SCREEN
  String get customerReports =>
      _isArabic ? " تقارير العملاء" : "Customer Reports";
  String get reviewCustomer => _isArabic
      ? "مراجعة شكاوي العملاء المقدمة من قبل الفنيين "
      : "Review customer complaints submitted by technicians.";
  String get noCustomerReports =>
      _isArabic ? "  لا توجد تقارير من العملاء" : "No customer reports";
  String get noReasonProvided =>
      _isArabic ? 'لا يوجد سبب' : 'No reason provided';

  String get generalReport => _isArabic ? 'بلاغ عام' : 'General Report';

  String get customerBlocked =>
      _isArabic ? 'تم حظر العميل بنجاح' : 'Customer blocked successfully';

  String get reportIgnored => _isArabic ? 'تم تجاهل البلاغ' : 'Report ignored';

  String get ignore => _isArabic ? 'تجاهل' : 'Ignore';
  String reportedBy(String name) =>
      _isArabic ? 'تم الإبلاغ بواسطة: $name' : 'Reported by: $name';
  String requestId(String id) =>
      _isArabic ? 'رقم الطلب: $id' : 'Request ID: $id';
  // SETTINGS SCREEN
  String get securityAndPassword =>
      isArabic ? "الأمان وكلمة المرور" : "Security & Password";
  String get adminSettings => _isArabic ? "إعدادات الأدمن" : "Admin Settings";
  String get noPhone => _isArabic ? "لا يوجد رقم" : "No Phone";
  String get superAdmin => _isArabic ? "مدير عام" : "Super Admin";
  String get accountSettings =>
      _isArabic ? "إعدادات الحساب" : "ACCOUNT SETTINGS";
  String get preferences => _isArabic ? "التفضيلات" : "PREFERENCES";
  String get supportLegal => _isArabic ? "الدعم والقوانين" : "SUPPORT & LEGAL";
  String get accountInfo =>
      _isArabic ? "معلومات الحساب" : "Account Information";
  String get securityPassword =>
      _isArabic ? "الأمان وكلمة المرور" : "Security & Password";
  String get english => _isArabic ? "إنجليزي" : "English";
  String get notificationsEnabled =>
      _isArabic ? "تم تفعيل الإشعارات" : "Notifications Enabled";
  String get notificationsDisabled =>
      _isArabic ? "تم إيقاف الإشعارات" : "Notifications Disabled";
  String get arabicEnabled => _isArabic ? "تم تفعيل العربية" : "Arabic Enabled";
  String get englishEnabled =>
      _isArabic ? "تم تفعيل الإنجليزية" : "English Enabled";

  String get allServices => _isArabic ? 'جميع الخدمات' : 'All Services';

  String get noServicesFound =>
      _isArabic ? 'لم يتم العثور على خدمات' : 'No services found';

  // Rating Screen
  String get rateYourExperience =>
      _isArabic ? 'قيّم تجربتك' : 'Rate Your Experience';

  String get serviceProfessional =>
      _isArabic ? 'فني صيانة' : 'Service Professional';

  String get howWasService =>
      _isArabic ? 'كيف كانت الخدمة؟' : 'How was the service?';

  String get tapStar =>
      _isArabic ? 'اضغط على النجوم للتقييم' : 'Tap a star to rate';

  String get yourFeedback => _isArabic ? 'ملاحظاتك' : 'Your Feedback';

  String shareExperience(String name) => _isArabic
      ? 'شارك تجربتك مع $name...'
      : 'Share your experience with $name...';

  String get ratingSubmitted =>
      _isArabic ? 'تم إرسال التقييم بنجاح' : 'Rating submitted successfully';
  String translateTag(String tag) {
    switch (tag) {
      case 'Punctual':
        return _isArabic ? 'ملتزم بالوقت' : 'Punctual';

      case 'Professional':
        return _isArabic ? 'احترافي' : 'Professional';

      case 'Fair Pricing':
        return _isArabic ? 'سعر مناسب' : 'Fair Pricing';

      case 'Clean Work':
        return _isArabic ? 'عمل نظيف' : 'Clean Work';

      default:
        return tag;
    }
  }

  // Tracking translations
  String get serviceCompletedBody => _isArabic
      ? 'تم الانتهاء من خدمتك، يرجى تقييم تجربتك.'
      : 'Your service has been completed. Please rate your experience.';
  String get customerLocation =>
      _isArabic ? "موقع الزبون" : "Customer Location";
  String get tracking => _isArabic ? "جاري التتبع..." : "Tracking...";
  String get headToCustomer =>
      _isArabic ? "التوجه إلى الزبون" : "Head to customer";
  String get technicianOnTheWay =>
      _isArabic ? "الفني في الطريق" : "Technician on the way";
  String get youHaveArrived => _isArabic ? "لقد وصلت" : "You have arrived";
  String get technicianArrived =>
      _isArabic ? "وصل الفني" : "Technician arrived";
  String get jobCompleted => _isArabic ? "تم إنهاء المهمة" : "Job Completed";
  String get iArrived => _isArabic ? "وصلت" : "I Arrived";
  String get finishJob => _isArabic ? "إنهاء العمل" : "Finish Job";
  String get reportCustomer =>
      _isArabic ? "الإبلاغ عن الزبون" : "Report Customer";
  String get unpaidService =>
      _isArabic ? 'خدمة غير مدفوعة الأجر' : "Unpaid Service";
  String get reportSubmitted =>
      _isArabic ? "تم إرسال البلاغ للإدارة" : "Report submitted to admin";
  String get abusiveBehavior =>
      _isArabic ? "السلوك المسيء" : "Abusive Behavior";
  String get fakeRequest => _isArabic ? "طلب وهمي" : "Fake Request";
  String get other => _isArabic ? "أخرى" : "Other";

  String translateService(String service) {
    switch (service) {
      case 'Plumbing':
        return _isArabic ? 'سباكة' : 'Plumbing';

      case 'Electrical':
        return _isArabic ? 'كهرباء' : 'Electrical';

      case 'Carpentry':
        return _isArabic ? 'نجارة' : 'Carpentry';

      case 'Cleaning':
        return _isArabic ? 'تنظيف' : 'Cleaning';

      case 'AC Repair':
        return _isArabic ? 'صيانة تكييف' : 'AC Repair';

      case 'Heating':
        return _isArabic ? 'تدفئة' : 'Heating';

      case 'Furniture':
        return _isArabic ? 'أثاث' : 'Furniture';

      case 'Painting':
        return _isArabic ? 'دهان' : 'Painting';

      case 'Blacksmith':
        return _isArabic ? 'حدادة' : 'Blacksmith';

      default:
        return service;

      // settings_screen_technician
    }
  }

  // Map Screen
  // (confirmLocation already defined above)

  // Rating Screen
  // (rateService, submitRating, writeReview already defined above)

  // Tracking Screen
  // (trackOrder, technicianOnTheWay already defined above)
}
