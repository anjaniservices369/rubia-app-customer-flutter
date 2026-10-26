// =============================================================================
// WHAT : All on-screen text in the supported languages (English, Hindi,
//        Kannada, Telugu, Tamil).
// NOTES: Add or fix wording here. A missing translation falls back to English.
// =============================================================================
import 'package:base_project_flutter/constants/constants.dart';
import 'package:get/get.dart';

// >>> START: LanguageTranslations - all on-screen text in English, Hindi, Kannada, Telugu and Tamil
class LanguageTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_us': {
          'Person': 'Person',

          'resend_code': 'Resend Code?',
          'Choose_your_ride': 'Choose Your Ride',
          'Choose_your_service': 'Choose Your Service',

          'add_amount': 'Add Amount',
          'Oneway': 'One-way',
          'app_language': 'App Language',
          "Driver_details": "Driver Details",
          'Address_details': 'Address Details',
          'Bill_details': 'Bill Details',
          'Your_trusted_contacts': 'Your trusted contacts',
          'Share_your_ride_with_your_trusted_max_5_contacts':
              'Share your ride with your trusted max 5 contacts',
          'Ride_status': 'Ride Details',
          'Ride': 'Ride',
          'Loads': 'Loads',
          'Ride_now': 'Ride now',
          'myrides': 'My Rides',
          'Outstation': 'Outstation',

          'Rentals': 'Rentals',
          'Bike_Car_Auto': 'Bike, Car, Auto',
          'Load_now': 'Load now',
          'Outstation_service': 'Outstation service',
          'Rentals_service': 'Rentals service',
          'More_with_Taxi_Go': 'More with Taxi Go!',
          'Pickup_point': 'Pickup point',
          'Dropping_point': 'Dropping Point',
          'Search_Destination': 'Search Destination',
          'Pick_Up_Date': 'Pick Up Date',
          'Pick_Up_Time': 'Pick Up Time',
          'Return_Date': 'Return Date',
          'Return_Time': 'Return Time',
          'Later': 'Later',
          'Now': 'Now',
          "Book_Ride": 'Book Ride',
          'Select_destination_location': 'Select destination location',

          'My_favourite_locations': 'My favourite locations',

          "Place_not_in_area": "Place not in area",
          'Select_Vehicle': 'Select Vehicle',
          'Select_Package': 'Select Package',
          "Please_wait": "Please wait ...",
          'Please_hold_we_are_searching_for':
              'Please hold! we are searching for',
          'confirm_your_cancellation': 'Confirm Your Cancellation',
          'Once_you_cancel_your_ride_you_will_be_pay_fee_Rs_500_for_cancellations_as_per_our_policy':
              'Once you cancel your ride you will be pay fee Rs 500 for cancellations as per our policy',
          'nearby_skipper_for_you': 'nearby skipper for you',
          'Cancel_Ride': 'Cancel Ride',
          'Apply_Coupon_Code': 'Apply Coupon Code',
          'Pay_At_Drop': 'Pay At Drop',
          'Change_payment_Method': 'Change payment Method',
          'Your_skipper_is_arriving': 'Your skipper is arriving',
          'Your_skipper_is_arrived': 'Your skipper is arrived',
          'Price': 'Price',
          'Pay_now': 'Pay now',
          "Don't_press_back_until_the_payment_is_completed":
              "Don't press back until the payment is completed.",
          'Contact_driver': 'Contact driver',
          'Driver': 'Driver',
          'Your_ride_is_started': 'Your ride is started',
          'Skipper': 'Skipper',
          'Online_mode': 'Online mode',
          'Wallet_pay': 'Wallet pay',
          'Cash_mode': 'Cash mode',
          //LoginPageView

          'mobile_number': 'Mobile Number',
          'mobile_number_can\'t_be_empty': 'Mobile Number can\'t be empty',
          'mobile_number_must_be_10_digits': 'Mobile Number must be 10 digits',
          'enter_mobile_number': 'Enter Mobile Number',
          'login': 'Login',
          'invalid_number': 'Invalid Number',
          'get_otp': 'Get OTP',

          // otp page
          'otp_verification': 'OTP Verification',
          'enter_otp':
              'Enter the 4 digit code we sent you to verify your phone number',
          'otp_length_not_match': 'OTP length did not match',
          // personal details
          'error': 'Error',
          'you_must_be_at_least_15_years_old':
              'You must be at least 15 years old',
          'enter_your_dob': 'Please enter your date of birth',
          'personal_details': 'Personal Details',
          'Full_name': 'Full Name',
          'Full_name_empty': 'Full name can\'t be empty',
          'enter_full_name': 'Enter full name',
          'last_name': 'Last Name',
          'last_name_empty': 'Last name can\'t be empty',
          'last_name_min_1_digit': 'Last name must be minimum 1 digits',
          'enter_last_name': 'Enter last Name',
          'email': 'Email',
          'enter_email': 'Enter your email address',
          'enter_correct_email': 'Please enter valid email address',
          'dob': 'Date Of Birth',
          'gender': 'Gender',
          'male': 'Male',
          'female': 'Female',
          'others': 'Others',
          'oops': 'Oops',
          'gender_empty': 'Gender Can\'t be empty',
          'select_dob': 'Please select a Date Of birth',
          // Emergency contacts
          'emergency_contacts': 'Emergency Contacts',
          'emergency_contact': 'Emergency Contact',
          'skip': 'Skip',
          'person1': 'Person 1',
          'name': 'Name',
          'name_empty': 'Name can\'t be empty',
          'phone_number': 'Phone Number',
          'relationship': 'Relation ship',
          'relation_empty': 'Relation ship Cant Be Empty',
          'Eg: father': 'Eg: Father',
          'person2': 'Person 2',
          // referral page
          'referral_code': 'Referral Code',
          'enter_refer_code': 'Enter Referral Code',
          'referral_empty': 'Enter refer Code Can"t be Empty',
          'enter_code': 'Enter Code',
          'submit': 'Submit',
          // enable location
          'cannot_get_current_location': 'cannot get current location',
          'enable_gps_try_again':
              'please make sure you enable gps and try again',
          'location_not_available': 'Location Not Available',
          'got_your_location': 'We Got Your Location',
          'unable_to_fetch_location': 'Unable to fetch this address',
          'change_location': 'Change Location',
          'enable_your_location': 'Enable your location to ',
          'allow_to_use_location':
              'Please allow to use your location to see nearby store on the map.',
          'enable_location': 'Enable Location',
          'app_settings': 'app settings',
          // bottom navigation
          'home': 'Home',
          'bookings': 'Bookings',
          'wallet': 'Wallet',
          'profile': 'Profile',
          // home page
          'more': 'More',
          // Select ride type
          'select_ride_type': 'Select ride type',
          'one_way': 'One-way trip',

          'round': 'Round trip',
          'in_city': 'Incity',
          'out_station': 'Out station',
          'automatic': 'Automatic',
          'manual': 'Manual',
          'pick_up_location': 'Select Pickup Location',
          'drop_location': 'Select Drop Location',
          // favlocations
          'choose_from_favourites': 'Choose from the favourites',
          'error_fetching_favorite': 'Error fetching favorite locations',
          'no_favorites_found': 'No favorite locations found',
          'office': 'Office',
          'sorry': 'Sorry',
          'select_from_map': 'Select From Map',
          //  pickupgooglemap
          'find_a_place': 'Find a place ...',
          'please wait': 'Please wait ...',
          'select_location': 'Select Locations',
          'place_not_in_area': 'Place not in area',
          'check_location': 'Check Location',
          'we_are_unable_to_find_your_pin_code_please_drag_the_place_picker':
              'we are unable to find your pin code. please drag the place picker',
          // clock
          'select_date': 'Select Date',
          'select_time': 'Select Time',
          'invalid_time': 'Invalid Time',
          'please_select_future_time': 'Please select a future time.',
          'cancel_reason_booked_by_mistake': 'Booked by mistake',
          'cancel_reason_change_of_plans': 'Change of plans',
          'cancel_reason_found_another_ride': 'Found another ride',
          'select_date_time': 'Please select Date and Time',
          // one way
          'get_damage_protection':
              'Get vehicle damage protection plan for your car at ',
          '100_gst': '₹100 + GST. ',
          't_c_apply': 'T&C apply',
          'estimate_fare': 'Estimate fare',
          'estimate_usage': 'Estimate usage',
          'hours': 'Hours',
          'coupon': 'Coupon',
          'cash': 'Cash',
          // RentalVehicleInfo
          'beyond_1km':
              'If the trip extends beyond 1KM,extra charges as $currencySymbol 9 per KM is applicable',
          '1min_extra':
              'If the trip extends time,extra charges as $currencySymbol 2 per extra min applicable',
          'night_charge':
              'Night Charge $currencySymbol 300 on drives ending between 10:00PM & 05:59AM ',
          'final_fare':
              'Final Fare will be Charged basis actual distance and time',
          'cancellation_fee':
              'According to our Cancellation Policy,Charge of  $currencySymbol 300 on Cancellation ',
          // apply coupon
          'apply_coupons': 'Apply Coupons',
          'enter_coupon_code': 'Enter Coupon Code',
          'apply': 'Apply',
          'available_coupons': 'Available coupons',
          'coupon_applied_successfully': 'Coupon applied successfully!',
          'read_more': 'Read More',
          //Payment method
          'payment': 'Payment Method',
          'pay': 'To Pay',
          'Recent': 'Recently Used',
          'google': 'Google Pay',

          'Visa': 'VISA, Rupay, Mastercard',
          'Upi': 'UPI',
          'Phone': 'Phone Pay',
          'Choose': 'Choose Payment Method',
          'Pay at': 'Pay At Drop',
          'Cash': 'Cash',
          'Add': 'ADD MONEY',
          'Notifaction': 'Notifications',
          'after_ride_pay_by_scanning_QR_code':
              'Go cashless, after ride pay by scanning QR code',
          'add_new_upi': 'Add New UPI ID',
          'you_need_to_have_registered_upi_id':
              'You need to have a registered UPI ID',
          'Confirm_Ride': 'Confirm Ride',
          'failed_to_save_try_again': 'Failed to save. Please try again.',
          // order placed
          'order_placed': 'Your order has been placed',
          'ride_is_placed_please_wait':
              'Please wait untill  the driver assigned',
          'prices_may_vary':
              'Kindly be aware that the pricing structure is influenced by the distance & time traveled.',
          // Bookings
          //My Rides
          "Active_Rides": "Active Rides",
          "Completed": "Completed",
          "Cancelled": "Cancelled",
          "Track_Rider": "Track ride",
          "Contact_Rider": "Contact ride",
          'invoice': 'Invoice',
          // booking history
          'failed_to_fetch_bookings': 'Failed to fetch bookings.',
          'total_price': 'Total Price',
          // ride details
          'ride_id': 'Ride Id',
          'date': 'Date',
          'distance': 'Distance',
          'mins': 'Mins',
          'duration': 'Duration',
          'total_amount': 'Total Amount',
          'gst': 'GST',
          'sub_total': 'Sub total',
          'discount': 'Discount',
          'give_rating': 'Give Rating',
          'write_a_review_to': 'Write a review',
          'need_help': 'Need help',
          'waiting_for_driver': 'Waiting For Driver to accept',
          'price': 'Price',
          'waiting_for_driver_': 'Waiting For Driver',
          'hr_usage': 'hrs usage',
          'customer_support': 'Customer Support',
          'chat': 'Chat',
          'support': 'Support',
          // Walletpage

          'all_transactions': 'All Transactions',
          'enter_amount': 'Enter Amount',
          'add': 'Add',
          'Edit_Emergency_Contact': 'Edit Emergency Contact',
          'delete_contact': 'Delete Contact',
          'Ride_Id ': 'Ride Id ',

          'available_balance': 'Available Balance',
          'amount_empty': 'amount can\'t be empty',
          'enter_valid_email': 'Enter a valid email address',
          'edit_profile': 'Edit Profile',
          //ReviewsView
          'rating_reviews': 'Rating & Reviews',
          "rating": "Rating",
          //NotificationView
          'notifications': 'Notifications',
          'clear': "Clear",
          "start_your_first_ride_with_winter_Offers.":
              "Start Your First Ride with Winter offers.",
          "happy_winter_offer_On_Your_first_ride,_enjoy_ride_With_best_offers._check_It_Now":
              "Happy Winter Offer on your First Ride, Enjoy Ride with Best Offers. Check it now",
          "2_Days_Ago": "2 days ago",
          // favourites
          'save_as_favorite': 'Save as Favorites',
          'delete_contact': 'Delete Contact',
          'are_you_sure': 'Are you sure you want to delete this contact',
          'failed_to_delete': 'Failed to Delete Emergency Contact',
          // logout
          'do_you_want': 'Do you want to log out ?',
          'logout_failed': 'Logout Failed',
          'please_retry': 'Please retry',

          'OTP': 'OTP',
          'No': 'No',
          'Yes': 'Yes',
          'Submit_your_rating': 'Submit your rating',
          'long_Pickup': 'Long Pickup',

          'You_rated': 'You rated',
          'Are_you_sure_you_want_to_sign_out':
              'Are you sure you want to sign out?',
          'Cancel': 'Cancel',
          'OK': 'OK',

          'Favorites_Location': 'Favorite Location',
          'Choose_Language': 'Choose Language',

          'logout': 'Logout',
          'Amount': 'Amount',
          'Ride_Status': 'Ride Status',
          'New_Request': 'New Request',
          'Ride_Booked': 'Ride Booked',
          'Complete_Totally': 'Complete Totally',
          'Payment_Type': 'Payment Type',
          'email_cant_be_empty': "email can't be empty",
          'please_enter_a_valid_email_address':
              'please enter a valid email address',
          'Privacy_Policy': 'Privacy Policy',

          'Add_New': 'Add New',
          'TaxiGo': 'TaxiGo',

          'Edit_Profile': 'Edit Profile',
          'edit': 'Edit',
          'Profile': 'Profile',

          'aadhar_number': 'Aadhar Number',

          'Error_of_coupons': 'Error of coupons',
          'No_rides_found': 'No rides found',
          'Select_Title': 'Select Title',
          'Save_as_Favorites': 'Save as Favorite',
          'Replace': 'Replace',
          'Please_choose_a_title_for_selected_address':
              'Please choose a title for selected address',
          'Title': 'Title',
          'enter_title': 'enter title',
          'Save': 'Save',
          'Delete': 'Delete',
          'Delete_Address': 'Delete Address',
          'Are_you_sure_you_want_to_delete_this_address':
              'Are you sure you want to delete this address',

          'Date': 'Date',
          'Ride_Id': 'Ride Id',

          'km': 'km',
          'amount_cant_be_empty': "amount can't be empty",
          'Enter_amount': 'Enter amount',
          'Minimum_200_required_to_unlock_withdraw':
              'Minimum ₹200 required to unlock withdraw',

          'By_login_you_agree_to_our': 'By login you agree to our',
          'Date_of_birth': 'Date of birth',
          'Enter_valid_date': 'Enter valid date',
          'Enter_date_in_valid_range': 'Enter date in valid range',

          'send_to': 'Send to',
          'We_unable_to_get_your_Pincode': 'We unable to get your Pincode',
          'help': 'Help',
          'Pay': 'Pay',

//homePage
          "select_location": "Select Location",

          ///
          "Payment_paid_from_wallet": "Payment paid from wallet",
          "Wait_for_payment": "Wait for payment",
          "your_uPI": "Your UPI",
          'Get_vehicle_damage_protection_plan_for_your_carat₹100_GST_T&C_apply':
              'Get vehicle damage protection plan for your car at  ₹100 + GST. T&C apply',
          // settingpage
          "Also_notify_when_receiving_invites":
              "Also notify when receiving invites",

          "Left_from_school": "Left from school",
          "Hangouts_video_call": "Hangouts video call",
          "Reached_at_school": "Reached at school",
          "When_bus_reached_at_pickup_remainder_spot":
              "When bus reached at pickup remainde pot",
          "Drop_Notifications": "Drop Notifications",
          "When_bus_reached_at_pickup_remainder_spot":
              "When bus reached at pickup remainder spot",
          "Pick_up_Notifications": "Pick up Notificationst",
          "When_bus_started_at_starting_point_remainder_spot":
              "When bus started at starting point remainder spot",
          "Bus_trip_start_Notifications": "Bus trip start Notifications",
          "Settings": "Settings",

          //   otp_page
          "privacy_policy": "Privacy Policy",
          'please_select_terms_conditions': 'Please select Terms & Conditions.',
          "and": "and",
          "by_login_you_agree_to_our": "By login you agree to our",
          'resend(30s)': 'Resend(30s)',
          "don't_receive_the_code?": "Don't receive the code?",
          "Log_in": "Log in",
          "OTP_length_did_not_match": "OTP length did not match",
          "please_enter_OTP": "Please enter OTP",
          "sent_to": "Sent to",
          'ok': 'OK',

          //support
          "support": "Support",
          "easy_go": "TaxiGo",

          //ride info
          "ride_info": "Ride Info",
          'ride_id: ': 'Ride Id: ',
          //rideDetails
          'cancel_ride': 'Cancel Ride',
          //payNow
          'please_Pay_The_Amount\nBefore_Contuning':
              'Please pay the amount\nbefore contuning',
          'payout_details': 'Payout Details',
          'pay_now': 'Pay Now',
          'skip': 'Skip',
          'payment_under_process': 'Payment Under Process',
          'please_Don’t_Go_Back_Or_Refresh_The_Page\nas_We_Are_Processing_Your_Payment':
              'Please don’t go back or refresh the page\nas we are processing your payment',
          //customerSupport
          'please_Select_Reason_For_Cancel_ride':
              'Please select reason for cancel ride',
          'unsafe_Pickup_area': 'Unsafe pickup Area',
          'unable_To_Swipe_Arrived': 'Unable to swipe arrived',
          'wrong_Pickup_Location': 'Wrong pickup location',
          'long_Pickup': 'Long pickup',
          'heavy_Traffic': 'Heavy traffic',
          //BackCollectedButton
          'back': 'Back',
          //RateCard
          'rate_card': 'Rate Card',
          'monday_To_sunday': 'Monday to Sunday',
          'maximum_Payout_Limit_Is_₹500': 'Maximum payout limit is ₹500',
          "bike": "Bike",
          "auto": "Auto",
          //BikeInfo
          'base_Fare': 'Base fare',
          'minimum_Fare': 'Minimum fare',
          'earning_Per_km': 'Earning per Km',
          'price_Per_Minute': 'Price per minute',
          'platform_Charge': 'Platform charge',
          'outstation_rides': 'Outstation Rides',

          'pickup_extra_km_Fare_Post_2km': 'Pickup Extra km fare post 2km',
          '(Max_10)': '(max 10)',
          'every_Km_Till_8km': 'Every km till 8km',
          'Per_Km ': 'per km ',
          'every_Km_Above_8km': 'Every km above 8km',
          //CollectPaymentView
          'collect_payment': 'Collect Payment',
          'ride_iD: ': 'Ride ID: ',
          "collect_amount": "Collect Amount",
          'generate_qR_code': 'Generate QR Code',
          'or': 'Or',
          'Cash': 'Cash',
          'collect_cash': 'Collect Cash',
          //CollectCash
          'collect_Cash_Form_The_Customer.': 'Collect cash form the customer.',
          'collected': 'Collected',
          //ChooseAppLanguageView
          'chengee': 'Chenge',
          'app_languagee': 'app language',
          ////
          'english': 'English',
          'hindi': 'Hindi',
          'kannada': 'Kannada',
          'telugu': 'Telugu',
          'tamil': 'Tamil',
          'gujarati': 'Gujarati',
          'app_language': 'App Language',
          'set_language': 'Set Language',
          'Add_Review': 'Add Reveiw',
          //AddDetailsView
          'add_details': 'Add Details',
          '_Details': 'Personal details',
          'vehicle_Details': 'Vehicle details',
          'documents': 'Documents',
          'bank_Details': 'Bank details',
          'i_agree_to_the': 'I agree to the ',
          'terms_conditions': 'Terms&Conditions',
          'alert': 'Alert!!!',
          'next': 'Next',
          //VehicleRegistration
          'vehicle_registration_card_(RC)': 'Vehicle Registration Card (RC)',
          'upload_your_vehicle_registration_card_(RC)':
              'Upload Your Vehicle Registration Card (RC)',
          'front_side': 'Front Side',
          "Camera": "camera",
          "Gallery": "Gallery",
          'back_side': 'Back Side',
          'rC_number': 'RC Number',
          'rC_Number_Cant_Be_Empty': 'RC nuumber cant be empty',
          'rC_Number_Must_be_Minimum_10_Characters':
              'RC nuumber must be minimum 10 characters',
          'enter_rC_number': 'Enter RC Number',
          'save': 'Save',
          ' Add_Emergency_Contact': 'Add Emergency Contact',
          ' Edit_Emergency_Contact': 'Edit Emergency Contact',
          //TakeYourSelfie
          'add_your_selfie': 'Add Your Selfie',
          'take_your_selfie': 'Take Your Selfie',
          'we_Use_Your_Selfie_To_Compare_With_Your_id':
              'We use your selfie to compare with your Id',
          'good_Lighting': 'Good lighting',
          'make_Sure_You_Are_In_A_Well_Lit_Area_And_Both_Ears_Are_Uncovered ':
              'Make sure you are in a well lit area and both ears are uncovered ',
          'look_Straight': 'Look straight',
          'hold_Your_Phone_At_Eye_Level_And_Looks_Straight_To_The_Camera':
              'Hold your phone at eye level and looks straight to the camera',
          'open_camera': 'Open Camera',

          'month/date/year': 'Month/Date/Year',
          'enter_Valid_Date': 'Enter valid date',
          'enter_Date_In_Valid_Range': 'Enter date in valid range',

          'first_name': 'First Name',
          'firstName_Cant_Be_Empty': 'FirstName cant be empty',
          'firstName_Must_Be_Minimum_1_Digits':
              'FirstName must be minimum 1 digits',
          'full_name': 'Full Name',
          'last_name': 'Last Name',
          'lastName_Cant_Be_Empty': 'LastName cant be empty',
          'lastName_Must_Be_Minimum_1_Digits':
              'LastName must be minimum 1 digits',
          'Enter_last': 'Enter last name',

          'enter_mail_id': 'Enter Mail Id',
          'Enter_email': 'Enter your email address',
          'e-mail_Address': 'E-mail address',
          "invalid_email": "Invalid Email",
          'enter_date_Of_birth': 'Enter Date of Birth',

          'home_address': 'Home Address',
          'home_addres_Cant_Be_Empty': 'Home Addres cant be empty',
          'home_addres_Must_Be_Minimum_1_Digits':
              'Home Addres must be minimum 1 digits',
          'enter_home_address': 'Enter Home Address',
          'city': 'City',
          'city_Cant_Be_Empty': 'City cant be empty',
          'city_Must_Be_Minimum_1_Digits': 'City must be minimum 1 digits',
          'enter_City': 'Enter city',
          'state ': 'State ',
          'state_Cant_Be_Empty': 'State cant be empty',
          'state_Must_Be_Minimum_1_Digits': 'State must be minimum 1 digits',
          'enter_State': 'Enter  state',
          'pincode': 'Pincode',
          'pincode_Cant_Be_Empty': 'Pincode cant be empty',
          'pincode_Must_Be_Minimum_6_Digits':
              'Pincode must be minimum 6 digits',
          'enter_Pincode': 'Enter pincode',
          'pay': 'Pay',
          //PanCard
          'pAN_card': 'PAN Card',
          'upload_your_pAN_card': 'Upload Your PAN Card',
          'pAN_number': 'PAN Number',
          'pAN_Number_Can_Not_Be_Empty.': 'PAN number can not be empty.',
          'enter_pAN_number': 'Enter PAN Number',
          //VechileSelection
          'job_details': 'Vehicle details',
          'which_Vehicle_Will_You_Use?': 'Which vehicle will you use?',
          'vehicle_type': 'Vehicle Type',
          'electric': 'Electric',
          'non-electric': 'Non-electric',
          "Km)": 'km)',
          //DrivingLicense
          'driving_license': 'Driving Licence',
          'driving_license': 'Driving License',
          'select_expiry_date': 'Select expiry date',
          'learner’s_License_Not_Allowed.': 'Learner’s license not allowed.',
          'driving_license_number': 'Driving Licence Number',
          'driving_License_Cant_Be_Empty': 'Driving Licence cant be empty',
          'driving_License_Must_Be_Minimum_16_Characters':
              'Driving Licence must be minimum 16 characters',
          'expiry_date': 'Expiry Date',
//Documents
          'upload_All_documents,_required_For_Your_Verification.':
              'Upload all Documents, Required for your verification.',
          'aadhar_card': 'Aadhar Card',
          //Demo
          'membership_For_45_Days': 'Membership for 45 days',
          'free': 'Free',
          '10_Days_Left': '10 days left',
//BankDetails
          'enter_A_Valid_iFSC_Number.': 'Enter a valid IFSC number.',
          'add_your_bank_details': 'Add Your Bank Details',
          'account_holder_name': 'Account holder name',
          'enter_bankholder_name_Cant_Be_Empty':
              'Enter Bankholder Name cant be empty',
          'enter_bankholder_name_Must_Be_Minimum_3_Characters':
              'Enter Bankholder Name must be minimum 3 characters',
          'enter_Bank_Holder_Name': 'Enter bank holder name',
          'account_Number': 'Account number',
          'account_Number_Cant_Be_Empty': 'Account number cant be empty',
          'account_Number_Must_Be_9_To_17_Digits':
              'Account number must be 9 to 17 digits',
          'iFSC_Code': 'IFSC code',
          'ifsc_Code_Can_Not_Be_Empty.': 'Ifsc code can not be empty.',
          'enter_Valid_Ifsc_Code': 'Enter valid ifsc code',
          'enter_Ifsc_Code': 'Enter ifsc code',
          'bank_name': 'Bank name',
          'bank_Name_Can_Not_Be_Empty.': 'Bank name can not be empty.',
          'enter_bank_Name': 'Enter bank name',
          'add_your_uPI': 'Add Your UPI',
          'uPI': 'UPI',
          'uPI_Id_Can_Not_Be_Empty.': 'UPI id can not be empty.',
//AdharCard
          'aadhar_card': 'Aadhar Card',
          'aadhar_Number': 'Aadhar number',
          'aadhar_number_Cant_Be_Empty': 'Aadhar Number cant be empty',
          'aadhar_number_Must_Be_12_Digits': 'Aadhar Number must be 12 digits',

//OrderCompletedView
          'ride_completed': 'Ride Completed',
          'great_job!': 'Great Job!',
          'ride_successfully_completed': 'Ride Successfully Completed',
          'total_Distance : ': 'Total distance : ',
          'total_Ride_Time : ': 'Total ride time : ',
          'amount': 'Amount',
          'Discount': 'Discount',
          'ready_for_next_order': 'Ready For Next Order',
          //ProfileReview
          ' rejected': ' Rejected',
          'please_Contact_Admin_Support': 'Please contact admin support',
          "your_Profile_Is_Under_Reviewing\nprocess._Please_Wait_2_To_4_Days":
              "Your profile is under review.\nPlease wait 2 to 4 days",
//ReferAndEarnView
          "refer_&_earn": "Refer & Earn",
          "refer_friends": "Refer Friends",
          "earn_Upto_₹100_Per_Friend_You_Invite":
              "Earn upto ₹100 per friend you invite",
          "my_rewards": "My Rewards",
          "share_Your_Invite_Code": "Share your invite code",
          "When_your_friends_sign_up_this_referral_code_you_can_received_a_free_ride":
              "When your friends sign up this referral code, you can received a free ride",

          'refer': 'Refer',
//ReferalCodeView

          "Referra_cod_(Optional)": "Referral code (Optional)",

          'hello,_skipper': 'Hello, Skipper',
          'your_Account_Will_Be_Registered_With_This_Mobile_Number':
              'Your account will be registered with this mobile number',
          "have_a_referral_code?": "Have A Referral Code?",

          'referal_Code_Must_Be_5_Digits': 'Referal code must be 5 digits',

//RideHistoryView
          'ride_history': 'Bookings',
          'today': 'Today',
          "all": "All",
          "completed": "Completed",
          "rejected": "Rejected",

          //RideHistoryCard
          'online_paid ': 'Online Paid ',
          'yesterday': 'Yesterday',
          'week': 'Week',
          'custom': 'Custom',

          '_Details': 'Personal Details',
          //homepage drawer
          'earnings': 'Earnings',
          'order_history': 'Order History',
          'rating_reviews': 'Rating & Reviews',

          'refer_earn': 'Refer & Earn',
          //homepage earningcard
          'enable_location_to_get_nearby_rides':
              'Enable location to get near by\nSkippers',
          'enable_location': 'Enable Location',
          'todays_earnings': 'Today\'s Earnings',
          'cash_collected': 'Cash Collected',
          //homepage flutterripplewidget
          'go_online': 'Go Online',
          //homepage currentlyofflinecard
          'offine_message':
              'You’re currently Offline, Please\ngo Online to Start earning',
          //homepage RoutingBooking
          'my_route_booking': 'My Route Booking',
          //riplepage widget
          'offline': 'Offline',
          'online': 'Online',
          //riplepage widget AccetedOrderCard
          'pickup': 'Pickup',
          'min_away': ' min away',
          'reject': 'Reject',
          "accept_ride": 'Accept Ride',
          'arrived': 'Arrived',
          'complete_ride': 'Complete Ride',
          'ride_id:': 'Ride Id:',

          'please_ask_otp_to_the_Customer': 'Please ask OTP to the customer',
          'otp_length_didn\'t_match': 'OTP length didn\'t match',
          'start_ride': 'Start Ride',
          'Go_to_drop_Location': 'Go to drop location',
          'go_to_pick_up': 'Go to pick up',
          //earningpage
          'today’s_earning': 'Today’s Earning',
          'payout': 'Payout',
          'history': 'History',
          //today earning
          'rides': 'Rides',
          'Km': 'Km',

          'avg_rating': 'Avg Rating',
          'reject_rides': 'Reject Rides',
          'today\'s_earning': 'Today\'s Earning',
          "order_id :": 'Order id :',
          //payout
          'online_collection': 'Online Collection',
          'amount_to_Pay': 'Amount to pay',
          'total_collected_cash': 'Total Collected Cash',
          'tax_charges': 'Tax Charges',
          'gst_payable_to_the_government.': 'GST payable to the government.',
          'platform_charge': 'Platform Charge',

          'Daily_one_time_fee.': 'Daily one time fee.',
          'transaction_fees': 'Transaction Fees',
          'Towards_unavoidable_costs_for\noperating_the_app':
              'Towards unavoidable costs for\noperating the app',
          'payable_amount': 'Payable Amount',
          'maximum_payout_limit_is ': 'Maximum payout limit is ',
          'please_pay_below-charges': 'Please pay below charges',
          'Immediately': 'immediately',
          'total_earnings': 'Total Earnings',
          'rides)': 'Rides)',
          //ride earning details
          'ride_details': 'Ride Details',
          'time_fare ': 'Time Fare ',
          'distance_fare ': 'Distance Fare ',
          'surge': 'Surge',
          'your_earnings': 'Your Earnings',

          //ride details-total rechargrcard
          'ride_amount': 'Ride Amount',
          'amount_pay_to_company': 'Amount Pay to Company',
          //profile
          'profile': 'Profile',

          'vehicle': 'Vehicle',
          'bank_details': 'Bank Details',

          //profile-liceience

          'DL_number': 'DL_number',
          'DL_expiry_date': 'DL expiry ate',
          'Upload_driving_license_back': 'Upload driving license back',
          'Upload_driving_license_front': 'Upload driving license front',
          'upload_rc_back_side': 'Upload RC Back Side',
          'please_enter_license_number': 'Please Enter License Number',
          'please_enter_valid_driving_license':
              'Please Enter Valid Driving License',
          'update': 'Update',
          //profile-aadhar card

          'Aadhar_number': 'Aadhar number',
          'upload_Aadhar_back_side': 'Upload Aadhar Back side',
          'upload_Aadhar_back_side': 'Upload Aadhar Back side',
          'Upload_adhar_card_back': 'Upload Aadhar Back side',
          'Upload_adhar_card_front': 'Upload Aadhar Back side',

          //profile-editVechileRegister
          'please_enter_rc_number': 'Please Enter RC Number',
          'please_enter_valid_rc_number': 'Please Enter Valid Rc Number',

          //profile-pancard
          'PAN_number': 'PAN number',
          'Upload_Pan_card_front': 'Upload Pan Card Front',
          'please_enter_pancard_number': 'Please Enter Pancard Number',
          'please_enter_valid_pancard_number':
              'Please Enter Valid Pancard Number',

          //profile-bandetails
          'ifsc': 'IFSC',
          'please_enter_ifsc_number': 'please enter IFSC number',
          'please_enter_valid_ifsc_number': 'please enter valid IFSC number',
          'please_enter_upi_number': 'please enter UPI number',
          'Please_enter_valid_upi_number': 'Please Enter valid UPI number',

          //Payment method
          'payment': 'Payment Method',
          'pay': 'To Pay',
          'Recent': 'Recently Used',
          'google': 'Google Pay',
          'Debit': 'Debit',
          'Visa': 'VISA, Rupay, Mastercard',
          'Upi': 'UPI',
          'Phone': 'Phone Pay',
          'Choose': 'Choose Payment Method',
          'Pay at': 'Pay At Drop',
          'Cash': 'Cash',
          'Add': 'ADD MONEY',
          'Notifaction': 'Notifications',
          //personal details

          'Referal': 'Referral code',
          'skip': 'Skip',
          'Enter_refrer': 'Enter refer code',
          'Referral_code': 'Referral code can"t be empty',
          'Claim_your_Special': 'Claim your special offer!',
          'Rate_your_exp': 'Rate Your Experience To',
          'Skipper': 'Skipper',
          'Are_you_Satisfied': 'Are you satisfied with our service',

          'Thank_you_For': 'Thank you for your rating',

          'cancel_ride': 'Cancel Ride',
          'Please_select_Reason': 'Please select reason for cancel ride',

          //personal details
          'Personal_Details': 'Personal Details',
          'First_Name': 'First Name',
          'Firstname_empty': 'Firstname can"t be empty',
          'Enter_name': 'Enter first name',
          'Last_Name': 'Last Name',
          'Referal': 'Referral code',
          'skip': 'Skip',
          'Enter_refrer': 'Enter refer code',
          'Referral_code': 'Referral code can"t be empty',
          'Claim_your_Special': 'Claim your special offer!',
          'Rate_your_exp': 'Rate Your Experience To',
          'Skipper': 'Skipper',
          'Are_you_Satisfied': 'Are you satisfied with our service',
          'Write_a_review_to_rider': 'Write a review to rider',
          'Thank_you_For': 'Thank you for your rating',

          //Payment method
          'payment': 'Payment Method',
          'pay': 'To Pay',
          'Recent': 'Recently Used',
          'google': 'Google Pay',

          'Visa': 'VISA, Rupay, Mastercard',
          'Upi': 'UPI',
          'Phone': 'Phone Pay',
          'Choose': 'Choose Payment Method',
          'Pay at': 'Pay At Drop',
          'Cash': 'Cash',
          'Add': 'ADD MONEY',
          'Notifaction': 'Notifications',
          //personal details
          'Personal_Details': 'Personal Details',
          'First_Name': 'First Name',
          'Firstname_empty': 'Firstname can"t be empty',
          'Enter_name': 'Enter first name',
          'Last_Name': 'Last Name',
          'Referal': 'Referral code',
          'skip': 'Skip',
          'Enter_refrer': 'Enter refer code',
          'Referral_code': 'Referral code can"t be empty',
          'Claim_your_Special': 'Claim your special offer!',
          'Rate_your_exp': 'Rate Your Experience To',
          'Skipper': 'Skipper',
          'Are_you_Satisfied': 'Are you satisfied with our service',
          'Write_a_review_to_rider': 'Write a review to rider',
          'Thank_you_For': 'Thank you for your rating',
          'pay_at': 'Pay At Drop',
          'change_payment': 'Change payment Method',

          'Phone_Number_Cant_Be_Empty': 'Phone number cant be empty',
          'name_Cant_Be_Empty': 'Name cant be empty',
          'relation_ship_Cant_Be_Empty': 'Relationship cant be empty',
          'aadhar_number_Cant_Be_Empty': 'Aadhar number cant be empty',
          //favourite location
          "this_Address": 'this address',
          //refaeral code
          'referal_code': 'Referal code Copied Sucessfully',
          'share_your_refer': 'Share Your Refer Code',
          // Taxi services
          'taxi': 'TAXI'
        },
        'hi_in': {
          //suport
          "support": "सहारा",
          "easy_go": "आसानी से जाना",
          "customer_support": "ग्राहक सहायता",
          "chat": "बात करना",
          //ride info
          "ride_info": "सवारी की जानकारी",
          'ride_id: ': 'सवारी आईडी: ',
          //rideDetails
          'cancel_ride': 'राइड रद्द करें',
          //payNow
          'please_Pay_The_Amount\nBefore_Contuning':
              'कृपया राशि का भुगतान करें\nआगे बढ़ने से पहले',
          'payout_details': 'भुगतान विवरण',
          'pay_now': 'अब भुगतान करें',
          'skip': 'छोड़ें',
          'payment_under_process': 'भुगतान प्रक्रियाधीन है',
          'please_Don’t_Go_Back_Or_Refresh_The_Page\nas_We_Are_Processing_Your_Payment':
              'कृपया वापस न जाएं या पेज को रीफ्रेश न करें\nक्योंकि हम आपका भुगतान संसाधित कर रहे हैं',
          //customerSupport
          'please_Select_Reason_For_Cancel_ride':
              'कृपया राइड रद्द करने का कारण चुनें',
          'unsafe_Pickup_area': 'असुरक्षित पिकअप क्षेत्र',
          'unable_To_Swipe_Arrived': 'स्वाइप करने में असमर्थ आ गया',
          'wrong_Pickup_Location': 'गलत पिकअप स्थान',
          'long_Pickup': 'लंबा पिकअप',
          'heavy_Traffic': 'भारी यातायात',
          //BackCollectedButton
          'back': 'पीछे',
          //RateCard
          'rate_card': 'दर पत्र',
          'monday_To_sunday': 'सोमवार से रविवार',
          'maximum_Payout_Limit_Is_₹500': 'अधिकतम भुगतान सीमा है ₹500',
          "bike": "बाइक",
          "auto": "ऑटो",
          //BikeInfo
          'base_Fare': 'बुनियादी भाड़ा',
          'minimum_Fare': 'न्यूनतम किराया',
          'earning_Per_km': 'आय प्रति किमी',
          'price_Per_Minute': 'मूल्य प्रति मिनट',
          'platform_Charge': 'प्लेटफॉर्म चार्ज',
          'outstation_rides': 'आउटस्टैटिन सवारी',
          'pickup_extra_km_Fare_Post_2km':
              'पिकअप अतिरिक्त किमी किराया 2 किमी के बाद',
          '(Max_10)': '(मैक्स 10)',
          'every_Km_Till_8km': 'हर किमी 8 किमी तक',
          'Per_Km ': 'प्रति किमी ',
          'every_Km_Above_8km': '8 किमी से ऊपर हर किमी',
          //CollectPaymentView
          'collect_payment': 'भुगतान प्राप्त करें',
          'ride_iD: ': 'सवारी आईडी: ',
          "collect_amount": "राशि एकत्रित करें",
          'generate_qR_code': 'क्यूआर कोड जनरेट करें',
          'or': 'या',
          'collect_cash': 'कैश कलेक्ट करें',
          //CollectCash
          'collect_Cash_Form_The_Customer.': 'ग्राहक से नकद राशि लीजिए.',
          'collected': 'जुटाया हुआ।',
          //ChooseAppLanguageView
          'english': 'अंग्रेज़ी',
          'hindi': 'हिंदी',
          'kannada': 'कन्नडा',
          'telugu': 'तेलुगू',
          'tamil': 'तामिल',
          'gujarati': 'गुजराती',
          'app_language': 'ऐप भाषा',
          'set_language': 'भाषा सेट करें',
          //AddDetailsView
          'add_details': 'विवरण जोड़ें',
          'personal_Details': 'व्यक्तिगत विवरण',
          'vehicle_Details': 'वाहन की सूचना',
          'documents': 'दस्तावेज़',
          'bank_Details': 'बैंक विवरण',
          'i_Agree_to_The ': 'मैं इसके लिए सहमत हूँ ',
          'terms_&_conditions': 'नियम एवं शर्तें',
          'next': 'Next',
          //VehicleRegistration
          'vehicle_registration_card_(RC)': 'वाहन पंजीकरण कार्ड (आरसी)',
          'upload_your_vehicle_registration_card_(RC)':
              'अपना वाहन पंजीकरण कार्ड (आरसी) अपलोड करें',
          'front_side': 'सामने की ओर',
          "camera": "कैमरा",
          "gallery": "गेलरी",
          'back_side': 'पीछे की ओर',
          'rC_number': 'आरसी नंबर',
          'rC_Number_Cant_Be_Empty': 'आरसी नंबर खाली नहीं हो सकता',
          'rC_Number_Must_be_Minimum_10_Characters':
              'आरसी नंबर कम से कम 10 कैरेक्टर का होना चाहिए',
          'enter_rC_number': 'आरसी नंबर दर्ज करें',
          'save': 'बचाना',
//TakeYourSelfie
          'add_your_selfie': 'अपनी सेल्फी जोड़ेंe',
          'take_your_selfie': 'अपनी सेल्फी लो',
          'we_Use_Your_Selfie_To_Compare_With_Your_id':
              'हम आपकी आईडी के साथ तुलना करने के लिए आपकी सेल्फी का उपयोग करते हैं',
          'good_Lighting': 'अच्छी रोशनी',
          'make_Sure_You_Are_In_A_Well_Lit_Area_And_Both_Ears_Are_Uncovered ':
              'सुनिश्चित करें कि आप एक अच्छी तरह से रोशनी वाले क्षेत्र में हैं और दोनों कान खुले हुए हैं ',
          'look_Straight': 'सीधे देखना',
          'hold_Your_Phone_At_Eye_Level_And_Looks_Straight_To_The_Camera':
              'अपने फ़ोन को आंखों के स्तर पर पकड़ें और सीधे कैमरे की ओर देखें',
          'open_camera': 'कैमरा खोलो',
          'male': 'पुरुष',
          'female': 'महिला',
          'Others': 'अन्य',
          'month/date/year': 'माह/तारीख/वर्ष',
          'enter_Valid_Date': 'मान्य तिथि दर्ज करें',
          'enter_Date_In_Valid_Range': 'दिनांक मान्य श्रेणी में दर्ज करें',
          'personal_details': 'व्यक्तिगत विवरण',
          'first_name': 'पहला नाम',
          'firstName_Cant_Be_Empty': 'पहला नाम खाली नहीं हो सकता',
          'firstName_Must_Be_Minimum_1_Digits':
              'पहला नाम कम से कम 1 अंक का होना चाहिए',
          'full_name': 'पूरा नाम',
          'last_name': 'उपनाम',
          'lastName_Cant_Be_Empty': 'अंतिम नाम खाली नहीं हो सकता',
          'lastName_Must_Be_Minimum_1_Digits':
              'लास्टनाम कम से कम 1 अंक का होना चाहिए',
          'enter_mail_id': 'मेल आईडी दर्ज करें',
          'e-mail_Address': 'मेल पता',
          "invalid_email": "अमान्य ईमेल",
          'enter_date_Of_birth': 'जन्म तारीख दर्ज करें',
          'date_Of_Birth': 'जन्म की तारीख',
          'home_address': 'घर का पता',
          'home_addres_Cant_Be_Empty': 'घर का पता खाली नहीं हो सकता',
          'home_addres_Must_Be_Minimum_1_Digits':
              'घर का पता न्यूनतम 1 अंक का होना चाहिए',
          'enter_home_address': 'घर का पता दर्ज करें',
          'city': 'शहर',
          'city_Cant_Be_Empty': 'शहर खाली नहीं हो सकता',
          'city_Must_Be_Minimum_1_Digits': 'शहर न्यूनतम 1 अंक का होना चाहिए',
          'enter_City': 'शहर का नाम दर्ज करें',
          'state ': 'राज्य ',
          'state_Cant_Be_Empty': 'राज्य का नाम खाली नहीं हो सकता',
          'state_Must_Be_Minimum_1_Digits':
              'राज्य कम से कम 1 अंक का होना चाहिए',
          'enter_State': 'राज्य का नाम  दर्ज करें',
          'pincode': 'पिन कोड',
          'pincode_Cant_Be_Empty': 'पिनकोड खाली नहीं हो सकता',
          'pincode_Must_Be_Minimum_6_Digits':
              'पिनकोड कम से कम 6 अंकों का होना चाहिए',
          'enter_Pincode': 'पिनकोड दर्ज करें',
          //PanCard
          'pAN_card': 'पैन कार्ड',
          'upload_your_pAN_card': 'अपना पैन कार्ड अपलोड करें',
          'pAN_number': 'PAN Number',
          'pAN_Number_Can_Not_Be_Empty.': 'पैन नंबर खाली नहीं हो सकता.',
          'enter_pAN_number': 'पैन नंबर दर्ज करें',
          //VechileSelection
          'job_details': 'नौकरी विवरण',
          'which_Vehicle_Will_You_Use?': 'आप कौन सा वाहन प्रयोग करेंगे?',
          'vehicle_type': 'वाहन का प्रकार',
          'electric': 'विद्युत',
          'non-electric': 'गैर विद्युत',
          //DrivingLicense
          'driving_license': 'ड्राइविंग लाइसेंस',
          'upload_your_driving_license': 'अपना ड्राइविंग लाइसेंस अपलोड करें',
          'learner’s_License_Not_Allowed.': 'लर्नर लाइसेंस की अनुमति नहीं है.',
          'driving_license_number': 'ड्राइविंग लाइसेंस संख्या',
          'driving_License_Cant_Be_Empty':
              'ड्राइविंग लाइसेंस खाली नहीं हो सकता',
          'driving_License_Must_Be_Minimum_16_Characters':
              'ड्राइविंग लाइसेंस न्यूनतम 16 वर्णों का होना चाहिए',
          'expiry_date': 'समाप्ति तिथि',
//Documents
          'upload_All_documents,_required_For_Your_Verification.':
              'आपके सत्यापन के लिए आवश्यक सभी दस्तावेज़ अपलोड करें.',
          'aadhar_card': 'आधार कार्ड',
          //Demo
          'membership_For_45_Days': '45 दिनों के लिए सदस्यता',
          'free': 'मुफ़्त',
          '10_Days_Left': '10 दिन शेष',
//BankDetails
          'enter_A_Valid_iFSC_Number.': 'एक मान्य IFSC नंबर दर्ज करें.',
          'add_your_bank_details': 'अपना बैंक विवरण जोड़ें',
          'account_holder_name': 'खाता धारक का नाम',
          'enter_bankholder_name_Cant_Be_Empty':
              'बैंकधारक का नाम दर्ज करें खाली नहीं हो सकता',
          'enter_bankholder_name_Must_Be_Minimum_3_Characters':
              'बैंकधारक का नाम दर्ज करें कम से कम 3 अक्षर होने चाहिए',
          'enter_Bank_Holder_Name': 'बैंक धारक का नाम दर्ज करें',
          'account_Number': 'Account number',
          'account_Number_Cant_Be_Empty': 'खाता संख्या खाली नहीं हो सकती',
          'account_Number_Must_Be_9_To_17_Digits':
              'खाता संख्या 9 से 17 अंकों की होनी चाहिए',
          'iFSC_Code': 'IFSC कोड',
          'ifsc_Code_Can_Not_Be_Empty.': 'IFSC कोड खाली नहीं हो सकता.',
          'enter_Valid_Ifsc_Code': 'वैध आईएफएससी कोड दर्ज करें',
          'enter_Ifsc_Code': 'IFSC कोड दर्ज करें',
          'bank_name': 'बैंक का नाम',
          'bank_Name_Can_Not_Be_Empty.': 'बैंक का नाम खाली नहीं हो सकता.',
          'enter_bank_Name': 'बैंक का नाम दर्ज करें',
          'add_your_uPI': 'आपका जोड़ें UPI',
          'uPI': 'UPI',
          'uPI_Id_Can_Not_Be_Empty.': 'UPI ID खाली नहीं हो सकती.',
//AdharCard
          'upload_Your_Aadhar_Card': 'अपना आधार कार्ड अपलोड करें',
          'aadhar_Number': 'आधार संख्या',
          'aadhar_number_Cant_Be_Empty': 'आधार संख्या खाली नहीं हो सकती',
          'aadhar_number_Must_Be_12_Digits':
              'आधार संख्या 12 अंकों की होनी चाहिए',
//LoginPageView
          "login ": "लॉग इन करें ",
          "mobile_number ": "मोबाइल नंबर ",
          "mobile_Number_Can't_Be_Empty": "मोबाइल नंबर खाली नहीं हो सकता",
          "mobile_Number_Must_Be_10_Digits":
              "मोबाइल नंबर 10 अंकों का होना चाहिए",
          'enter_Mobile_Number': 'मोबाइल नंबर दर्ज करें',
          'login': 'लॉग इन करें',
//NotificationView
          'notifications': 'सूचनाएं',
          "clear": "साफ़ करे",
          "start_your_first_ride_with_winter_Offers.":
              "विंटर ऑफ़र के साथ अपनी पहली राइड शुरू करें.",
          "happy_winter_offer_On_Your_first_ride,_enjoy_ride_With_best_offers._check_It_Now":
              "आपकी पहली राइड पर हैप्पी विंटर ऑफर, बेस्ट ऑफर्स के साथ राइड का मजा लें। अब यह जांच करें",
          "2_Days_Ago": "2 दिन पहले",
//OrderCompletedView
          'ride_completed': 'सवारी पूरी हुई',
          'great_job!': 'अच्छा काम!',
          'ride_successfully_completed': 'सवारी सफलतापूर्वक पूरी हुई',
          'total_Distance : ': 'कुल दूरी : ',
          'total_Ride_Time : ': 'कुल सवारी का समय : ',
          'amount : ': 'राशि : ',
          'ready_for_next_order': 'अगले आदेश के लिए तैयार',
          //ProfileReview
          ' rejected': ' अस्वीकार कर दिया',
          'please_Contact_Admin_Support':
              'कृपया व्यवस्थापक समर्थन से संपर्क करें',
          "  your_Profile_Is_Under_Reviewing\nprocess._Please_Wait_2_To_4_Days":
              "  आपकी प्रोफ़ाइल समीक्षाधीन है\nप्रक्रियाधीन है। कृपया 2 से 4 दिन प्रतीक्षा करें",
//ReferAndEarnView
          "refer_&_earn": "उद्घृत करो और कमाएँ",
          "refer_friends": "मित्र को उद्घृत करे",
          "earn_Upto_₹100_Per_Friend_You_Invite":
              "आप जिस दोस्त को बुलाते हैं उससे ₹100 तक कमाएं",
          "my_rewards": "मेरे पुरस्कार",
          "share_Your_Invite_Code": "अपना आमंत्रण कोड साझा करें",
          "when_Your_Friends_Sign_Up_This_Referral":
              "जब आपके मित्र इस रेफरल को साइन अप करते हैं",
          "Code,_You_Can_Received_A_Free_Ride":
              "कोड, आप एक मुफ्त सवारी प्राप्त कर सकते हैं",
          'refer': 'उद्घृत करो',
//ReferalCodeView
          'hello,_skipper': 'हैलो, स्किपर',
          'your_Account_Will_Be_Registered_With_This_Mobile_Number':
              'आपका खाता इस मोबाइल नंबर के साथ पंजीकृत हो जाएगा',
          "have_a_referral_code?": "रेफरल कोड है?",
          'enter_referral_code': 'रेफरल कोड दर्ज करें',
          'referal_Code_Must_Be_5_Digits': 'रेफ़रल कोड 5 अंकों का होना चाहिए',
//ReviewsView
          'rating_&_reviews': 'रेटिंग और समीक्षा',
          "rating": "रेटिंग",

//RideHistoryView
          'ride_history': 'सवारी इतिहास',
          'today': 'आज',
          "all": "सभी",
          "completed": "पूरा हुआ",
          "rejected": "अस्वीकार कर दिया",

          //RideHistoryCard
          'online_paid ': 'ऑनलाइन भुगतान किया',
          'yesterday': 'बीता हुआ कल',
          'week': 'सप्ताह',
          'custom': 'रीति',

          'Personal_Details': 'व्यक्तिगत विवरण',
          //homepage drawer
          'earnings': 'आय',
          'order_history': 'आदेश इतिहास',
          'rating_reviews': 'रेटिंग और समीक्षा',
          'notifications': 'सूचनाएं',
          'refer_earn': 'उद्घृत करो और कमाएँ',
          //homepage earningcard
          'enable_location_to_get_nearby_rides':
              'आस-पास की सवारी प्राप्त करने के लिए स्थान सक्षम करें',
          'enable_location': 'स्थान सक्षम करें',
          'todays_earnings': 'आज की कमाई',
          'cash_collected': 'नकद एकत्रित',
          //homepage flutterripplewidget
          'go_online': 'ऑनलाइन जाओ',
          //homepage currentlyofflinecard
          'offine_message':
              'आप वर्तमान में ऑफ़लाइन हैं, कृपया\nकमाई शुरू करने के लिए ऑनलाइन जाएं',
          //homepage RoutingBooking
          'my_route_booking': 'माई रूट बुकिंग',
          //riplepage widget
          'offline': 'ऑफलाइन',
          'online': 'ऑनलाइन',
          //riplepage widget AccetedOrderCard
          'pickup': 'उठाना',
          'min_away': 'मिनट दूर',
          'reject': 'अस्वीकार',
          "accept_ride": 'सवारी स्वीकार करें',
          'arrived': 'पहुँचा',
          'complete_ride': 'पूरी सवारी',
          'ride_id:': 'सवारी आईडी:',
          'enter_otp': 'ओटीपी दर्ज करें',
          'please_ask_otp_to_the_Customer': 'कृपया ग्राहक से ओटीपी पूछें',
          'otp_length_didn\'t_match': 'ओटीपी की लंबाई मेल नहीं खाती',
          'start_ride': 'राइड शुरू करें',
          'Go_to_drop_Location': 'ड्रॉप लोकेशन पर जाएं',
          'go_to_pick_up': 'लेने जाओ',
          //earningpage
          'today’s_earning': 'आज की कमाई',
          'payout': 'भुगतान',
          'history': 'इतिहास',
          //today earning
          'rides': 'सवारी',
          'Km': 'किमी',
          'hours': 'घंटे',
          'avg_rating': 'औसत रेटिंग',
          'reject_rides': 'सवारी अस्वीकार करें',
          'today\'s_earning': 'आज की कमाई',
          "order_id :": 'आदेश ID :',
          //payout
          'online_collection': 'ऑनलाइन संग्रह',
          'amount_to_Pay': 'भुगतान की जाने वाली राशि',
          'total_collected_cash': 'कुल एकत्रित नकद',
          'tax_charges': 'कर प्रभार',
          'gst_payable_to_the_government.': 'सरकार को देय जी.एस.टी.',
          'platform_charge': 'प्लेटफॉर्म चार्ज',
          'outstation_rides': 'आउटस्टैटिन सवारी',
          'Daily_one_time_fee.': 'दैनिक एक बार शुल्क.',
          'transaction_fees': 'लेनदेन शुल्क',
          'Towards_unavoidable_costs_for\noperating_the_app':
              'ऐप को संचालित करने के लिए अपरिहार्य लागतों की ओर',
          'payable_amount': 'भुगतान योग्य राशि',
          'maximum_payout_limit_is ': 'अधिकतम भुगतान सीमा है ',
          'please_pay_below-charges': 'कृपया नीचे शुल्क का भुगतान करें',
          'Immediately': 'तुरंत',
          'total_earnings': 'कुल आय',
          'rides)': 'सवारी)',
          //ride earning details
          'ride_details': 'सवारी विवरण',
          'time_fare ': 'समय किराया ',
          'distance_fare ': 'दूरी किराया ',
          'surge': 'तरंग',
          'your_earnings': 'आपकी कमाई',
          // ride details
          'ride_id': 'सवारी आईडी',
          'date': 'तारीख',
          'distance': 'दूरी',
          'Mins': 'मिनट',
          'duration': 'अवधि',
          'pickup_location': 'उठाने की जगह',
          'drop_location': 'ड्रॉप स्थान',
          //ride details-total rechargrcard
          'ride_amount': 'सवारी राशि',
          'amount_pay_to_company': 'कंपनी को राशि का भुगतान',
          //profile
          'profile': 'प्रोफ़ाइल',

          'vehicle': 'वाहन',
          'bank_details': 'बैंक विवरण',
          //profile- personaldetails
          'FirstName_cant_be_empty': 'पहला नाम खाली नहीं हो सकता',
          'FirstName_must_be_minimum_1_digits':
              'पहला नाम कम से कम 1 अंक का होना चाहिए',
          'mobile_number': 'मोबाइल नंबर',
          'mobile_number_cant_be_empty': 'मोबाइल नंबर खाली नहीं हो सकता',
          'mobile_number_must_be_minimum_10_digits':
              'मोबाइल नंबर कम से कम 10 अंकों का होना चाहिए',
          'email': 'ईमेल',
          'gender': 'लिंग',
          'others': 'अन्य',
          //profile-liceience
          'upload_rc_back_side': 'आरसी बैक साइड अपलोड करें',
          'please_enter_license_number': 'कृपया लाइसेंस संख्या दर्ज करें',
          'please_enter_valid_driving_license':
              'कृपया वैध ड्राइविंग लाइसेंस दर्ज करें',
          'update': 'अद्यतन',

          'please_enter_rc_number': 'कृपया आरसी संख्या दर्ज करें',
          'please_enter_valid_rc_number': 'कृपया मान्य आरसी संख्या दर्ज करें',
          //profile-aadharcard

          //profile-pancard
          'please_enter_pancard_number': 'कृपया पैनकार्ड संख्या दर्ज करें',
          'please_enter_valid_pancard_number':
              'कृपया मान्य पैनकार्ड संख्या दर्ज करें',

          //profile-bandetails
          'ifsc': 'आईएफ़एससी',
          'please_enter_ifsc_number': 'कृपया IFSC नंबर दर्ज करें',
          'please_enter_valid_ifsc_number': 'कृपया मान्य IFSC नंबर दर्ज करें',
          'please_enter_upi_number': 'कृपया यूपीआई नंबर दर्ज करें',
          'Please_enter_valid_upi_number': 'कृपया मान्य यूपीआई नंबर दर्ज करें',
        },
        'kn_in': {
          //support
          "support": "ಬೆಂಬಲ",
          "easy_go": "ಸುಲಭವಾಗಿ ಹೋಗು",
          "customer_support": "ಗ್ರಾಹಕ ಬೆಂಬಲ",
          "chat": "ಚಾಟ್ ಮಾಡಿ",
          //ride info
          "ride_info": "ಸವಾರಿ ಮಾಹಿತಿ",
          'ride_id: ': 'ರೈಡ್ ಐಡಿ: ',
          //rideDetails
          'cancel_ride': 'ರೈಡ್ ರದ್ದುಮಾಡಿ',
          //payNow
          'please_Pay_The_Amount\nBefore_Contuning':
              'ಮುಂದುವರಿಸುವ ಮೊದಲು ದಯವಿಟ್ಟು ಮೊತ್ತವನ್ನು ಪಾವತಿಸಿ',
          'payout_details': 'ಪಾವತಿ ವಿವರಗಳು',
          'pay_now': 'ಈಗ ಪಾವತಿಸಿ',
          'skip': 'ಬಿಟ್ಟುಬಿಡಿ',
          'payment_under_process': 'ಪ್ರಕ್ರಿಯೆಯ ಅಡಿಯಲ್ಲಿ ಪಾವತಿ',
          'please_Don’t_Go_Back_Or_Refresh_The_Page\nas_We_Are_Processing_Your_Payment':
              'ನಿಮ್ಮ ಪಾವತಿಯನ್ನು ನಾವು ಪ್ರಕ್ರಿಯೆಗೊಳಿಸುತ್ತಿರುವ ಕಾರಣ ದಯವಿಟ್ಟು ಹಿಂತಿರುಗಬೇಡಿ ಅಥವಾ ಪುಟವನ್ನು ರಿಫ್ರೆಶ್ ಮಾಡಬೇಡಿ',
          //customerSupport
          'please_Select_Reason_For_Cancel_ride':
              'ದಯವಿಟ್ಟು ರೈಡ್ ರದ್ದುಗೊಳಿಸಲು ಕಾರಣವನ್ನು ಆಯ್ಕೆಮಾಡಿ',
          'unsafe_Pickup_area': 'ಅಸುರಕ್ಷಿತ ಪಿಕಪ್ ಪ್ರದೇಶ',
          'unable_To_Swipe_Arrived': 'ಸ್ವೈಪ್ ಮಾಡಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ ಬಂದಿತು',
          'wrong_Pickup_Location': 'ತಪ್ಪಾದ ಪಿಕಪ್ ಸ್ಥಳ',
          'long_Pickup': 'ದೀರ್ಘ ಪಿಕಪ್',
          'heavy_Traffic': 'ಭಾರೀ ಟ್ರಾಫಿಕ್',
          //BackCollectedButton
          'back': 'ಹಿಂದೆ',
          //RateCard
          'rate_card': 'ದರದ ಚೀಟಿ',
          'monday_To_sunday': 'ಸೋಮವಾರದಿಂದ ಭಾನುವಾರದವರೆಗೆ',
          'maximum_Payout_Limit_Is_₹500': 'ಗರಿಷ್ಠ ಪಾವತಿ ಮಿತಿ ₹500',
          "bike": "ಬೈಕ್",
          "auto": "ಆಟೋ",
          //BikeInfo
          'base_Fare': 'ಮೂಲ ದರ',
          'minimum_Fare': 'ಕನಿಷ್ಠ ದರ',
          'earning_Per_km': 'ಪ್ರತಿ ಕಿ.ಮೀ.ಗೆ ಗಳಿಕೆ',
          'price_Per_Minute': 'ಪ್ರತಿ ನಿಮಿಷಕ್ಕೆ ಬೆಲೆ',
          'platform_Charge': 'ಪ್ಲಾಟ್‌ಫಾರ್ಮ್ ಶುಲ್ಕ',
          'outstation_rides': 'ಔಟ್ಸ್ಟಾಟಿನ್ ರೈಡ್ಸ್',

          'pickup_extra_km_Fare_Post_2km':
              'ಪಿಕಪ್ ಹೆಚ್ಚುವರಿ ಕಿಮೀ ದರದ ನಂತರ 2 ಕಿಮೀ',
          '(Max_10)': '(ಗರಿಷ್ಠ 10)',
          'every_Km_Till_8km': '8 ಕಿಮೀ ವರೆಗೆ ಪ್ರತಿ ಕಿ.ಮೀ',
          'Per_Km ': 'ಪ್ರತಿ ಕಿ.ಮೀ ',
          'every_Km_Above_8km': '8 ಕಿಮೀ ಮೇಲಿನ ಪ್ರತಿ ಕಿ.ಮೀ',
          //CollectPaymentView
          'collect_payment': 'ಪಾವತಿಯನ್ನು ಸಂಗ್ರಹಿಸಿ',
          'ride_iD: ': 'ರೈಡ್ ಐಡಿ: ',
          "collect_amount": "ಮೊತ್ತವನ್ನು ಸಂಗ್ರಹಿಸಿ",
          'generate_qR_code': 'QR ಕೋಡ್ ಅನ್ನು ರಚಿಸಿ',
          'or': 'ಅಥವಾ',
          'collect_cash': 'ನಗದು ಸಂಗ್ರಹಿಸಿ',
          //CollectCash
          'collect_Cash_Form_The_Customer.': 'ಗ್ರಾಹಕರಿಂದ ಹಣವನ್ನು ಸಂಗ್ರಹಿಸಿ.',
          'collected': 'ಸಂಗ್ರಹಿಸಲಾಗಿದೆ',
          //ChooseAppLanguageView
          'english': 'ಆಂಗ್ಲ',
          'hindi': 'ಹಿಂದಿ',
          'kannada': 'ಕನ್ನಡ',
          'telugu': 'ತೆಲುಗು',
          'tamil': 'ತಮಿಳು',
          'gujarati': 'ಗುಜರಾತಿ',
          'app_language': 'ಅಪ್ಲಿಕೇಶನ್ ಭಾಷೆ',
          'set_language': 'ಭಾಷೆಯನ್ನು ಹೊಂದಿಸಿ',
          //AddDetailsView
          'add_details': 'ವಿವರಗಳನ್ನು ಸೇರಿಸಿ',
          'personal_Details': 'ವೈಯಕ್ತಿಕ ವಿವರಗಳು',
          'vehicle_Details': 'ವಾಹನದ ವಿವರಗಳು',
          'documents': 'ದಾಖಲೆಗಳು',
          'bank_Details': 'ಬ್ಯಾಂಕ್ ವಿವರಗಳು',
          'i_Agree_to_The ': 'ನಾನು ಒಪ್ಪುತ್ತೇನೆ ',
          'terms_&_conditions': 'ನಿಯಮ ಮತ್ತು ಶರತ್ತುಗಳು',
          'next': 'ಮುಂದೆ',
          //VehicleRegistration
          'vehicle_registration_card_(RC)': 'ವಾಹನ ನೋಂದಣಿ ಕಾರ್ಡ್ (RC)',
          'upload_your_vehicle_registration_card_(RC)':
              'ನಿಮ್ಮ ವಾಹನ ನೋಂದಣಿ ಕಾರ್ಡ್ (RC) ಅಪ್‌ಲೋಡ್ ಮಾಡಿ',
          'front_side': 'ಮುಂಭಾಗದ ಭಾಗ',
          "camera": "ಕ್ಯಾಮೆರಾ",
          "gallery": "ಗ್ಯಾಲರಿ",
          'back_side': 'ಬ್ಯಾಕ್ ಸೈಡ್',
          'rC_number': 'RC ಸಂಖ್ಯೆ',
          'rC_Number_Cant_Be_Empty': 'ಆರ್‌ಸಿ ಸಂಖ್ಯೆ ಖಾಲಿ ಇರುವಂತಿಲ್ಲ',
          'rC_Number_Must_be_Minimum_10_Characters':
              'RC ಸಂಖ್ಯೆಯು ಕನಿಷ್ಠ 10 ಅಕ್ಷರಗಳಾಗಿರಬೇಕು',
          'enter_rC_number': 'RC ಸಂಖ್ಯೆಯನ್ನು ನಮೂದಿಸಿ',
          'save': 'ಉಳಿಸಿ',
//TakeYourSelfie
          'add_your_selfie': 'ನಿಮ್ಮ ಸೆಲ್ಫಿ ಸೇರಿಸಿ',
          'take_your_selfie': 'ನಿಮ್ಮ ಸೆಲ್ಫಿ ತೆಗೆದುಕೊಳ್ಳಿ',
          'we_Use_Your_Selfie_To_Compare_With_Your_id':
              'ನಿಮ್ಮ ಐಡಿಯೊಂದಿಗೆ ಹೋಲಿಸಲು ನಾವು ನಿಮ್ಮ ಸೆಲ್ಫಿಯನ್ನು ಬಳಸುತ್ತೇವೆ',
          'good_Lighting': 'ಉತ್ತಮ ಬೆಳಕು',
          'make_Sure_You_Are_In_A_Well_Lit_Area_And_Both_Ears_Are_Uncovered ':
              'ನೀವು ಚೆನ್ನಾಗಿ ಬೆಳಗಿದ ಪ್ರದೇಶದಲ್ಲಿದ್ದೀರೆಂದು ಖಚಿತಪಡಿಸಿಕೊಳ್ಳಿ ಮತ್ತು ಎರಡೂ ಕಿವಿಗಳು ತೆರೆದಿರುತ್ತವೆ ',
          'look_Straight': 'ನೇರವಾಗಿ ನೋಡಿ',
          'hold_Your_Phone_At_Eye_Level_And_Looks_Straight_To_The_Camera':
              'ನಿಮ್ಮ ಫೋನ್ ಅನ್ನು ಕಣ್ಣಿನ ಮಟ್ಟದಲ್ಲಿ ಹಿಡಿದುಕೊಳ್ಳಿ ಮತ್ತು ನೇರವಾಗಿ ಕ್ಯಾಮೆರಾದತ್ತ ನೋಡಿ',
          'open_camera': 'ಕ್ಯಾಮರಾ ತೆರೆಯಿರಿ',
          'male': 'ಪುರುಷ',
          'female': 'ಹೆಣ್ಣು',
          'Others': 'ಇತರರು',
          'month/date/year': 'ತಿಂಗಳು/ದಿನಾಂಕ/ವರ್ಷ',
          'enter_Valid_Date': 'ಮಾನ್ಯವಾದ ದಿನಾಂಕವನ್ನು ನಮೂದಿಸಿ',
          'enter_Date_In_Valid_Range': 'ಮಾನ್ಯ ವ್ಯಾಪ್ತಿಯಲ್ಲಿ ದಿನಾಂಕ ನಮೂದಿಸಿ',
          'personal_details': 'ವೈಯಕ್ತಿಕ ವಿವರಗಳು',
          'first_name': 'ಮೊದಲ ಹೆಸರು',
          'firstName_Cant_Be_Empty': 'ಮೊದಲ ಹೆಸರು ಖಾಲಿ ಇರುವಂತಿಲ್ಲ',
          'firstName_Must_Be_Minimum_1_Digits':
              'ಮೊದಲ ಹೆಸರು ಕನಿಷ್ಠ 1 ಅಂಕೆಗಳಾಗಿರಬೇಕು',
          'full_name': 'ಪೂರ್ಣ ಹೆಸರು',
          'last_name': 'ಕೊನೆಯ ಹೆಸರು',
          'lastName_Cant_Be_Empty': 'ಕೊನೆಯ ಹೆಸರು ಖಾಲಿ ಇರುವಂತಿಲ್ಲ',
          'lastName_Must_Be_Minimum_1_Digits':
              'ಕೊನೆಯ ಹೆಸರು ಕನಿಷ್ಠ 1 ಅಂಕೆಗಳಾಗಿರಬೇಕು',
          'enter_mail_id': 'ಮೇಲ್ ಐಡಿ ನಮೂದಿಸಿ',
          'e-mail_Address': 'ಇಮೇಲ್ ವಿಳಾಸ',
          "invalid_email": "ಅಮಾನ್ಯ ಇಮೇಲ್",
          'enter_date_Of_birth': 'ಹುಟ್ಟಿದ ದಿನಾಂಕವನ್ನು ನಮೂದಿಸಿ',
          'date_Of_Birth': 'ಹುಟ್ತಿದ ದಿನ',
          'home_address': 'ಮನೆ ವಿಳಾಸ',
          'home_addres_Cant_Be_Empty': 'ಮನೆ ವಿಳಾಸಗಳು ಖಾಲಿ ಇರುವಂತಿಲ್ಲ',
          'home_addres_Must_Be_Minimum_1_Digits':
              'ಮನೆಯ ವಿಳಾಸಗಳು ಕನಿಷ್ಠ 1 ಅಂಕೆಗಳಾಗಿರಬೇಕು',
          'enter_home_address': 'ಮನೆಯ ವಿಳಾಸವನ್ನು ನಮೂದಿಸಿ',
          'city': 'ನಗರ',
          'city_Cant_Be_Empty': 'ನಗರ ಖಾಲಿ ಇರುವಂತಿಲ್ಲ',
          'city_Must_Be_Minimum_1_Digits': 'ನಗರವು ಕನಿಷ್ಠ 1 ಅಂಕೆಗಳಾಗಿರಬೇಕು',
          'enter_City': 'ನಗರವನ್ನು ನಮೂದಿಸಿ',
          'state ': 'ರಾಜ್ಯ ',
          'state_Cant_Be_Empty': 'ರಾಜ್ಯ ಖಾಲಿ ಇರುವಂತಿಲ್ಲ',
          'state_Must_Be_Minimum_1_Digits': 'ರಾಜ್ಯವು ಕನಿಷ್ಠ 1 ಅಂಕೆಗಳಾಗಿರಬೇಕು',
          'enter_State': 'ರಾಜ್ಯವನ್ನು ನಮೂದಿಸಿ',
          'pincode': 'ಪಿನ್‌ಕೋಡ್',
          'pincode_Cant_Be_Empty': 'ಪಿನ್‌ಕೋಡ್ ಖಾಲಿ ಇರುವಂತಿಲ್ಲ',
          'pincode_Must_Be_Minimum_6_Digits':
              'ಪಿನ್‌ಕೋಡ್ ಕನಿಷ್ಠ 6 ಅಂಕಿಗಳಾಗಿರಬೇಕು',
          'enter_Pincode': 'ಪಿನ್‌ಕೋಡ್ ನಮೂದಿಸಿ',
          //PanCard
          'pAN_card': 'ಪ್ಯಾನ್ ಕಾರ್ಡ್',
          'upload_your_pAN_card': 'ನಿಮ್ಮ ಪ್ಯಾನ್ ಕಾರ್ಡ್ ಅನ್ನು ಅಪ್ಲೋಡ್ ಮಾಡಿ',
          'pAN_number': 'ಪ್ಯಾನ್ ಸಂಖ್ಯೆ',
          'pAN_Number_Can_Not_Be_Empty.': 'ಪ್ಯಾನ್ ಸಂಖ್ಯೆ ಖಾಲಿ ಇರುವಂತಿಲ್ಲ.',
          'enter_pAN_number': 'PAN ಸಂಖ್ಯೆಯನ್ನು ನಮೂದಿಸಿ',
          //VechileSelection
          'job_details': 'ಉದ್ಯೋಗದ ವಿವರಗಳು',
          'which_Vehicle_Will_You_Use?': 'ನೀವು ಯಾವ ವಾಹನವನ್ನು ಬಳಸುತ್ತೀರಿ?',
          'vehicle_type': 'ವಾಹನದ ಪ್ರಕಾರ',
          'electric': 'ಎಲೆಕ್ಟ್ರಿಕ್',
          'non-electric': 'ವಿದ್ಯುತ್ ಅಲ್ಲದ',
          //DrivingLicense
          'driving_license': 'ಚಾಲನಾ ಪರವಾನಿಗೆ',
          'upload_your_driving_license':
              'ನಿಮ್ಮ ಚಾಲನಾ ಪರವಾನಗಿಯನ್ನು ಅಪ್‌ಲೋಡ್ ಮಾಡಿ',
          'learner’s_License_Not_Allowed.':
              'ಕಲಿಕಾ ಪರವಾನಗಿಯನ್ನು ಅನುಮತಿಸಲಾಗುವುದಿಲ್ಲ.',
          'driving_license_number': 'ಚಾಲನಾ ಪರವಾನಗಿ ಸಂಖ್ಯೆ',
          'driving_License_Cant_Be_Empty': 'ಚಾಲನಾ ಪರವಾನಗಿ ಖಾಲಿ ಇರುವಂತಿಲ್ಲ',
          'driving_License_Must_Be_Minimum_16_Characters':
              'ಚಾಲನಾ ಪರವಾನಗಿ ಕನಿಷ್ಠ 16 ಅಕ್ಷರಗಳಾಗಿರಬೇಕು',
          'expiry_date': 'ಗಡುವು ದಿನಾಂಕ',
//Documents
          'upload_All_documents,_required_For_Your_Verification.':
              'ನಿಮ್ಮ ಪರಿಶೀಲನೆಗೆ ಅಗತ್ಯವಿರುವ ಎಲ್ಲಾ ಡಾಕ್ಯುಮೆಂಟ್‌ಗಳನ್ನು ಅಪ್‌ಲೋಡ್ ಮಾಡಿ.',
          'aadhar_card': 'ಆಧಾರ್ ಕಾರ್ಡ್',
          //Demo
          'membership_For_45_Days': '45 ದಿನಗಳವರೆಗೆ ಸದಸ್ಯತ್ವ',
          'free': 'ಉಚಿತ',
          '10_Days_Left': '10 ದಿನಗಳು ಉಳಿದಿವೆ',
//BankDetails
          'enter_A_Valid_iFSC_Number.': 'Enter a valid IFSC number.',
          'add_your_bank_details': 'ನಿಮ್ಮ ಬ್ಯಾಂಕ್ ವಿವರಗಳನ್ನು ಸೇರಿಸಿ',
          'account_holder_name': 'ಖಾತೆದಾರನ ಹೆಸರು',
          'enter_bankholder_name_Cant_Be_Empty':
              'ಬ್ಯಾಂಕ್ ಹೋಲ್ಡರ್ ಹೆಸರನ್ನು ನಮೂದಿಸಿ ಖಾಲಿ ಇರುವಂತಿಲ್ಲ',
          'enter_bankholder_name_Must_Be_Minimum_3_Characters':
              'ಬ್ಯಾಂಕ್ ಹೋಲ್ಡರ್ ಹೆಸರನ್ನು ನಮೂದಿಸಿ ಕನಿಷ್ಠ 3 ಅಕ್ಷರಗಳಿರಬೇಕು',
          'enter_Bank_Holder_Name': 'ಬ್ಯಾಂಕ್ ಹೋಲ್ಡರ್ ಹೆಸರನ್ನು ನಮೂದಿಸಿ',
          'account_Number': 'ಖಾತೆ ಸಂಖ್ಯೆ',
          'account_Number_Cant_Be_Empty': 'ಖಾತೆ ಸಂಖ್ಯೆ ಖಾಲಿ ಇರುವಂತಿಲ್ಲ',
          'account_Number_Must_Be_9_To_17_Digits':
              'ಖಾತೆ ಸಂಖ್ಯೆ 9 ರಿಂದ 17 ಅಂಕಿಗಳಾಗಿರಬೇಕು',
          'iFSC_Code': 'IFSC ಕೋಡ್',
          'ifsc_Code_Can_Not_Be_Empty.': 'Ifsc ಕೋಡ್ ಖಾಲಿ ಇರುವಂತಿಲ್ಲ.',
          'enter_Valid_Ifsc_Code': 'ಮಾನ್ಯವಾದ ifsc ಕೋಡ್ ಅನ್ನು ನಮೂದಿಸಿ',
          'enter_Ifsc_Code': 'ifsc ಕೋಡ್ ನಮೂದಿಸಿ',
          'bank_name': 'ಬ್ಯಾಂಕ್ ಹೆಸರು',
          'bank_Name_Can_Not_Be_Empty.': 'ಬ್ಯಾಂಕ್ ಹೆಸರು ಖಾಲಿ ಇರುವಂತಿಲ್ಲ.',
          'enter_bank_Name': 'ಬ್ಯಾಂಕ್ ಹೆಸರನ್ನು ನಮೂದಿಸಿ',
          'add_your_uPI': 'ನಿಮ್ಮ UPI ಸೇರಿಸಿ',
          'uPI': 'UPI',
          'uPI_Id_Can_Not_Be_Empty.': 'UPI ಐಡಿ ಖಾಲಿ ಇರುವಂತಿಲ್ಲ.',
//AdharCard
          'upload_Your_Aadhar_Card': 'ನಿಮ್ಮ ಆಧಾರ್ ಕಾರ್ಡ್ ಅನ್ನು ಅಪ್ಲೋಡ್ ಮಾಡಿ',
          'aadhar_Number': 'ಆಧಾರ್ ಸಂಖ್ಯೆ',
          'aadhar_number_Cant_Be_Empty': 'ಆಧಾರ್ ಸಂಖ್ಯೆ ಖಾಲಿ ಇರುವಂತಿಲ್ಲ',
          'aadhar_number_Must_Be_12_Digits': 'ಆಧಾರ್ ಸಂಖ್ಯೆಯು 12 ಅಂಕೆಗಳಾಗಿರಬೇಕು',
//LoginPageView
          "login ": "ಲಾಗಿನ್ ಮಾಡಿ ",
          "mobile_number ": "ಮೊಬೈಲ್ ನಂಬರ ",
          "mobile_Number_Can't_Be_Empty": "ಮೊಬೈಲ್ ಸಂಖ್ಯೆ ಖಾಲಿ ಇರುವಂತಿಲ್ಲ",
          "mobile_Number_Must_Be_10_Digits": "ಮೊಬೈಲ್ ಸಂಖ್ಯೆ 10 ಅಂಕಿಗಳಾಗಿರಬೇಕು",
          'enter_Mobile_Number': 'ಮೊಬೈಲ್ ಸಂಖ್ಯೆಯನ್ನು ನಮೂದಿಸಿ',
          'login': 'ಲಾಗಿನ್ ಮಾಡಿ',
//NotificationView
          'notifications': 'ಅಧಿಸೂಚನೆಗಳು',
          "clear": "ಸ್ಪಷ್ಟ",
          "start_your_first_ride_with_winter_Offers.":
              "ಚಳಿಗಾಲದ ಕೊಡುಗೆಗಳೊಂದಿಗೆ ನಿಮ್ಮ ಮೊದಲ ಸವಾರಿಯನ್ನು ಪ್ರಾರಂಭಿಸಿ.",
          "happy_winter_offer_On_Your_first_ride,_enjoy_ride_With_best_offers._check_It_Now":
              "ನಿಮ್ಮ ಮೊದಲ ರೈಡ್‌ನಲ್ಲಿ ಹ್ಯಾಪಿ ವಿಂಟರ್ ಆಫರ್, ಅತ್ಯುತ್ತಮ ಆಫರ್‌ಗಳೊಂದಿಗೆ ರೈಡ್ ಅನ್ನು ಆನಂದಿಸಿ. ಈಗ ಅದನ್ನು ಪರಿಶೀಲಿಸಿ",
          "2_Days_Ago": "2 ದಿನಗಳ ಹಿಂದೆ",
//OrderCompletedView
          'ride_completed': 'ಸವಾರಿ ಪೂರ್ಣಗೊಂಡಿದೆ',
          'great_job!': 'ಉತ್ತಮ ಕೆಲಸ!',
          'ride_successfully_completed': 'ಸವಾರಿ ಯಶಸ್ವಿಯಾಗಿ ಪೂರ್ಣಗೊಂಡಿದೆ',
          'total_Distance : ': 'ಒಟ್ಟು ದೂರ : ',
          'total_Ride_Time : ': 'ಒಟ್ಟು ಸವಾರಿ ಸಮಯ : ',
          'amount : ': 'ಮೊತ್ತ : ',
          'ready_for_next_order': 'ಮುಂದಿನ ಆದೇಶಕ್ಕೆ ಸಿದ್ಧವಾಗಿದೆ',
          //ProfileReview
          ' rejected': ' ತಿರಸ್ಕರಿಸಿದ',
          'please_Contact_Admin_Support':
              'ದಯವಿಟ್ಟು ನಿರ್ವಾಹಕ ಬೆಂಬಲವನ್ನು ಸಂಪರ್ಕಿಸಿ',
          "  your_Profile_Is_Under_Reviewing\nprocess._Please_Wait_2_To_4_Days":
              "  ನಿಮ್ಮ ಪ್ರೊಫೈಲ್ ಪರಿಶೀಲಿಸಲಾಗುತ್ತಿದೆ\nಪ್ರಕ್ರಿಯೆಯಲ್ಲಿದೆ. ದಯವಿಟ್ಟು 2 ರಿಂದ 4 ದಿನ ಕಾಯಿರಿ",
//ReferAndEarnView
          "refer_&_earn": "ಉಲ್ಲೇಖಿಸಿ ಮತ್ತು ಗಳಿಸಿ",
          "refer_friends": "ಸ್ನೇಹಿತರನ್ನು ಉಲ್ಲೇಖಿಸಿ",
          "earn_Upto_₹100_Per_Friend_You_Invite":
              "ನೀವು ಆಹ್ವಾನಿಸುವ ಪ್ರತಿ ಸ್ನೇಹಿತರಿಗೆ ₹100 ವರೆಗೆ ಗಳಿಸಿ",
          "my_rewards": "ನನ್ನ ಬಹುಮಾನಗಳು",
          "share_Your_Invite_Code": "ನಿಮ್ಮ ಆಹ್ವಾನ ಕೋಡ್ ಅನ್ನು ಹಂಚಿಕೊಳ್ಳಿ",
          "when_Your_Friends_Sign_Up_This_Referral":
              "ನಿಮ್ಮ ಸ್ನೇಹಿತರು ಈ ಉಲ್ಲೇಖವನ್ನು ಸೈನ್ ಅಪ್ ಮಾಡಿದಾಗ",
          "Code,_You_Can_Received_A_Free_Ride":
              "ಕೋಡ್, ನೀವು ಉಚಿತ ಸವಾರಿಯನ್ನು ಪಡೆಯಬಹುದು",
          'refer': 'ಉಲ್ಲೇಖಿಸಿ',
//ReferalCodeView
          'hello,_skipper': 'ಹಲೋ, ಸ್ಕಿಪ್ಪರ್',
          'your_Account_Will_Be_Registered_With_This_Mobile_Number':
              'ಈ ಮೊಬೈಲ್ ಸಂಖ್ಯೆಯೊಂದಿಗೆ ನಿಮ್ಮ ಖಾತೆಯನ್ನು ನೋಂದಾಯಿಸಲಾಗುತ್ತದೆ',
          "have_a_referral_code?": "ರೆಫರಲ್ ಕೋಡ್ ಅನ್ನು ಹೊಂದಿರಿ?",
          'enter_referral_code': 'ರೆಫರಲ್ ಕೋಡ್ ನಮೂದಿಸಿ',
          'referal_Code_Must_Be_5_Digits': 'ರೆಫರಲ್ ಕೋಡ್ 5 ಅಂಕಿಗಳಾಗಿರಬೇಕು',
//ReviewsView
          'rating_&_reviews': 'ರೇಟಿಂಗ್ ಮತ್ತು ವಿಮರ್ಶೆಗಳು',
          "rating": "ರೇಟಿಂಗ್",
          // "lorem_ipsum_Is_Simply_Dummy_Text_Of_The_Printing_And_Typesetting_Industry._lorem_ipsum_Has_Been_The_Industry's_Standard_Dummy_Text_Ever_Since_The_1500s.":
          //     "ಲೋರೆಮ್ ಇಪ್ಸಮ್ ಮುದ್ರಣ ಮತ್ತು ಟೈಪ್‌ಸೆಟ್ಟಿಂಗ್ ಉದ್ಯಮದ ನಕಲಿ ಪಠ್ಯವಾಗಿದೆ. ಲೊರೆಮ್ ಇಪ್ಸಮ್ 1500 ರ ದಶಕದಿಂದಲೂ ಉದ್ಯಮದ ಪ್ರಮಾಣಿತ ನಕಲಿ ಪಠ್ಯವಾಗಿದೆ.",
//RideHistoryView
          'ride_history': 'ಸವಾರಿ ಇತಿಹಾಸ',
          'today': 'ಇಂದು',
          "all": "ಎಲ್ಲಾ",
          "completed": "ಪೂರ್ಣಗೊಂಡಿದೆ",
          "rejected": "ತಿರಸ್ಕರಿಸಿದ",

          //RideHistoryCard
          'online_paid ': 'ಆನ್‌ಲೈನ್‌ನಲ್ಲಿ ಪಾವತಿಸಲಾಗಿದೆ ',
          'yesterday': 'ನಿನ್ನೆ',
          'week': 'ವಾರ',
          'custom': 'ಕಸ್ಟಮ್',

          'Personal_Details': 'ವೈಯಕ್ತಿಕ ವಿವರಗಳು',
          //homepage drawer
          'earnings': 'ಗಳಿಕೆ',
          'order_history': 'ಆದೇಶ ಇತಿಹಾಸ',
          'rating_reviews': 'ರೇಟಿಂಗ್ ಮತ್ತು ವಿಮರ್ಶೆಗಳು',

          'refer_earn': 'ಉಲ್ಲೇಖಿಸಿ ಮತ್ತು ಗಳಿಸಿ',
          //homepage earningcard
          'enable_location_to_get_nearby_rides':
              'ಹತ್ತಿರದ ಸವಾರಿಗಳನ್ನು ಪಡೆಯಲು ಸ್ಥಳವನ್ನು ಸಕ್ರಿಯಗೊಳಿಸಿ',
          'enable_location': 'ಸ್ಥಳವನ್ನು ಸಕ್ರಿಯಗೊಳಿಸಿ',
          'todays_earnings': 'ಇಂದಿನ ಗಳಿಕೆಗಳು',
          'cash_collected': 'ನಗದು ಸಂಗ್ರಹಿಸಲಾಗಿದೆ',
          //homepage flutterripplewidget
          'go_online': 'ಅಂತರ್ಜಾಲ ಸಂಪರ್ಕಕ್ಕೆ ಹೋಗು',
          //homepage currentlyofflinecard
          'offine_message':
              'ನೀವು ಪ್ರಸ್ತುತ ಆಫ್‌ಲೈನ್‌ನಲ್ಲಿರುವಿರಿ, ಗಳಿಕೆಯನ್ನು ಪ್ರಾರಂಭಿಸಲು ದಯವಿಟ್ಟು\nಆನ್‌ಲೈನ್‌ಗೆ ಹೋಗಿ',
          //homepage RoutingBooking
          'my_route_booking': 'ನನ್ನ ಮಾರ್ಗ ಬುಕಿಂಗ್',
          //riplepage widget
          'offline': 'ಆಫ್‌ಲೈನ್',
          'online': 'ಆನ್ಲೈನ್',
          //riplepage widget AccetedOrderCard
          'pickup': 'ಪಿಕಪ್',
          'min_away': ' ನಿಮಿಷ ದೂರ',
          'reject': 'ತಿರಸ್ಕರಿಸಿ',
          "accept_ride": 'ಸವಾರಿ ಸ್ವೀಕರಿಸಿ',
          'arrived': 'ಬಂದರು',
          'complete_ride': 'ಸಂಪೂರ್ಣ ಸವಾರಿ',
          'ride_id:': 'ರೈಡ್ ಐಡಿ:',
          'enter_otp': 'OTP ನಮೂದಿಸಿ',
          'please_ask_otp_to_the_Customer': 'ದಯವಿಟ್ಟು ಗ್ರಾಹಕರಿಗೆ OTP ಕೇಳಿ',
          'otp_length_didn\'t_match': 'OTP ಉದ್ದ ಹೊಂದಿಕೆಯಾಗುತ್ತಿಲ್ಲ',
          'start_ride': 'ರೈಡ್ ಪ್ರಾರಂಭಿಸಿ',
          'Go_to_drop_Location': 'ಡ್ರಾಪ್ ಸ್ಥಳಕ್ಕೆ ಹೋಗಿ',
          'go_to_pick_up': 'ತೆಗೆದುಕೊಳ್ಳಲು ಹೋಗಿ',
          //earningpage
          'today’s_earning': 'ಇಂದಿನ ಗಳಿಕೆ',
          'payout': 'ಪಾವತಿ',
          'history': 'ಇತಿಹಾಸ',
          //today earning
          'rides': 'ಸವಾರಿಗಳು',
          'Km': 'ಕಿ.ಮೀ',
          'hours': 'ಗಂಟೆಗಳು',
          'avg_rating': 'ಸರಾಸರಿ ರೇಟಿಂಗ್',
          'reject_rides': 'ಸವಾರಿಗಳನ್ನು ತಿರಸ್ಕರಿಸಿ',
          'today\'s_earning': 'ಇಂದಿನ ಗಳಿಕೆ',
          "order_id :": 'ಆರ್ಡರ್ ಐಡಿ :',
          //payout
          'online_collection': 'ಆನ್ಲೈನ್ ​​ಸಂಗ್ರಹ',
          'amount_to_Pay': 'ಪಾವತಿಸಬೇಕಾದ ಮೊತ್ತ',
          'total_collected_cash': 'ಒಟ್ಟು ಸಂಗ್ರಹಿಸಿದ ನಗದು',
          'tax_charges': 'ತೆರಿಗೆ ಶುಲ್ಕಗಳು',
          'gst_payable_to_the_government.': 'ಸರ್ಕಾರಕ್ಕೆ ಪಾವತಿಸಬೇಕಾದ ಜಿಎಸ್‌ಟಿ.',
          'platform_charge': 'ಪ್ಲಾಟ್‌ಫಾರ್ಮ್ ಶುಲ್ಕ',

          'Daily_one_time_fee.': 'ದೈನಂದಿನ ಒಂದು ಬಾರಿ ಶುಲ್ಕ.',
          'transaction_fees': 'ವಹಿವಾಟು ಶುಲ್ಕಗಳು',
          'Towards_unavoidable_costs_for\noperating_the_app':
              'ಅಪ್ಲಿಕೇಶನ್ ಅನ್ನು ನಿರ್ವಹಿಸಲು\nಅನಿವಾರ್ಯ ವೆಚ್ಚಗಳ ಕಡೆಗೆ',
          'payable_amount': 'ಪಾವತಿಸಬೇಕಾದ ಮೊತ್ತ',
          'maximum_payout_limit_is ': 'ಗರಿಷ್ಠ ಪಾವತಿ ಮಿತಿ ',
          'please_pay_below-charges': 'ದಯವಿಟ್ಟು ಕೆಳಗಿನ ಶುಲ್ಕಗಳನ್ನು ಪಾವತಿಸಿ',
          'Immediately': 'ತಕ್ಷಣವೇ',
          'total_earnings': 'ಒಟ್ಟು ಗಳಿಕೆಗಳು',
          'rides)': 'ಸವಾರಿಗಳು)',
          //ride earning details
          'ride_details': 'ಸವಾರಿ ವಿವರಗಳು',
          'time_fare ': 'ಸಮಯದ ಶುಲ್ಕ ',
          'distance_fare ': 'ದೂರದ ದರ ',
          'surge': 'ಉಲ್ಬಣ',
          'your_earnings': 'ನಿಮ್ಮ ಗಳಿಕೆಗಳು',
          // ride details
          'ride_id': 'ರೈಡ್ ಐಡಿ',
          'date': 'ದಿನಾಂಕ',
          'distance': 'ದೂರ',
          'Mins': 'ನಿಮಿಷಗಳು',
          'duration': 'ಅವಧಿ',
          'pickup_location': 'ಪಿಕಪ್ ಸ್ಥಳ',
          'drop_location': 'ಡ್ರಾಪ್ ಸ್ಥಳ',
          //ride details-total rechargrcard
          'ride_amount': 'ಸವಾರಿ ಮೊತ್ತ',
          'amount_pay_to_company': 'ಕಂಪನಿಗೆ ಪಾವತಿಸುವ ಮೊತ್ತ',
          //profile
          'profile': 'ಪ್ರೊಫೈಲ್',

          'vehicle': 'ವಾಹನ',
          'bank_details': 'ಬ್ಯಾಂಕ್ ವಿವರಗಳು',
          //profile- personaldetails
          'FirstName_cant_be_empty': 'ಮೊದಲ ಹೆಸರು ಖಾಲಿ ಇರುವಂತಿಲ್ಲ',
          'FirstName_must_be_minimum_1_digits':
              'ಮೊದಲ ಹೆಸರು ಕನಿಷ್ಠ 1 ಅಂಕೆಗಳಾಗಿರಬೇಕು',
          'mobile_number': 'ಮೊಬೈಲ್ ನಂಬರ',
          'mobile_number_cant_be_empty': 'ಮೊಬೈಲ್ ಸಂಖ್ಯೆ ಖಾಲಿ ಇರುವಂತಿಲ್ಲ',
          'mobile_number_must_be_minimum_10_digits':
              'ಮೊಬೈಲ್ ಸಂಖ್ಯೆ ಕನಿಷ್ಠ 10 ಅಂಕಿಗಳಾಗಿರಬೇಕು',
          'email': 'ಇಮೇಲ್',
          'gender': 'ಲಿಂಗ',
          'others': 'ಇತರರು',
          //profile-liceience
          'upload_rc_back_side': 'RC ಬ್ಯಾಕ್ ಸೈಡ್ ಅನ್ನು ಅಪ್‌ಲೋಡ್ ಮಾಡಿ',
          'please_enter_license_number': 'ದಯವಿಟ್ಟು ಪರವಾನಗಿ ಸಂಖ್ಯೆಯನ್ನು ನಮೂದಿಸಿ',
          'please_enter_valid_driving_license':
              'ದಯವಿಟ್ಟು ಮಾನ್ಯವಾದ ಚಾಲನಾ ಪರವಾನಗಿಯನ್ನು ನಮೂದಿಸಿ',
          'update': 'ನವೀಕರಿಸಿ',

          //profile-editVechileRegister
          'please_enter_rc_number': 'ದಯವಿಟ್ಟು RC ಸಂಖ್ಯೆಯನ್ನು ನಮೂದಿಸಿ',
          'please_enter_valid_rc_number':
              'ದಯವಿಟ್ಟು ಮಾನ್ಯವಾದ Rc ಸಂಖ್ಯೆಯನ್ನು ನಮೂದಿಸಿ',
          //profile-aadharcard

          'upload_Aadhar_back_side': 'ಆಧಾರ್ ಬ್ಯಾಕ್ ಸೈಡ್ ಅನ್ನು ಅಪ್‌ಲೋಡ್ ಮಾಡಿ',

          //profile-pancard
          'please_enter_pancard_number':
              'ದಯವಿಟ್ಟು ಪ್ಯಾನ್‌ಕಾರ್ಡ್ ಸಂಖ್ಯೆಯನ್ನು ನಮೂದಿಸಿ',
          'please_enter_valid_pancard_number':
              'ದಯವಿಟ್ಟು ಮಾನ್ಯವಾದ ಪ್ಯಾನ್‌ಕಾರ್ಡ್ ಸಂಖ್ಯೆಯನ್ನು ನಮೂದಿಸಿ',

          //profile-bandetails
          'ifsc': 'IFSC',
          'please_enter_ifsc_number': 'ದಯವಿಟ್ಟು IFSC ಸಂಖ್ಯೆಯನ್ನು ನಮೂದಿಸಿ',
          'please_enter_valid_ifsc_number':
              'ದಯವಿಟ್ಟು ಮಾನ್ಯ IFSC ಸಂಖ್ಯೆಯನ್ನು ನಮೂದಿಸಿ',
          'please_enter_upi_number': 'ದಯವಿಟ್ಟು UPI ಸಂಖ್ಯೆಯನ್ನು ನಮೂದಿಸಿ',
          'Please_enter_valid_upi_number':
              'ದಯವಿಟ್ಟು ಮಾನ್ಯವಾದ UPI ಸಂಖ್ಯೆಯನ್ನು ನಮೂದಿಸಿ',
        },
        'tl_in': {
          "support": "మద్దతు",
          "easy_go": "సులభంగా వెళ్ళు",
          "customer_support": "వినియోగదారుని మద్దతు",
          "chat": "చాట్",
          //ride info
          "ride_info": "రైడ్ సమాచారం",
          'ride_id: ': 'రైడ్ Id: ',
          //rideDetails
          'cancel_ride': 'రైడ్‌ని రద్దు చేయండి',
          //payNow
          'please_Pay_The_Amount\nBefore_Contuning':
              'దయచేసి కొనసాగించే ముందు\nమొత్తాన్ని చెల్లించండి',
          'payout_details': 'చెల్లింపు వివరాలు',
          'pay_now': 'ఇప్పుడు చెల్లించండి',
          'skip': 'దాటవేయండి',
          'payment_under_process': 'చెల్లింపు ప్రక్రియలో ఉంది',
          'please_Don’t_Go_Back_Or_Refresh_The_Page\nas_We_Are_Processing_Your_Payment':
              'మేము మీ చెల్లింపును ప్రాసెస్ చేస్తున్నందున దయచేసి వెనుకకు వెళ్లవద్దు లేదా పేజీని రిఫ్రెష్ చేయవద్దు',
          //customerSupport
          'please_Select_Reason_For_Cancel_ride':
              'దయచేసి రైడ్‌ని రద్దు చేయడానికి కారణాన్ని ఎంచుకోండి',
          'unsafe_Pickup_area': 'అసురక్షిత పికప్ ప్రాంతం',
          'unable_To_Swipe_Arrived': 'స్వైప్ చేయడం సాధ్యం కాలేదు',
          'wrong_Pickup_Location': 'తప్పు పికప్ స్థానం',
          'long_Pickup': 'లాంగ్ పికప్',
          'heavy_Traffic': 'బారీ రద్ది',
          //BackCollectedButton
          'back': 'వెనుకకు',
          //RateCard
          'rate_card': 'రేట్ కార్డు',
          'monday_To_sunday': 'సోమవారం నుండి ఆదివారం వరకు',
          'maximum_Payout_Limit_Is_₹500': 'గరిష్ట చెల్లింపు పరిమితి ₹500',
          "bike": "బైక్",
          "auto": "దానంతట అదే",
          //BikeInfo
          'base_Fare': 'బేస్ ఛార్జీ',
          'minimum_Fare': 'కనీస ఛార్జీ',
          'earning_Per_km': 'కిమీకి సంపాదన',
          'price_Per_Minute': 'నిమిషానికి ధర',
          'platform_Charge': 'ప్లాట్‌ఫారమ్ ఛార్జ్',
          'pickup_extra_km_Fare_Post_2km': '2 కిమీ తర్వాత పికప్ అదనపు కి.మీ',
          '(Max_10)': '(గరిష్టంగా 10)',
          'every_Km_Till_8km': '8 కిమీ వరకు ప్రతి కి.మీ',
          'Per_Km ': 'ప్రతి కి.మీ ',
          'every_Km_Above_8km': '8కిమీ పైన ఉన్న ప్రతి కి.మీ',
          //CollectPaymentView
          'collect_payment': 'చెల్లింపును సేకరించండి',
          'ride_iD: ': 'రైడ్ ID: ',
          "collect_amount": "మొత్తాన్ని సేకరించండి",
          'generate_qR_code': 'qr కోడ్‌ని రూపొందించండి',
          'or': 'లేదా',
          'collect_cash': 'నగదు సేకరించండి',
          //CollectCash
          'collect_Cash_Form_The_Customer.': 'కస్టమర్ నుండి నగదును సేకరించండి.',
          'collected': 'సేకరించారు',
          //ChooseAppLanguageView
          'english': 'ఆంగ్ల',
          'hindi': 'హిందీ',
          'kannada': 'కన్నడ',
          'telugu': 'తెలుగు',
          'tamil': 'తమిళం',
          'gujarati': 'గుజరాతీ',
          'app_language': 'యాప్ భాష',
          'set_language': 'సెట్ భాష',
          //AddDetailsView
          'add_details': 'వివరాలను జోడించండి',
          'personal_Details': 'వ్యక్తిగత సమాచారం',
          'vehicle_Details': 'వాహనం వివరాలు',
          'documents': 'పత్రాలు',
          'bank_Details': 'బ్యాంక్ వివరములు',
          'i_Agree_to_The ': 'సమ్మతిస్తున్నాను',
          'terms_&_conditions': 'నిబంధనలు & షరతులు',
          'next': 'తరువాత',
          //VehicleRegistration
          'vehicle_registration_card_(RC)': 'వాహన రిజిస్ట్రేషన్ కార్డ్ (RC)',
          'upload_your_vehicle_registration_card_(RC)':
              'మీ వాహన రిజిస్ట్రేషన్ కార్డ్ (RC)ని అప్‌లోడ్ చేయండి',
          'front_side': 'ముందు వైపు',
          "camera": "కెమెరా",
          "gallery": "గ్యాలరీ",
          'back_side': 'వెనుక వైపు',
          'rC_number': 'RC నంబర్',
          'rC_Number_Cant_Be_Empty': 'RC నంబర్ ఖాళీగా ఉండకూడదు',
          'rC_Number_Must_be_Minimum_10_Characters':
              'RC నంబర్ తప్పనిసరిగా కనీసం 10 అక్షరాలు ఉండాలి',
          'enter_rC_number': 'RC నంబర్‌ని నమోదు చేయండి',
          'save': 'సేవ్ చేయండి',
//TakeYourSelfie
          'add_your_selfie': 'మీ సెల్ఫీని జోడించండి',
          'take_your_selfie': 'మీ సెల్ఫీ తీసుకోండి',
          'we_Use_Your_Selfie_To_Compare_With_Your_id':
              'మేము మీ Idతో పోల్చడానికి మీ సెల్ఫీని ఉపయోగిస్తాము',
          'good_Lighting': 'మంచి లైటింగ్',
          'make_Sure_You_Are_In_A_Well_Lit_Area_And_Both_Ears_Are_Uncovered ':
              'మీరు బాగా వెలుతురు ఉన్న ప్రదేశంలో ఉన్నారని మరియు రెండు చెవులు కప్పబడి ఉన్నాయని నిర్ధారించుకోండి ',
          'look_Straight': 'Look straight',
          'hold_Your_Phone_At_Eye_Level_And_Looks_Straight_To_The_Camera':
              'మీ ఫోన్‌ను కంటి స్థాయిలో పట్టుకుని కెమెరా వైపు నేరుగా చూడండి',
          'open_camera': 'కెమెరా తెరువు',
          'male': 'పురుషుడు',
          'female': 'స్త్రీ',
          'Others': 'Others',
          'month/date/year': 'నెల/తేదీ/సంవత్సరం',
          'enter_Valid_Date': 'చెల్లుబాటు అయ్యే తేదీని నమోదు చేయండి',
          'enter_Date_In_Valid_Range':
              'చెల్లుబాటు అయ్యే పరిధిలో తేదీని నమోదు చేయండి',
          'personal_details': 'వ్యక్తిగత సమాచారం',
          'first_name': 'మొదటి పేరు',
          'firstName_Cant_Be_Empty': 'మొదటి పేరు ఖాళీగా ఉండకూడదు',
          'firstName_Must_Be_Minimum_1_Digits':
              'మొదటి పేరు తప్పనిసరిగా కనీసం 1 అంకె ఉండాలి',
          'full_name': 'పూర్తి పేరు',
          'last_name': 'చివరి పేరు',
          'lastName_Cant_Be_Empty': 'చివరి పేరు ఖాళీగా ఉండకూడదు',
          'lastName_Must_Be_Minimum_1_Digits':
              'చివరి పేరు తప్పనిసరిగా కనీసం 1 అంకె ఉండాలి',
          'enter_mail_id': 'మెయిల్ ఐడిని నమోదు చేయండి',
          'e-mail_Address': 'ఇమెయిల్ చిరునామా',
          "invalid_email": "చెల్లని ఇమెయిల్",
          'enter_date_Of_birth': 'పుట్టిన తేదీని నమోదు చేయండి',
          'date_Of_Birth': 'పుట్టిన తేది',
          'home_address': 'ఇంటి చిరునామ',
          'home_addres_Cant_Be_Empty': 'ఇంటి చిరునామా ఖాళీగా ఉండకూడదు',
          'home_addres_Must_Be_Minimum_1_Digits':
              'ఇంటి చిరునామా తప్పనిసరిగా కనీసం 1 అంకె ఉండాలి',
          'enter_home_address': 'ఇంటి చిరునామాను నమోదు చేయండి',
          'city': 'నగరం',
          'city_Cant_Be_Empty': 'నగరం ఖాళీగా ఉండకూడదు',
          'city_Must_Be_Minimum_1_Digits':
              'నగరం తప్పనిసరిగా కనీసం 1 అంకెలు ఉండాలి',
          'enter_City': 'నగరంలోకి ప్రవేశించండి',
          'state ': 'రాష్ట్రం ',
          'state_Cant_Be_Empty': 'రాష్ట్రం ఖాళీగా ఉండకూడదు',
          'state_Must_Be_Minimum_1_Digits':
              'రాష్ట్రం తప్పనిసరిగా కనీసం 1 అంకె ఉండాలి',
          'enter_State': 'రాష్ట్రంలోకి ప్రవేశించండి',
          'pincode': 'పిన్ కోడ్',
          'pincode_Cant_Be_Empty': 'పిన్‌కోడ్ ఖాళీగా ఉండకూడదు',
          'pincode_Must_Be_Minimum_6_Digits':
              'పిన్‌కోడ్ తప్పనిసరిగా కనీసం 6 అంకెలు ఉండాలి',
          'enter_Pincode': 'పిన్‌కోడ్‌ని నమోదు చేయండి',
          //PanCard
          'pAN_card': 'పాన్ కార్డ్',
          'upload_your_pAN_card': 'మీ పాన్ కార్డ్‌ని అప్‌లోడ్ చేయండి',
          'pAN_number': 'పాన్ నంబర్',
          'pAN_Number_Can_Not_Be_Empty.': 'PAN నంబర్ ఖాళీగా ఉండకూడదు.',
          'enter_pAN_number': 'PAN నంబర్‌ని నమోదు చేయండి',
          //VechileSelection
          'job_details': 'ఉద్యోగ వివరాలు',
          'which_Vehicle_Will_You_Use?': 'మీరు ఏ వాహనాన్ని ఉపయోగిస్తారు?',
          'vehicle_type': 'వాహనం రకం',
          'electric': 'విద్యుత్',
          'non-electric': 'నాన్-ఎలక్ట్రిక్',
          //DrivingLicense
          'driving_license': 'వాహనం నడపడానికి చట్టబద్ధమైన అర్హత',
          'upload_your_driving_license':
              'మీ డ్రైవింగ్ లైసెన్స్‌ని అప్‌లోడ్ చేయండి',
          'learner’s_License_Not_Allowed.': 'లెర్నర్ లైసెన్స్ అనుమతించబడదు.',
          'driving_license_number': 'డ్రైవింగ్ లైసెన్స్ నంబర్',
          'driving_License_Cant_Be_Empty': 'డ్రైవింగ్ లైసెన్స్ ఖాళీగా ఉండకూడదు',
          'driving_License_Must_Be_Minimum_16_Characters':
              'డ్రైవింగ్ లైసెన్స్ తప్పనిసరిగా కనీసం 16 అక్షరాలు ఉండాలి',
          'expiry_date': 'గడువు తీరు తేదీ',
//Documents
          'upload_All_documents,_required_For_Your_Verification.':
              'మీ ధృవీకరణ కోసం అవసరమైన అన్ని పత్రాలను అప్‌లోడ్ చేయండి.',
          'aadhar_card': 'ఆధార్ కార్డ్',
          //Demo
          'membership_For_45_Days': 'సభ్యత్వం 45 రోజులు',
          'free': 'ఉచిత',
          '10_Days_Left': '10 రోజులు మిగిలి ఉన్నాయి',
//BankDetails
          'enter_A_Valid_iFSC_Number.':
              'చెల్లుబాటు అయ్యే IFSC నంబర్‌ను నమోదు చేయండి.',
          'add_your_bank_details': 'మీ బ్యాంక్ వివరాలను జోడించండి',
          'account_holder_name': 'ఖాతాదారుని పేరు',
          'enter_bankholder_name_Cant_Be_Empty':
              'బ్యాంక్ హోల్డర్ పేరు ఖాళీగా ఉండకూడదు',
          'enter_bankholder_name_Must_Be_Minimum_3_Characters':
              'బ్యాంక్ హోల్డర్ పేరు తప్పనిసరిగా కనీసం 3 అక్షరాలు ఉండాలి',
          'enter_Bank_Holder_Name': 'బ్యాంక్ హోల్డర్ పేరును నమోదు చేయండి',
          'account_Number': 'ఖాతా సంఖ్య',
          'account_Number_Cant_Be_Empty': 'ఖాతా నంబర్ ఖాళీగా ఉండకూడదు',
          'account_Number_Must_Be_9_To_17_Digits':
              'ఖాతా సంఖ్య తప్పనిసరిగా 9 నుండి 17 అంకెలు ఉండాలి',
          'iFSC_Code': 'IFSC కోడ్',
          'ifsc_Code_Can_Not_Be_Empty.': 'Ifsc కోడ్ ఖాళీగా ఉండకూడదు.',
          'enter_Valid_Ifsc_Code': 'చెల్లుబాటు అయ్యే ifsc కోడ్‌ని నమోదు చేయండి',
          'enter_Ifsc_Code': 'ifsc కోడ్‌ని నమోదు చేయండి',
          'bank_name': 'బ్యాంకు పేరు',
          'bank_Name_Can_Not_Be_Empty.': 'బ్యాంక్ పేరు ఖాళీగా ఉండకూడదు.',
          'enter_bank_Name': 'బ్యాంక్ పేరు నమోదు చేయండి',
          'add_your_uPI': 'మీ UPIని జోడించండి',
          'uPI': 'UPI',
          'uPI_Id_Can_Not_Be_Empty.': 'UPI id ఖాళీగా ఉండకూడదు.',
//AdharCard
          'upload_Your_Aadhar_Card': 'మీ ఆధార్ కార్డును అప్‌లోడ్ చేయండి',
          'aadhar_Number': 'ఆధార్ నంబర్',
          'aadhar_number_Cant_Be_Empty': 'ఆధార్ నంబర్ ఖాళీగా ఉండకూడదు',
          'aadhar_number_Must_Be_12_Digits':
              'ఆధార్ సంఖ్య తప్పనిసరిగా 12 అంకెలు ఉండాలి',
//LoginPageView
          "login ": "ప్రవేశించండి ",
          "mobile_number ": "మొబైల్ నంబర్ ",
          "mobile_Number_Can't_Be_Empty": "మొబైల్ నంబర్ ఖాళీగా ఉండకూడదు",
          "mobile_Number_Must_Be_10_Digits":
              "మొబైల్ నంబర్ తప్పనిసరిగా 10 అంకెలు ఉండాలి",
          'enter_Mobile_Number': 'మొబైల్ నంబర్‌ను నమోదు చేయండి',
          'login': 'ప్రవేశించండి',
//NotificationView
          'notifications': 'నోటిఫికేషన్‌లు',
          "clear": "క్లియర్",
          "start_your_first_ride_with_winter_Offers.":
              "వింటర్ ఆఫర్‌లతో మీ మొదటి రైడ్‌ను ప్రారంభించండి.",
          "happy_winter_offer_On_Your_first_ride,_enjoy_ride_With_best_offers._check_It_Now":
              "మీ మొదటి రైడ్‌లో హ్యాపీ వింటర్ ఆఫర్, ఉత్తమ ఆఫర్‌లతో రైడ్‌ని ఆస్వాదించండి. ఇప్పుడే తనిఖీ చేయండి",
          "2_Days_Ago": "2 రోజుల క్రితం",
//OrderCompletedView
          'ride_completed': 'రైడ్ పూర్తయింది',
          'great_job!': 'గొప్ప పని!',
          'ride_successfully_completed': 'రైడ్ విజయవంతంగా పూర్తయింది',
          'total_Distance : ': 'మొత్తం దూరం : ',
          'total_Ride_Time : ': 'మొత్తం రైడ్ సమయం: ',
          'amount : ': 'మొత్తం : ',
          'ready_for_next_order': 'తదుపరి ఆర్డర్ కోసం సిద్ధంగా ఉంది',
          //ProfileReview
          ' rejected': ' తిరస్కరించబడింది',
          'please_Contact_Admin_Support':
              'దయచేసి నిర్వాహక మద్దతును సంప్రదించండి',
          "  your_Profile_Is_Under_Reviewing\nprocess._Please_Wait_2_To_4_Days":
              "  మీ ప్రొఫైల్ రివ్యూ\nప్రాసెస్‌లో ఉంది. దయచేసి 2 నుండి 4 రోజులు వేచి ఉండండి",
//ReferAndEarnView
          "refer_&_earn": "సూచించండి & సంపాదించండి",
          "refer_friends": "స్నేహితులను సూచించండి",
          "earn_Upto_₹100_Per_Friend_You_Invite":
              "మీరు ఆహ్వానించిన ప్రతి స్నేహితునికి ₹100 వరకు సంపాదించండి",
          "my_rewards": "నా రివార్డులు",
          "share_Your_Invite_Code": "మీ ఆహ్వాన కోడ్‌ను షేర్ చేయండి",
          "when_Your_Friends_Sign_Up_This_Referral":
              "మీ స్నేహితులు ఈ రెఫరల్‌ని సైన్ అప్ చేసినప్పుడు",
          "Code,_You_Can_Received_A_Free_Ride":
              "కోడ్, మీరు ఉచిత రైడ్ పొందవచ్చు",
          'refer': 'సూచించండి',
//ReferalCodeView
          'hello,_skipper': 'హలో, స్కిప్పర్',
          'your_Account_Will_Be_Registered_With_This_Mobile_Number':
              'మీ ఖాతా ఈ మొబైల్ నంబర్‌తో నమోదు చేయబడుతుంది',
          "have_a_referral_code?": "రెఫరల్ కోడ్ ఉందా?",
          'enter_referral_code': 'రెఫరల్ కోడ్‌ని నమోదు చేయండి',
          'referal_Code_Must_Be_5_Digits':
              'రెఫరల్ కోడ్ తప్పనిసరిగా 5 అంకెలు ఉండాలి',
//ReviewsView
          'rating_&_reviews': 'రేటింగ్ & రివ్యూలు',
          "rating": "రేటింగ్",
          "lorem_ipsum_Is_Simply_Dummy_Text_Of_The_Printing_And_Typesetting_Industry._lorem_ipsum_Has_Been_The_Industry's_Standard_Dummy_Text_Ever_Since_The_1500s.":
              "లోరెమ్ ఇప్సమ్ అనేది ప్రింటింగ్ మరియు టైప్‌సెట్టింగ్ పరిశ్రమ యొక్క డమ్మీ టెక్స్ట్. లోరెమ్ ఇప్సమ్ 1500ల నుండి పరిశ్రమ యొక్క ప్రామాణిక డమ్మీ టెక్స్ట్.",
//RideHistoryView
          'ride_history': 'రైడ్ చరిత్ర',
          'today': 'ఈరోజు',
          "all": "అన్నీ",
          "completed": "పూర్తయింది",
          "rejected": "తిరస్కరించబడింది",

          //RideHistoryCard
          'online_paid ': 'ఆన్‌లైన్‌లో చెల్లించారు ',
          'yesterday': 'నిన్న',
          'week': 'వారం',
          'custom': 'కస్టమ్',

          'Personal_Details': 'వ్యక్తిగత సమాచారం',
          //homepage drawer
          'earnings': 'సంపాదన',
          'order_history': 'ఆర్డర్ చరిత్ర',
          'rating_reviews': 'రేటింగ్ & రివ్యూలు',

          'refer_earn': 'సూచించండి & సంపాదించండి',
          //homepage earningcard
          'enable_location_to_get_nearby_rides':
              'సమీప రైడ్‌లను పొందడానికి స్థానాన్ని ప్రారంభించండి',
          'enable_location': 'స్థానాన్ని ప్రారంభించండి',
          'todays_earnings': 'నేటి ఆదాయాలు',
          'cash_collected': 'నగదు సేకరించారు',
          //homepage flutterripplewidget
          'go_online': 'ఆన్ లైన్ లోకి వెళ్ళు',
          'km)': 'కిమీ)',
          //homepage currentlyofflinecard
          'offine_message':
              'మీరు ప్రస్తుతం ఆఫ్‌లైన్‌లో ఉన్నారు, దయచేసి\nసంపాదన ప్రారంభించడానికి ఆన్‌లైన్‌కి వెళ్లండి',
          //homepage RoutingBooking
          'my_route_booking': 'నా రూట్ బుకింగ్',
          //riplepage widget
          'offline': 'ఆఫ్‌లైన్',
          'online': 'ఆన్‌లైన్',
          //riplepage widget AccetedOrderCard
          'pickup': 'తీసుకోవడం',
          'min_away': ' నిమిషాల దూరంలో',
          'reject': 'తిరస్కరించు',
          "accept_ride": 'రైడ్‌ని అంగీకరించండి',
          'arrived': 'వచ్చారు',
          'complete_ride': 'పూర్తి రైడ్',
          'ride_id:': 'రైడ్ Id:',
          'enter_otp': 'OTPని నమోదు చేయండి',
          'please_ask_otp_to_the_Customer': 'దయచేసి కస్టమర్‌కి OTPని అడగండి',
          'otp_length_didn\'t_match': 'OTP పొడవు సరిపోలలేదు',
          'start_ride': 'రైడ్ ప్రారంభించండి',
          'Go_to_drop_Location': 'డ్రాప్ స్థానానికి వెళ్లండి',
          'go_to_pick_up': 'తీయటానికి వెళ్ళండి',
          //earningpage
          'today’s_earning': 'నేటి సంపాదన',
          'payout': 'చెల్లింపు',
          'history': 'చరిత్ర',
          //today earning
          'rides': 'రైడ్స్',
          'Km': 'కి.మీ',
          'hours': 'గంటలు',
          'avg_rating': 'సగటు రేటింగ్',
          'reject_rides': 'రైడ్‌లను తిరస్కరించండి',
          'today\'s_earning': 'ఈరోజు సంపాదన',
          "order_id :": 'ఆర్డర్ గుర్తింపు సంఖ్యా :',
          //payout
          'online_collection': 'ఆన్‌లైన్ సేకరణ',
          'amount_to_Pay': 'చెల్లించాల్సిన మొత్తం',
          'total_collected_cash': 'మొత్తం సేకరించిన నగదు',
          'tax_charges': 'పన్ను ఛార్జీలు',
          'gst_payable_to_the_government.':
              'ప్రభుత్వానికి చెల్లించాల్సిన జీఎస్టీ.',
          'platform_charge': 'ప్లాట్‌ఫారమ్ ఛార్జ్',
          'outstation_rides': 'ಔಟ್ಸ್ಟಾಟಿನ್ ರೈಡ್ಸ್',

          'Daily_one_time_fee.': 'రోజువారీ ఒక్కసారి రుసుము.',
          'transaction_fees': 'లావాదేవీ ఫీజు',
          'Towards_unavoidable_costs_for\noperating_the_app':
              'యాప్‌ని నిర్వహించడం కోసం\nనివారించలేని ఖర్చుల వైపు',
          'payable_amount': 'చెల్లించవలసిన మొత్తం',
          'maximum_payout_limit_is ': 'గరిష్ట చెల్లింపు పరిమితి ',
          'please_pay_below-charges': 'దయచేసి దిగువ ఛార్జీలను చెల్లించండి',
          'Immediately': 'తక్షణమే',
          'total_earnings': 'మొత్తం సంపాదన',
          'rides)': 'రైడ్స్)',
          //ride earning details
          'ride_details': 'రైడ్ వివరాలు',
          'time_fare ': 'సమయ ఛార్జీ ',
          'distance_fare ': 'దూర ఛార్జీలు ',
          'surge': 'ఉప్పెన',
          'your_earnings': 'మీ సంపాదన',
          // ride details
          'ride_id': 'రైడ్ Id',
          'date': 'తేదీ',
          'distance': 'దూరం',
          'Mins': 'నిమిషాలు',
          'duration': 'వ్యవధి',
          'pickup_location': 'స్థానాన్ని ఎంచుకొని',
          'drop_location': 'డ్రాప్ లొకేషన్',
          //ride details-total rechargrcard
          'ride_amount': 'రైడ్ మొత్తం',
          'amount_pay_to_company': 'కంపెనీకి చెల్లించే మొత్తం',
          //profile
          'profile': 'ప్రొఫైల్',

          'vehicle': 'వాహనం',
          'bank_details': 'బ్యాంక్ వివరములు',
          //profile- personaldetails
          'FirstName_cant_be_empty': 'మొదటి పేరు ఖాళీగా ఉండకూడదు',
          'FirstName_must_be_minimum_1_digits':
              'మొదటి పేరు తప్పనిసరిగా కనీసం 1 అంకెలు ఉండాలి',
          'mobile_number': 'మొబైల్ నంబర్',
          'mobile_number_cant_be_empty': 'మొబైల్ నంబర్ ఖాళీగా ఉండకూడదు',
          'mobile_number_must_be_minimum_10_digits':
              'మొబైల్ నంబర్ తప్పనిసరిగా కనీసం 10 అంకెలు ఉండాలి',
          'email': 'ఇమెయిల్',
          'gender': 'లింగం',
          'others': 'ఇతరులు',
          //profile-liceience
          'upload_rc_back_side': 'RC బ్యాక్ సైడ్ అప్‌లోడ్ చేయండి',
          'please_enter_license_number':
              'దయచేసి లైసెన్స్ నంబర్‌ని నమోదు చేయండి',
          'please_enter_valid_driving_license':
              'దయచేసి చెల్లుబాటు అయ్యే డ్రైవింగ్ లైసెన్స్‌ని నమోదు చేయండి',
          'update': 'నవీకరించు',

          //profile-editVechileRegister
          'please_enter_rc_number': 'దయచేసి RC నంబర్‌ని నమోదు చేయండి',
          'please_enter_valid_rc_number':
              'దయచేసి చెల్లుబాటు అయ్యే Rc నంబర్‌ని నమోదు చేయండి',
          //profile-aadharcard

          'upload_Aadhar_back_side': 'వెనుకవైపు ఆధార్‌ను అప్‌లోడ్ చేయండి',
          //profile-pancard
          'please_enter_pancard_number':
              'దయచేసి పాన్‌కార్డ్ నంబర్‌ని నమోదు చేయండి',
          'please_enter_valid_pancard_number':
              'దయచేసి చెల్లుబాటు అయ్యే పాన్‌కార్డ్ నంబర్‌ను నమోదు చేయండి',

          //profile-bandetails
          'ifsc': 'IFSC',
          'please_enter_ifsc_number': 'దయచేసి IFSC నంబర్‌ని నమోదు చేయండి',
          'please_enter_valid_ifsc_number':
              'దయచేసి చెల్లుబాటు అయ్యే IFSC నంబర్‌ను నమోదు చేయండి',
          'please_enter_upi_number': 'దయచేసి UPI నంబర్‌ని నమోదు చేయండి',
          'Please_enter_valid_upi_number':
              'దయచేసి చెల్లుబాటు అయ్యే UPI నంబర్‌ని నమోదు చేయండి',
        },
        'ta_in': {
          //support
          "support": "ஆதரவு",
          "easy_go": "எளிதாக",
          "customer_support": "வாடிக்கையாளர் ஆதரவு",
          "chat": "அரட்டை",
          //ride info
          "ride_info": "சவாரி தகவல்",
          'ride_id: ': 'சவாரி ஐடி: ',
          //rideDetails
          'cancel_ride': 'சவாரி ரத்து',
          //payNow
          'please_Pay_The_Amount\nBefore_Contuning':
              'தொடரும் முன்\nதொகையைச் செலுத்தவும்',
          'payout_details': 'செலுத்துதல் விவரங்கள்',
          'pay_now': 'இப்போது செலுத்த',
          'skip': 'தவிர்க்கவும்',
          'payment_under_process': 'செயல்முறையின் கீழ் பணம் செலுத்துதல்',
          'please_Don’t_Go_Back_Or_Refresh_The_Page\nas_We_Are_Processing_Your_Payment':
              'உங்கள் கட்டணத்தைச் செயல்படுத்தி வருவதால், தயவுசெய்து திரும்பிச் செல்லவோ பக்கத்தைப் புதுப்பிக்கவோ வேண்டாம்',
          //customerSupport
          'please_Select_Reason_For_Cancel_ride':
              'பயணத்தை ரத்து செய்வதற்கான காரணத்தைத் தேர்ந்தெடுக்கவும்',
          'unsafe_Pickup_area': 'பாதுகாப்பற்ற இடும் பகுதி',
          'unable_To_Swipe_Arrived': 'ஸ்வைப் செய்ய முடியாமல் வந்தது',
          'wrong_Pickup_Location': 'தவறான பிக்அப் இடம்',
          'long_Pickup': 'நீண்ட பிக்அப்',
          'heavy_Traffic': 'கடுமையான போக்குவரத்து நெரிசல்',
          //BackCollectedButton
          'back': 'மீண்டும்',
          //RateCard
          'rate_card': 'கட்டண அட்டை',
          'monday_To_sunday': 'திங்கள் முதல் ஞாயிறு வரை',
          'maximum_Payout_Limit_Is_₹500': 'அதிகபட்ச பேஅவுட் வரம்பு ₹500',
          "bike": "உந்துஉருளி",
          "auto": "ஆட்டோ",
          //BikeInfo
          'base_Fare': 'அடிப்படை கட்டணம்',
          'minimum_Fare': 'குறைந்தபட்ச கட்டணம்',
          'earning_Per_km': 'ஒரு கிமீ வருவாய்',
          'price_Per_Minute': 'நிமிடத்திற்கு விலை',
          'platform_Charge': 'பிளாட்ஃபார்ம் கட்டணம்',
          'pickup_extra_km_Fare_Post_2km':
              'பிக்அப் கூடுதல் கிமீ கட்டணம் 2 கிமீக்குப் பிறகு',
          '(Max_10)': '(அதிகபட்சம் 10)',
          'every_Km_Till_8km': '8 கிமீ வரை ஒவ்வொரு கி.மீ',
          'Per_Km ': 'ஒரு கி.மீ',
          'every_Km_Above_8km': '8 கிமீக்கு மேல் ஒவ்வொரு கி.மீ',
          //CollectPaymentView
          'collect_payment': 'பணம் சேகரிக்க',
          'ride_iD: ': 'சவாரி ஐடி: ',
          "collect_amount": "தொகை சேகரிக்க",
          'generate_qR_code': 'qr குறியீட்டை உருவாக்கவும்',
          'or': 'அல்லது',
          'collect_cash': 'பணத்தை சேகரிக்க',
          //CollectCash
          'collect_Cash_Form_The_Customer.':
              'வாடிக்கையாளரிடமிருந்து பணத்தை சேகரிக்கவும்.',
          'collected': 'சேகரிக்கப்பட்டது',
          //ChooseAppLanguageView
          'english': 'ஆங்கிலம்',
          'hindi': 'இந்தி',
          'kannada': 'கன்னடம்',
          'telugu': 'தெலுங்கு',
          'tamil': 'தமிழ்',
          'gujarati': 'குஜராத்தி',
          'app_language': 'பயன்பாட்டு மொழி',
          'set_language': 'மொழி அமைக்க',
          //AddDetailsView
          'add_details': 'விவரங்களைச் சேர்க்கவும்',
          'personal_Details': 'தனிப்பட்ட விவரங்கள்',
          'vehicle_Details': 'வாகன விவரங்கள்',
          'documents': 'ஆவணங்கள்',
          'bank_Details': 'வங்கி விவரங்கள்',
          'i_Agree_to_The ': 'நான் இதனை ஏற்று கொள்கிறேன் ',
          'terms_&_conditions': 'விதிமுறைகளும் நிபந்தனைகளும்',
          'next': 'அடுத்தது',
          //VehicleRegistration
          'vehicle_registration_card_(RC)': 'வாகனப் பதிவு அட்டை (RC)',
          'upload_your_vehicle_registration_card_(RC)':
              'உங்கள் வாகனப் பதிவு அட்டையை (RC) பதிவேற்றவும்',
          'front_side': 'முன் பக்க',
          "camera": "புகைப்பட கருவி",
          "gallery": "கேலரி",
          'back_side': 'பின் பக்கம்',
          'rC_number': 'ஆர்சி எண்',
          'rC_Number_Cant_Be_Empty': 'RC எண் காலியாக இருக்கக்கூடாது',
          'rC_Number_Must_be_Minimum_10_Characters':
              'RC எண்ணில் குறைந்தபட்சம் 10 எழுத்துகள் இருக்க வேண்டும்',
          'enter_rC_number': 'ஆர்சி எண்ணை உள்ளிடவும்',
          'save': 'சேமிக்கவும்',
//TakeYourSelfie
          'add_your_selfie': 'உங்கள் செல்ஃபியைச் சேர்க்கவும்',
          'take_your_selfie': 'உங்கள் செல்ஃபி எடுங்கள்',
          'we_Use_Your_Selfie_To_Compare_With_Your_id':
              'உங்கள் ஐடியுடன் ஒப்பிட உங்கள் செல்ஃபியைப் பயன்படுத்துகிறோம்',
          'good_Lighting': 'நல்ல வெளிச்சம்',
          'make_Sure_You_Are_In_A_Well_Lit_Area_And_Both_Ears_Are_Uncovered ':
              'நீங்கள் நன்கு ஒளிரும் இடத்தில் இருப்பதையும், இரண்டு காதுகளும் மூடப்படாமல் இருப்பதையும் உறுதிப்படுத்திக் கொள்ளுங்கள் ',
          'look_Straight': 'நேராக பார்',
          'hold_Your_Phone_At_Eye_Level_And_Looks_Straight_To_The_Camera':
              'உங்கள் மொபைலை கண் மட்டத்தில் பிடித்து கேமராவை நேராக பார்க்கவும்',
          'open_camera': 'புகைப்படக்கருவியை திற',
          'male': 'ஆண்',
          'female': 'பெண்',
          'Others': 'மற்றவைகள்',
          'month/date/year': 'மாதம்/தேதி/ஆண்டு',
          'enter_Valid_Date': 'சரியான தேதியை உள்ளிடவும்',
          'enter_Date_In_Valid_Range': 'சரியான வரம்பில் தேதியை உள்ளிடவும்',
          'personal_details': 'தனிப்பட்ட விவரங்கள்',
          'first_name': 'முதல் பெயர்',
          'firstName_Cant_Be_Empty': 'முதல் பெயர் காலியாக இருக்கக்கூடாது',
          'firstName_Must_Be_Minimum_1_Digits':
              'முதல்பெயர் குறைந்தபட்சம் 1 இலக்கமாக இருக்க வேண்டும்',
          'full_name': 'முழு பெயர்',
          'last_name': 'கடைசி பெயர்',
          'lastName_Cant_Be_Empty': 'கடைசி பெயர் காலியாக இருக்கக்கூடாது',
          'lastName_Must_Be_Minimum_1_Digits':
              'கடைசிப் பெயர் குறைந்தபட்சம் 1 இலக்கமாக இருக்க வேண்டும்',
          'enter_mail_id': 'மெயில் ஐடியை உள்ளிடவும்',
          'e-mail_Address': 'மின்னஞ்சல் முகவரி',
          "invalid_email": "தவறான மின்னஞ்சல்",
          'enter_date_Of_birth': 'பிறந்த தேதியை உள்ளிடவும்',
          'date_Of_Birth': 'பிறந்த தேதி',
          'home_address': 'வீட்டு முகவரி',
          'home_addres_Cant_Be_Empty': 'வீட்டு முகவரி காலியாக இருக்கக்கூடாது',
          'home_addres_Must_Be_Minimum_1_Digits':
              'வீட்டு முகவரி குறைந்தபட்சம் 1 இலக்கமாக இருக்க வேண்டும்',
          'enter_home_address': 'வீட்டு முகவரியை உள்ளிடவும்',
          'city': 'நகரம்',
          'city_Cant_Be_Empty': 'நகரம் காலியாக இருக்க முடியாது',
          'city_Must_Be_Minimum_1_Digits':
              'நகரம் குறைந்தபட்சம் 1 இலக்கமாக இருக்க வேண்டும்',
          'enter_City': 'நகரத்திற்குள் நுழைய',
          'state ': 'நிலை ',
          'state_Cant_Be_Empty': 'மாநிலம் காலியாக இருக்க முடியாது',
          'state_Must_Be_Minimum_1_Digits':
              'மாநிலம் குறைந்தபட்சம் 1 இலக்கமாக இருக்க வேண்டும்',
          'enter_State': 'நிலையை உள்ளிடவும்',
          'pincode': 'அஞ்சல் குறியீடு',
          'pincode_Cant_Be_Empty': 'பின்கோடு காலியாக இருக்கக்கூடாது',
          'pincode_Must_Be_Minimum_6_Digits':
              'பின்கோடு குறைந்தபட்சம் 6 இலக்கங்களாக இருக்க வேண்டும்',
          'enter_Pincode': 'பின் குறியீட்டை உள்ளிடவும்',
          //PanCard
          'pAN_card': 'பான் கார்டு',
          'upload_your_pAN_card': 'உங்கள் பான் கார்டை பதிவேற்றவும்',
          'pAN_number': 'பான் எண்',
          'pAN_Number_Can_Not_Be_Empty.': 'பான் எண் காலியாக இருக்கக்கூடாது.',
          'enter_pAN_number': 'PAN எண்ணை உள்ளிடவும்',
          //VechileSelection
          'job_details': 'வேலை விவரங்கள்',
          'which_Vehicle_Will_You_Use?': 'எந்த வாகனத்தைப் பயன்படுத்துவீர்கள்?',
          'vehicle_type': 'வாகன வகை',
          'electric': 'மின்சாரம்',
          'non-electric': 'மின்சாரம் அல்லாதது',
          "Km)": 'கி.மீ)',
          //DrivingLicense
          'driving_license': 'ஓட்டுனர் உரிமம்',
          'upload_your_driving_license':
              'உங்கள் ஓட்டுநர் உரிமத்தைப் பதிவேற்றவும்',
          'learner’s_License_Not_Allowed.':
              'கற்றல் உரிமம் அனுமதிக்கப்படவில்லை.',
          'driving_license_number': 'ஓட்டுநர் உரிம எண்',
          'driving_License_Cant_Be_Empty':
              'ஓட்டுநர் உரிமம் காலியாக இருக்கக்கூடாது',
          'driving_License_Must_Be_Minimum_16_Characters':
              'ஓட்டுநர் உரிமத்தில் குறைந்தபட்சம் 16 எழுத்துகள் இருக்க வேண்டும்',
          'expiry_date': 'காலாவதி தேதி',
//Documents
          'upload_All_documents,_required_For_Your_Verification.':
              'உங்கள் சரிபார்ப்புக்குத் தேவையான அனைத்து ஆவணங்களையும் பதிவேற்றவும்.',
          'aadhar_card': 'ஆதார் அட்டை',
          //Demo
          'membership_For_45_Days': '45 நாட்களுக்கு உறுப்பினர்',
          'free': 'இலவசம்',
          '10_Days_Left': 'இன்னும் 10 நாட்கள் உள்ளது',
//BankDetails
          'enter_A_Valid_iFSC_Number.': 'சரியான IFSC எண்ணை உள்ளிடவும்.',
          'add_your_bank_details': 'உங்கள் வங்கி விவரங்களைச் சேர்க்கவும்',
          'account_holder_name': 'கணக்கு வைத்திருப்பவரின் பெயர்',
          'enter_bankholder_name_Cant_Be_Empty':
              'வங்கி வைத்திருப்பவரின் பெயரை உள்ளிடவும் காலியாக இருக்கக்கூடாது',
          'enter_bankholder_name_Must_Be_Minimum_3_Characters':
              'வங்கி வைத்திருப்பவரின் பெயரை உள்ளிடவும் குறைந்தபட்சம் 3 எழுத்துகள் இருக்க வேண்டும்',
          'enter_Bank_Holder_Name': 'வங்கி வைத்திருப்பவரின் பெயரை உள்ளிடவும்',
          'account_Number': 'கணக்கு எண்',
          'account_Number_Cant_Be_Empty': 'கணக்கு எண் காலியாக இருக்கக்கூடாது',
          'account_Number_Must_Be_9_To_17_Digits':
              'கணக்கு எண் 9 முதல் 17 இலக்கங்கள் வரை இருக்க வேண்டும்',
          'iFSC_Code': 'IFSC குறியீடு',
          'ifsc_Code_Can_Not_Be_Empty.':
              'Ifsc குறியீடு காலியாக இருக்கக்கூடாது.',
          'enter_Valid_Ifsc_Code': 'சரியான ifsc குறியீட்டை உள்ளிடவும்',
          'enter_Ifsc_Code': 'ifsc குறியீட்டை உள்ளிடவும்',
          'bank_name': 'வங்கி பெயர்',
          'bank_Name_Can_Not_Be_Empty.':
              'வங்கியின் பெயர் காலியாக இருக்கக்கூடாது.',
          'enter_bank_Name': 'வங்கி பெயரை உள்ளிடவும்',
          'add_your_uPI': 'உங்கள் UPIயைச் சேர்க்கவும்',
          'uPI': 'UPI',
          'uPI_Id_Can_Not_Be_Empty.': 'UPI ஐடி காலியாக இருக்கக்கூடாது.',
//AdharCard
          'upload_Your_Aadhar_Card': 'உங்கள் ஆதார் அட்டையை பதிவேற்றவும்',
          'aadhar_Number': 'ஆதார் எண்',
          'aadhar_number_Cant_Be_Empty': 'ஆதார் எண் காலியாக இருக்கக்கூடாது',
          'aadhar_number_Must_Be_12_Digits':
              'ஆதார் எண் 12 இலக்கங்களாக இருக்க வேண்டும்',
//LoginPageView
          "login ": "உள்நுழைய ",
          "mobile_number ": "கைபேசி எண் ",
          "mobile_Number_Can't_Be_Empty": "மொபைல் எண் காலியாக இருக்கக்கூடாது",
          "mobile_Number_Must_Be_10_Digits":
              "மொபைல் எண் 10 இலக்கங்களாக இருக்க வேண்டும்",
          'enter_Mobile_Number': 'மொபைல் எண்ணை உள்ளிடவும்',
          'login': 'உள்நுழைய',
//NotificationView
          'notifications': 'அறிவிப்புகள்',
          "clear": "தெளிவு",
          "start_your_first_ride_with_winter_Offers.":
              "குளிர்காலச் சலுகைகளுடன் உங்கள் முதல் பயணத்தைத் தொடங்குங்கள்.",
          "happy_winter_offer_On_Your_first_ride,_enjoy_ride_With_best_offers._check_It_Now":
              "உங்கள் முதல் பயணத்தில் இனிய குளிர்காலச் சலுகை, சிறந்த சலுகைகளுடன் சவாரி செய்து மகிழுங்கள். இப்பொழுது சரிபார்க்கவும்",
          "2_Days_Ago": "2 நாட்கள் முன்பு",
//OrderCompletedView
          'ride_completed': 'சவாரி முடிந்தது',
          'great_job!': 'பெரிய வேலை!',
          'ride_successfully_completed': 'சவாரி வெற்றிகரமாக முடிந்தது',
          'total_Distance : ': 'மொத்த தூரம் : ',
          'total_Ride_Time : ': 'மொத்த சவாரி நேரம் : ',
          'amount : ': 'தொகை : ',
          'ready_for_next_order': 'அடுத்த ஆர்டருக்கு தயார்',
          //ProfileReview
          ' rejected': ' நிராகரிக்கப்பட்டது',
          'please_Contact_Admin_Support': 'நிர்வாக ஆதரவைத் தொடர்பு கொள்ளவும்',
          "  your_Profile_Is_Under_Reviewing\nprocess._Please_Wait_2_To_4_Days":
              "  உங்கள் சுயவிவரம் மதிப்பாய்வு\nசெயல்பாட்டில் உள்ளது. தயவுசெய்து 2 முதல் 4 நாட்கள் காத்திருக்கவும்",
//ReferAndEarnView
          "refer_&_earn": "பார்க்கவும் & சம்பாதிக்கவும்",
          "refer_friends": "நண்பர்களைப் பார்க்கவும்",
          "earn_Upto_₹100_Per_Friend_You_Invite":
              "நீங்கள் அழைக்கும் ஒரு நண்பருக்கு ₹100 வரை சம்பாதிக்கவும்",
          "my_rewards": "எனது வெகுமதிகள்",
          "share_Your_Invite_Code": "உங்கள் அழைப்புக் குறியீட்டைப் பகிரவும்",
          "when_Your_Friends_Sign_Up_This_Referral":
              "உங்கள் நண்பர்கள் இந்தப் பரிந்துரையைப் பதிவு செய்யும் போது",
          "Code,_You_Can_Received_A_Free_Ride":
              "குறியீடு, நீங்கள் ஒரு இலவச சவாரி பெற முடியும்",
          'refer': 'பார்க்கவும்',
//ReferalCodeView
          'hello,_skipper': 'வணக்கம், கேப்டன்',
          'your_Account_Will_Be_Registered_With_This_Mobile_Number':
              'இந்த மொபைல் எண்ணில் உங்கள் கணக்கு பதிவு செய்யப்படும்',
          "have_a_referral_code?": "பரிந்துரைக் குறியீட்டை வைத்திருங்கள்?",
          'enter_referral_code': 'பரிந்துரை குறியீட்டை உள்ளிடவும்',
          'referal_Code_Must_Be_5_Digits':
              'பரிந்துரை குறியீடு 5 இலக்கங்களாக இருக்க வேண்டும்',
//ReviewsView
          'rating_&_reviews': 'மதிப்பீடு & மதிப்புரைகள்',
          "rating": "மதிப்பீடு",
          "lorem_ipsum_Is_Simply_Dummy_Text_Of_The_Printing_And_Typesetting_Industry._lorem_ipsum_Has_Been_The_Industry's_Standard_Dummy_Text_Ever_Since_The_1500s.":
              "லோரெம் இப்சம் என்பது அச்சிடும் மற்றும் தட்டச்சுத் துறையின் போலி உரை. லோரெம் இப்சம் 1500களில் இருந்து தொழில்துறையின் நிலையான போலி உரையாக இருந்து வருகிறது.",
//RideHistoryView
          'ride_history': 'சவாரி வரலாறு',
          'today': 'இன்று',
          "all": "அனைத்து",
          "completed": "நிறைவு",
          "rejected": "நிராகரிக்கப்பட்டது",

          //RideHistoryCard
          'online_paid ': 'ஆன்லைனில் பணம் செலுத்தப்பட்டது ',
          'yesterday': 'நேற்று',
          'week': 'வாரம்',
          'custom': 'தனிப்பயன்',

          'Personal_Details': 'தனிப்பட்ட விவரங்கள்',
          //homepage drawer
          'earnings': 'வருவாய்',
          'order_history': 'ஆர்டர் வரலாறு',
          'rating_reviews': 'மதிப்பீடு & மதிப்புரைகள்',

          'refer_earn': 'பார்க்கவும் & சம்பாதிக்கவும்',
          //homepage earningcard
          'enable_location_to_get_nearby_rides':
              'அருகிலுள்ள சவாரிகளைப் பெற இருப்பிடத்தை இயக்கவும்',
          'enable_location': 'இருப்பிடத்தை இயக்கு',
          'todays_earnings': 'இன்றைய வருவாய்',
          'cash_collected': 'பணம் சேகரிக்கப்பட்டது',
          //homepage flutterripplewidget
          'go_online': 'இணையத்திற்கு செல்',
          //homepage currentlyofflinecard
          'offine_message':
              'நீங்கள் தற்போது ஆஃப்லைனில் உள்ளீர்கள், சம்பாதிக்கத் தொடங்குவதற்கு\nஆன்லைனுக்குச் செல்லவும்',
          //homepage RoutingBooking
          'my_route_booking': 'எனது வழி முன்பதிவு',
          //riplepage widget
          'offline': 'ஆஃப்லைன்',
          'online': 'நிகழ்நிலை',
          //riplepage widget AccetedOrderCard
          'pickup': 'பிக்கப்',
          'min_away': ' நிமிடம் தொலைவில்',
          'reject': 'நிராகரிக்கவும்',
          "accept_ride": 'சவாரி ஏற்கவும்',
          'arrived': 'வந்தடைந்தது',
          'complete_ride': 'முழுமையான சவாரி',
          'ride_id:': 'சவாரி ஐடி:',
          'enter_otp': 'OTP ஐ உள்ளிடவும்',
          'please_ask_otp_to_the_Customer': 'வாடிக்கையாளரிடம் OTP கேட்கவும்',
          'otp_length_didn\'t_match': 'OTP நீளம் பொருந்தவில்லை',
          'start_ride': 'சவாரி தொடங்கவும்',
          'Go_to_drop_Location': 'இடும் இடத்திற்குச் செல்லவும்',
          'go_to_pick_up': 'எடுக்கச் செல்லுங்கள்',
          //earningpage
          'today’s_earning': 'இன்றைய வருவாய்',
          'payout': 'செலுத்துதல்',
          'history': 'வரலாறு',
          //today earning
          'rides': 'சவாரிகள்',
          'Km': 'கி.மீ',
          'hours': 'மணிநேரம்',
          'avg_rating': 'சராசரி மதிப்பீடு',
          'reject_rides': 'சவாரிகளை நிராகரிக்கவும்',
          'today\'s_earning': 'இன்றைய வருமானம்',
          "order_id :": 'ஆர்டர் ஐடி :',
          //payout
          'online_collection': 'ஆன்லைன் சேகரிப்பு',
          'amount_to_Pay': 'செலுத்த வேண்டிய தொகை',
          'total_collected_cash': 'மொத்த சேகரிக்கப்பட்ட பணம்',
          'tax_charges': 'வரி கட்டணங்கள்',
          'gst_payable_to_the_government.':
              'அரசுக்கு செலுத்த வேண்டிய ஜி.எஸ்.டி.',
          'platform_charge': 'பிளாட்ஃபார்ம் கட்டணம்',
          'Daily_one_time_fee.': 'தினசரி ஒரு முறை கட்டணம்.',
          'transaction_fees': 'பரிவர்த்தனை கட்டணம்',
          'Towards_unavoidable_costs_for\noperating_the_app':
              'பயன்பாட்டை இயக்குவதற்கு\nதவிர்க்க முடியாத செலவுகளை நோக்கி',
          'payable_amount': 'செலுத்த வேண்டிய தொகை',
          'maximum_payout_limit_is ': 'அதிகபட்ச செலுத்துதல் வரம்பு ',
          'please_pay_below-charges':
              'தயவுசெய்து கீழே உள்ள கட்டணங்களைச் செலுத்தவும்',
          'Immediately': 'உடனடியாக',
          'total_earnings': 'மொத்த வருவாய்',
          'rides)': 'சவாரிகள்)',
          //ride earning details
          'ride_details': 'சவாரி விவரங்கள்',
          'time_fare ': 'நேர கட்டணம் ',
          'distance_fare ': 'தூர கட்டணம் ',
          'surge': 'எழுச்சி',
          'your_earnings': 'உங்கள் வருவாய்',
          // ride details
          'ride_id': 'சவாரி ஐடி',
          'date': 'தேதி',
          'distance': 'தூரம்',
          'Mins': 'நிமிடங்கள்',
          'duration': 'கால அளவு',
          'pickup_location': 'பிக்கப் இடம்',
          'drop_location': 'இடும் இடம்',
          //ride details-total rechargrcard
          'ride_amount': 'சவாரி தொகை',
          'amount_pay_to_company': 'நிறுவனத்திற்கு செலுத்த வேண்டிய தொகை',
          //profile
          'profile': 'சுயவிவரம்',

          'vehicle': 'வாகனம்',
          'bank_details': 'வங்கி விவரங்கள்',
          //profile- personaldetails
          'FirstName_cant_be_empty': 'முதல் பெயர் காலியாக இருக்கக்கூடாது',
          'FirstName_must_be_minimum_1_digits':
              'முதல் பெயர் குறைந்தபட்சம் 1 இலக்கமாக இருக்க வேண்டும்',
          'mobile_number': 'கைபேசி எண்',
          'mobile_number_cant_be_empty': 'மொபைல் எண் காலியாக இருக்கக்கூடாது',
          'mobile_number_must_be_minimum_10_digits':
              'மொபைல் எண் குறைந்தபட்சம் 10 இலக்கங்களாக இருக்க வேண்டும்',
          'email': 'மின்னஞ்சல்',
          'gender': 'பாலினம்',
          'others': 'மற்றவைகள்',
          //profile-liceience
          'upload_rc_back_side': 'RC பின் பக்கத்தைப் பதிவேற்றவும்',
          'please_enter_license_number': 'உரிம எண்ணை உள்ளிடவும்',
          'please_enter_valid_driving_license':
              'சரியான ஓட்டுநர் உரிமத்தை உள்ளிடவும்',
          'update': 'புதுப்பிக்கவும்',
          //profile-aadhar card

          'upload_Aadhar_back_side': 'ஆதார் பின் பக்கத்தைப் பதிவேற்றவும்',
          //profile-editVechileRegister
          'please_enter_rc_number': 'RC எண்ணை உள்ளிடவும்',
          'please_enter_valid_rc_number': 'சரியான Rc எண்ணை உள்ளிடவும்',

          //profile-pancard
          'please_enter_pancard_number': 'பான் கார்டு எண்ணை உள்ளிடவும்',
          'please_enter_valid_pancard_number':
              'சரியான பான் கார்டு எண்ணை உள்ளிடவும்',

          //profile-bandetails
          'ifsc': 'IFSC',
          'please_enter_ifsc_number': 'IFSC எண்ணை உள்ளிடவும்',
          'please_enter_valid_ifsc_number': 'சரியான IFSC எண்ணை உள்ளிடவும்',
          'please_enter_upi_number': 'தயவுசெய்து UPI எண்ணை உள்ளிடவும்',
          'Please_enter_valid_upi_number': 'சரியான UPI எண்ணை உள்ளிடவும்',
        },
        'hi_in': {
          //suport
          "support": "सहारा",
          "easy_go": "आसानी से जाना",
          "customer_support": "ग्राहक सहायता",
          "chat": "बात करना",
          //ride info
          "ride_info": "सवारी की जानकारी",
          'ride_id: ': 'सवारी आईडी: ',
          //rideDetails
          'cancel_ride': 'राइड रद्द करें',
          //payNow
          'please_Pay_The_Amount\nBefore_Contuning':
              'कृपया राशि का भुगतान करें\nआगे बढ़ने से पहले',
          'payout_details': 'भुगतान विवरण',
          'pay_now': 'अब भुगतान करें',
          'skip': 'छोड़ें',
          'payment_under_process': 'भुगतान प्रक्रियाधीन है',
          'please_Don’t_Go_Back_Or_Refresh_The_Page\nas_We_Are_Processing_Your_Payment':
              'कृपया वापस न जाएं या पेज को रीफ्रेश न करें\nक्योंकि हम आपका भुगतान संसाधित कर रहे हैं',
          //customerSupport
          'please_Select_Reason_For_Cancel_ride':
              'कृपया राइड रद्द करने का कारण चुनें',
          'unsafe_Pickup_area': 'असुरक्षित पिकअप क्षेत्र',
          'unable_To_Swipe_Arrived': 'स्वाइप करने में असमर्थ आ गया',
          'wrong_Pickup_Location': 'गलत पिकअप स्थान',
          'long_Pickup': 'लंबा पिकअप',
          'heavy_Traffic': 'भारी यातायात',
          //BackCollectedButton
          'back': 'पीछे',
          //RateCard
          'rate_card': 'दर पत्र',
          'monday_To_sunday': 'सोमवार से रविवार',
          'maximum_Payout_Limit_Is_₹500': 'अधिकतम भुगतान सीमा है ₹500',
          "bike": "बाइक",
          "auto": "ऑटो",
          //BikeInfo
          'base_Fare': 'बुनियादी भाड़ा',
          'minimum_Fare': 'न्यूनतम किराया',
          'earning_Per_km': 'आय प्रति किमी',
          'price_Per_Minute': 'मूल्य प्रति मिनट',
          'platform_Charge': 'प्लेटफॉर्म चार्ज',
          'pickup_extra_km_Fare_Post_2km':
              'पिकअप अतिरिक्त किमी किराया 2 किमी के बाद',
          '(Max_10)': '(मैक्स 10)',
          'every_Km_Till_8km': 'हर किमी 8 किमी तक',
          'Per_Km ': 'प्रति किमी ',
          'every_Km_Above_8km': '8 किमी से ऊपर हर किमी',
          //CollectPaymentView
          'collect_payment': 'भुगतान प्राप्त करें',
          'ride_iD: ': 'सवारी आईडी: ',
          "collect_amount": "राशि एकत्रित करें",
          'generate_qR_code': 'क्यूआर कोड जनरेट करें',
          'or': 'या',
          'collect_cash': 'कैश कलेक्ट करें',
          //CollectCash
          'collect_Cash_Form_The_Customer.': 'ग्राहक से नकद राशि लीजिए.',
          'collected': 'जुटाया हुआ।',
          //ChooseAppLanguageView
          'english': 'अंग्रेज़ी',
          'hindi': 'हिंदी',
          'kannada': 'कन्नडा',
          'telugu': 'तेलुगू',
          'tamil': 'तामिल',
          'gujarati': 'गुजराती',
          'app_language': 'ऐप भाषा',
          'set_language': 'भाषा सेट करें',
          //AddDetailsView
          'add_details': 'विवरण जोड़ें',
          'personal_Details': 'व्यक्तिगत विवरण',
          'vehicle_Details': 'वाहन की सूचना',
          'documents': 'दस्तावेज़',
          'bank_Details': 'बैंक विवरण',
          'i_Agree_to_The ': 'मैं इसके लिए सहमत हूँ ',
          'terms_&_conditions': 'नियम एवं शर्तें',
          'next': 'Next',
          //VehicleRegistration
          'vehicle_registration_card_(RC)': 'वाहन पंजीकरण कार्ड (आरसी)',
          'upload_your_vehicle_registration_card_(RC)':
              'अपना वाहन पंजीकरण कार्ड (आरसी) अपलोड करें',
          'front_side': 'सामने की ओर',
          "camera": "कैमरा",
          "gallery": "गेलरी",
          'back_side': 'पीछे की ओर',
          'rC_number': 'आरसी नंबर',
          'rC_Number_Cant_Be_Empty': 'आरसी नंबर खाली नहीं हो सकता',
          'rC_Number_Must_be_Minimum_10_Characters':
              'आरसी नंबर कम से कम 10 कैरेक्टर का होना चाहिए',
          'enter_rC_number': 'आरसी नंबर दर्ज करें',
          'save': 'बचाना',
//TakeYourSelfie
          'add_your_selfie': 'अपनी सेल्फी जोड़ेंe',
          'take_your_selfie': 'अपनी सेल्फी लो',
          'we_Use_Your_Selfie_To_Compare_With_Your_id':
              'हम आपकी आईडी के साथ तुलना करने के लिए आपकी सेल्फी का उपयोग करते हैं',
          'good_Lighting': 'अच्छी रोशनी',
          'make_Sure_You_Are_In_A_Well_Lit_Area_And_Both_Ears_Are_Uncovered ':
              'सुनिश्चित करें कि आप एक अच्छी तरह से रोशनी वाले क्षेत्र में हैं और दोनों कान खुले हुए हैं ',
          'look_Straight': 'सीधे देखना',
          'hold_Your_Phone_At_Eye_Level_And_Looks_Straight_To_The_Camera':
              'अपने फ़ोन को आंखों के स्तर पर पकड़ें और सीधे कैमरे की ओर देखें',
          'open_camera': 'कैमरा खोलो',
          'male': 'पुरुष',
          'female': 'महिला',
          'Others': 'अन्य',
          'month/date/year': 'माह/तारीख/वर्ष',
          'enter_Valid_Date': 'मान्य तिथि दर्ज करें',
          'enter_Date_In_Valid_Range': 'दिनांक मान्य श्रेणी में दर्ज करें',
          'personal_details': 'व्यक्तिगत विवरण',
          'first_name': 'पहला नाम',
          'firstName_Cant_Be_Empty': 'पहला नाम खाली नहीं हो सकता',
          'firstName_Must_Be_Minimum_1_Digits':
              'पहला नाम कम से कम 1 अंक का होना चाहिए',
          'full_name': 'पूरा नाम',
          'last_name': 'उपनाम',
          'lastName_Cant_Be_Empty': 'अंतिम नाम खाली नहीं हो सकता',
          'lastName_Must_Be_Minimum_1_Digits':
              'लास्टनाम कम से कम 1 अंक का होना चाहिए',
          'enter_mail_id': 'मेल आईडी दर्ज करें',
          'e-mail_Address': 'मेल पता',
          "invalid_email": "अमान्य ईमेल",
          'enter_date_Of_birth': 'जन्म तारीख दर्ज करें',
          'date_Of_Birth': 'जन्म की तारीख',
          'home_address': 'घर का पता',
          'home_addres_Cant_Be_Empty': 'घर का पता खाली नहीं हो सकता',
          'home_addres_Must_Be_Minimum_1_Digits':
              'घर का पता न्यूनतम 1 अंक का होना चाहिए',
          'enter_home_address': 'घर का पता दर्ज करें',
          'city': 'शहर',
          'city_Cant_Be_Empty': 'शहर खाली नहीं हो सकता',
          'city_Must_Be_Minimum_1_Digits': 'शहर न्यूनतम 1 अंक का होना चाहिए',
          'enter_City': 'शहर का नाम दर्ज करें',
          'state ': 'राज्य ',
          'state_Cant_Be_Empty': 'राज्य का नाम खाली नहीं हो सकता',
          'state_Must_Be_Minimum_1_Digits':
              'राज्य कम से कम 1 अंक का होना चाहिए',
          'enter_State': 'राज्य का नाम  दर्ज करें',
          'pincode': 'पिन कोड',
          'pincode_Cant_Be_Empty': 'पिनकोड खाली नहीं हो सकता',
          'pincode_Must_Be_Minimum_6_Digits':
              'पिनकोड कम से कम 6 अंकों का होना चाहिए',
          'enter_Pincode': 'पिनकोड दर्ज करें',
          //PanCard
          'pAN_card': 'पैन कार्ड',
          'upload_your_pAN_card': 'अपना पैन कार्ड अपलोड करें',
          'pAN_number': 'PAN Number',
          'pAN_Number_Can_Not_Be_Empty.': 'पैन नंबर खाली नहीं हो सकता.',
          'enter_pAN_number': 'पैन नंबर दर्ज करें',
          //VechileSelection
          'job_details': 'नौकरी विवरण',
          'which_Vehicle_Will_You_Use?': 'आप कौन सा वाहन प्रयोग करेंगे?',
          'vehicle_type': 'वाहन का प्रकार',
          'electric': 'विद्युत',
          'non-electric': 'गैर विद्युत',
          //DrivingLicense
          'driving_license': 'ड्राइविंग लाइसेंस',
          'upload_your_driving_license': 'अपना ड्राइविंग लाइसेंस अपलोड करें',
          'learner’s_License_Not_Allowed.': 'लर्नर लाइसेंस की अनुमति नहीं है.',
          'driving_license_number': 'ड्राइविंग लाइसेंस संख्या',
          'driving_License_Cant_Be_Empty':
              'ड्राइविंग लाइसेंस खाली नहीं हो सकता',
          'driving_License_Must_Be_Minimum_16_Characters':
              'ड्राइविंग लाइसेंस न्यूनतम 16 वर्णों का होना चाहिए',
          'expiry_date': 'समाप्ति तिथि',
//Documents
          'upload_All_documents,_required_For_Your_Verification.':
              'आपके सत्यापन के लिए आवश्यक सभी दस्तावेज़ अपलोड करें.',
          'aadhar_card': 'आधार कार्ड',
          //Demo
          'membership_For_45_Days': '45 दिनों के लिए सदस्यता',
          'free': 'मुफ़्त',
          '10_Days_Left': '10 दिन शेष',
//BankDetails
          'enter_A_Valid_iFSC_Number.': 'एक मान्य IFSC नंबर दर्ज करें.',
          'add_your_bank_details': 'अपना बैंक विवरण जोड़ें',
          'account_holder_name': 'खाता धारक का नाम',
          'enter_bankholder_name_Cant_Be_Empty':
              'बैंकधारक का नाम दर्ज करें खाली नहीं हो सकता',
          'enter_bankholder_name_Must_Be_Minimum_3_Characters':
              'बैंकधारक का नाम दर्ज करें कम से कम 3 अक्षर होने चाहिए',
          'enter_Bank_Holder_Name': 'बैंक धारक का नाम दर्ज करें',
          'account_Number': 'Account number',
          'account_Number_Cant_Be_Empty': 'खाता संख्या खाली नहीं हो सकती',
          'account_Number_Must_Be_9_To_17_Digits':
              'खाता संख्या 9 से 17 अंकों की होनी चाहिए',
          'iFSC_Code': 'IFSC कोड',
          'ifsc_Code_Can_Not_Be_Empty.': 'IFSC कोड खाली नहीं हो सकता.',
          'enter_Valid_Ifsc_Code': 'वैध आईएफएससी कोड दर्ज करें',
          'enter_Ifsc_Code': 'IFSC कोड दर्ज करें',
          'bank_name': 'बैंक का नाम',
          'bank_Name_Can_Not_Be_Empty.': 'बैंक का नाम खाली नहीं हो सकता.',
          'enter_bank_Name': 'बैंक का नाम दर्ज करें',
          'add_your_uPI': 'आपका जोड़ें UPI',
          'uPI': 'UPI',
          'uPI_Id_Can_Not_Be_Empty.': 'UPI ID खाली नहीं हो सकती.',
//AdharCard
          'upload_Your_Aadhar_Card': 'अपना आधार कार्ड अपलोड करें',
          'aadhar_Number': 'आधार संख्या',
          'aadhar_number_Cant_Be_Empty': 'आधार संख्या खाली नहीं हो सकती',
          'aadhar_number_Must_Be_12_Digits':
              'आधार संख्या 12 अंकों की होनी चाहिए',
//LoginPageView
          "login ": "लॉग इन करें ",
          "mobile_number ": "मोबाइल नंबर ",
          "mobile_Number_Can't_Be_Empty": "मोबाइल नंबर खाली नहीं हो सकता",
          "mobile_Number_Must_Be_10_Digits":
              "मोबाइल नंबर 10 अंकों का होना चाहिए",
          'enter_Mobile_Number': 'मोबाइल नंबर दर्ज करें',
          'login': 'लॉग इन करें',
//NotificationView
          'notifications': 'सूचनाएं',
          "clear": "साफ़ करे",
          "start_your_first_ride_with_winter_Offers.":
              "विंटर ऑफ़र के साथ अपनी पहली राइड शुरू करें.",
          "happy_winter_offer_On_Your_first_ride,_enjoy_ride_With_best_offers._check_It_Now":
              "आपकी पहली राइड पर हैप्पी विंटर ऑफर, बेस्ट ऑफर्स के साथ राइड का मजा लें। अब यह जांच करें",
          "2_Days_Ago": "2 दिन पहले",
//OrderCompletedView
          'ride_completed': 'सवारी पूरी हुई',
          'great_job!': 'अच्छा काम!',
          'ride_successfully_completed': 'सवारी सफलतापूर्वक पूरी हुई',
          'total_Distance : ': 'कुल दूरी : ',
          'total_Ride_Time : ': 'कुल सवारी का समय : ',
          'amount : ': 'राशि : ',
          'ready_for_next_order': 'अगले आदेश के लिए तैयार',
          //ProfileReview
          ' rejected': ' अस्वीकार कर दिया',
          'please_Contact_Admin_Support':
              'कृपया व्यवस्थापक समर्थन से संपर्क करें',
          "  your_Profile_Is_Under_Reviewing\nprocess._Please_Wait_2_To_4_Days":
              "  आपकी प्रोफ़ाइल समीक्षाधीन है\nप्रक्रियाधीन है। कृपया 2 से 4 दिन प्रतीक्षा करें",
//ReferAndEarnView
          "refer_&_earn": "उद्घृत करो और कमाएँ",
          "refer_friends": "मित्र को उद्घृत करे",
          "earn_Upto_₹100_Per_Friend_You_Invite":
              "आप जिस दोस्त को बुलाते हैं उससे ₹100 तक कमाएं",
          "my_rewards": "मेरे पुरस्कार",
          "share_Your_Invite_Code": "अपना आमंत्रण कोड साझा करें",
          "when_Your_Friends_Sign_Up_This_Referral":
              "जब आपके मित्र इस रेफरल को साइन अप करते हैं",
          "Code,_You_Can_Received_A_Free_Ride":
              "कोड, आप एक मुफ्त सवारी प्राप्त कर सकते हैं",
          'refer': 'उद्घृत करो',
//ReferalCodeView
          'hello,_skipper': 'हैलो, स्किपर',
          'your_Account_Will_Be_Registered_With_This_Mobile_Number':
              'आपका खाता इस मोबाइल नंबर के साथ पंजीकृत हो जाएगा',
          "have_a_referral_code?": "रेफरल कोड है?",
          'enter_referral_code': 'रेफरल कोड दर्ज करें',
          'referal_Code_Must_Be_5_Digits': 'रेफ़रल कोड 5 अंकों का होना चाहिए',
//ReviewsView
          'rating_&_reviews': 'रेटिंग और समीक्षा',
          "rating": "रेटिंग",

//RideHistoryView
          'ride_history': 'सवारी इतिहास',
          'today': 'आज',
          "all": "सभी",
          "completed": "पूरा हुआ",
          "rejected": "अस्वीकार कर दिया",

          //RideHistoryCard
          'online_paid ': 'ऑनलाइन भुगतान किया',
          'yesterday': 'बीता हुआ कल',
          'week': 'सप्ताह',
          'custom': 'रीति',

          'Personal_Details': 'व्यक्तिगत विवरण',
          //homepage drawer
          'earnings': 'आय',
          'order_history': 'आदेश इतिहास',
          'rating_reviews': 'रेटिंग और समीक्षा',
          'notifications': 'सूचनाएं',
          'refer_earn': 'उद्घृत करो और कमाएँ',
          //homepage earningcard
          'enable_location_to_get_nearby_rides':
              'आस-पास की सवारी प्राप्त करने के लिए स्थान सक्षम करें',
          'enable_location': 'स्थान सक्षम करें',
          'todays_earnings': 'आज की कमाई',
          'cash_collected': 'नकद एकत्रित',
          //homepage flutterripplewidget
          'go_online': 'ऑनलाइन जाओ',
          //homepage currentlyofflinecard
          'offine_message':
              'आप वर्तमान में ऑफ़लाइन हैं, कृपया\nकमाई शुरू करने के लिए ऑनलाइन जाएं',
          //homepage RoutingBooking
          'my_route_booking': 'माई रूट बुकिंग',
          //riplepage widget
          'offline': 'ऑफलाइन',
          'online': 'ऑनलाइन',
          //riplepage widget AccetedOrderCard
          'pickup': 'उठाना',
          'min_away': 'मिनट दूर',
          'reject': 'अस्वीकार',
          "accept_ride": 'सवारी स्वीकार करें',
          'arrived': 'पहुँचा',
          'complete_ride': 'पूरी सवारी',
          'ride_id:': 'सवारी आईडी:',
          'enter_otp': 'ओटीपी दर्ज करें',
          'please_ask_otp_to_the_Customer': 'कृपया ग्राहक से ओटीपी पूछें',
          'otp_length_didn\'t_match': 'ओटीपी की लंबाई मेल नहीं खाती',
          'start_ride': 'राइड शुरू करें',
          'Go_to_drop_Location': 'ड्रॉप लोकेशन पर जाएं',
          'go_to_pick_up': 'लेने जाओ',
          //earningpage
          'today’s_earning': 'आज की कमाई',
          'payout': 'भुगतान',
          'history': 'इतिहास',
          //today earning
          'rides': 'सवारी',
          'Km': 'किमी',
          'hours': 'घंटे',
          'avg_rating': 'औसत रेटिंग',
          'reject_rides': 'सवारी अस्वीकार करें',
          'today\'s_earning': 'आज की कमाई',
          "order_id :": 'आदेश ID :',
          //payout
          'online_collection': 'ऑनलाइन संग्रह',
          'amount_to_Pay': 'भुगतान की जाने वाली राशि',
          'total_collected_cash': 'कुल एकत्रित नकद',
          'tax_charges': 'कर प्रभार',
          'gst_payable_to_the_government.': 'सरकार को देय जी.एस.टी.',
          'platform_charge': 'प्लेटफॉर्म चार्ज',
          'Daily_one_time_fee.': 'दैनिक एक बार शुल्क.',
          'transaction_fees': 'लेनदेन शुल्क',
          'Towards_unavoidable_costs_for\noperating_the_app':
              'ऐप को संचालित करने के लिए अपरिहार्य लागतों की ओर',
          'payable_amount': 'भुगतान योग्य राशि',
          'maximum_payout_limit_is ': 'अधिकतम भुगतान सीमा है ',
          'please_pay_below-charges': 'कृपया नीचे शुल्क का भुगतान करें',
          'Immediately': 'तुरंत',
          'total_earnings': 'कुल आय',
          'rides)': 'सवारी)',
          //ride earning details
          'ride_details': 'सवारी विवरण',
          'time_fare ': 'समय किराया ',
          'distance_fare ': 'दूरी किराया ',
          'surge': 'तरंग',
          'your_earnings': 'आपकी कमाई',
          // ride details
          'ride_id': 'सवारी आईडी',
          'date': 'तारीख',
          'distance': 'दूरी',
          'Mins': 'मिनट',
          'duration': 'अवधि',
          'pickup_location': 'उठाने की जगह',
          'drop_location': 'ड्रॉप स्थान',
          //ride details-total rechargrcard
          'ride_amount': 'सवारी राशि',
          'amount_pay_to_company': 'कंपनी को राशि का भुगतान',
          //profile
          'profile': 'प्रोफ़ाइल',

          'vehicle': 'वाहन',
          'bank_details': 'बैंक विवरण',
          //profile- personaldetails
          'FirstName_cant_be_empty': 'पहला नाम खाली नहीं हो सकता',
          'FirstName_must_be_minimum_1_digits':
              'पहला नाम कम से कम 1 अंक का होना चाहिए',
          'mobile_number': 'मोबाइल नंबर',
          'mobile_number_cant_be_empty': 'मोबाइल नंबर खाली नहीं हो सकता',
          'mobile_number_must_be_minimum_10_digits':
              'मोबाइल नंबर कम से कम 10 अंकों का होना चाहिए',
          'email': 'ईमेल',
          'gender': 'लिंग',
          'others': 'अन्य',
          //profile-liceience
          'upload_rc_back_side': 'आरसी बैक साइड अपलोड करें',
          'please_enter_license_number': 'कृपया लाइसेंस संख्या दर्ज करें',
          'please_enter_valid_driving_license':
              'कृपया वैध ड्राइविंग लाइसेंस दर्ज करें',
          'update': 'अद्यतन',

          'please_enter_rc_number': 'कृपया आरसी संख्या दर्ज करें',
          'please_enter_valid_rc_number': 'कृपया मान्य आरसी संख्या दर्ज करें',
          //profile-aadharcard

          //profile-pancard
          'please_enter_pancard_number': 'कृपया पैनकार्ड संख्या दर्ज करें',
          'please_enter_valid_pancard_number':
              'कृपया मान्य पैनकार्ड संख्या दर्ज करें',

          //profile-bandetails
          'ifsc': 'आईएफ़एससी',
          'please_enter_ifsc_number': 'कृपया IFSC नंबर दर्ज करें',
          'please_enter_valid_ifsc_number': 'कृपया मान्य IFSC नंबर दर्ज करें',
          'please_enter_upi_number': 'कृपया यूपीआई नंबर दर्ज करें',
          'Please_enter_valid_upi_number': 'कृपया मान्य यूपीआई नंबर दर्ज करें',
        },
        'kn_in': {
          //support
          "support": "ಬೆಂಬಲ",
          "easy_go": "ಸುಲಭವಾಗಿ ಹೋಗು",
          "customer_support": "ಗ್ರಾಹಕ ಬೆಂಬಲ",
          "chat": "ಚಾಟ್ ಮಾಡಿ",
          //ride info
          "ride_info": "ಸವಾರಿ ಮಾಹಿತಿ",
          'ride_id: ': 'ರೈಡ್ ಐಡಿ: ',
          //rideDetails
          'cancel_ride': 'ರೈಡ್ ರದ್ದುಮಾಡಿ',
          //payNow
          'please_Pay_The_Amount\nBefore_Contuning':
              'ಮುಂದುವರಿಸುವ ಮೊದಲು ದಯವಿಟ್ಟು ಮೊತ್ತವನ್ನು ಪಾವತಿಸಿ',
          'payout_details': 'ಪಾವತಿ ವಿವರಗಳು',
          'pay_now': 'ಈಗ ಪಾವತಿಸಿ',
          'skip': 'ಬಿಟ್ಟುಬಿಡಿ',
          'payment_under_process': 'ಪ್ರಕ್ರಿಯೆಯ ಅಡಿಯಲ್ಲಿ ಪಾವತಿ',
          'please_Don’t_Go_Back_Or_Refresh_The_Page\nas_We_Are_Processing_Your_Payment':
              'ನಿಮ್ಮ ಪಾವತಿಯನ್ನು ನಾವು ಪ್ರಕ್ರಿಯೆಗೊಳಿಸುತ್ತಿರುವ ಕಾರಣ ದಯವಿಟ್ಟು ಹಿಂತಿರುಗಬೇಡಿ ಅಥವಾ ಪುಟವನ್ನು ರಿಫ್ರೆಶ್ ಮಾಡಬೇಡಿ',
          //customerSupport
          'please_Select_Reason_For_Cancel_ride':
              'ದಯವಿಟ್ಟು ರೈಡ್ ರದ್ದುಗೊಳಿಸಲು ಕಾರಣವನ್ನು ಆಯ್ಕೆಮಾಡಿ',
          'unsafe_Pickup_area': 'ಅಸುರಕ್ಷಿತ ಪಿಕಪ್ ಪ್ರದೇಶ',
          'unable_To_Swipe_Arrived': 'ಸ್ವೈಪ್ ಮಾಡಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ ಬಂದಿತು',
          'wrong_Pickup_Location': 'ತಪ್ಪಾದ ಪಿಕಪ್ ಸ್ಥಳ',
          'long_Pickup': 'ದೀರ್ಘ ಪಿಕಪ್',
          'heavy_Traffic': 'ಭಾರೀ ಟ್ರಾಫಿಕ್',
          //BackCollectedButton
          'back': 'ಹಿಂದೆ',
          //RateCard
          'rate_card': 'ದರದ ಚೀಟಿ',
          'monday_To_sunday': 'ಸೋಮವಾರದಿಂದ ಭಾನುವಾರದವರೆಗೆ',
          'maximum_Payout_Limit_Is_₹500': 'ಗರಿಷ್ಠ ಪಾವತಿ ಮಿತಿ ₹500',
          "bike": "ಬೈಕ್",
          "auto": "ಆಟೋ",
          //BikeInfo
          'base_Fare': 'ಮೂಲ ದರ',
          'minimum_Fare': 'ಕನಿಷ್ಠ ದರ',
          'earning_Per_km': 'ಪ್ರತಿ ಕಿ.ಮೀ.ಗೆ ಗಳಿಕೆ',
          'price_Per_Minute': 'ಪ್ರತಿ ನಿಮಿಷಕ್ಕೆ ಬೆಲೆ',
          'platform_Charge': 'ಪ್ಲಾಟ್‌ಫಾರ್ಮ್ ಶುಲ್ಕ',
          'pickup_extra_km_Fare_Post_2km':
              'ಪಿಕಪ್ ಹೆಚ್ಚುವರಿ ಕಿಮೀ ದರದ ನಂತರ 2 ಕಿಮೀ',
          '(Max_10)': '(ಗರಿಷ್ಠ 10)',
          'every_Km_Till_8km': '8 ಕಿಮೀ ವರೆಗೆ ಪ್ರತಿ ಕಿ.ಮೀ',
          'Per_Km ': 'ಪ್ರತಿ ಕಿ.ಮೀ ',
          'every_Km_Above_8km': '8 ಕಿಮೀ ಮೇಲಿನ ಪ್ರತಿ ಕಿ.ಮೀ',
          //CollectPaymentView
          'collect_payment': 'ಪಾವತಿಯನ್ನು ಸಂಗ್ರಹಿಸಿ',
          'ride_iD: ': 'ರೈಡ್ ಐಡಿ: ',
          "collect_amount": "ಮೊತ್ತವನ್ನು ಸಂಗ್ರಹಿಸಿ",
          'generate_qR_code': 'QR ಕೋಡ್ ಅನ್ನು ರಚಿಸಿ',
          'or': 'ಅಥವಾ',
          'collect_cash': 'ನಗದು ಸಂಗ್ರಹಿಸಿ',
          //CollectCash
          'collect_Cash_Form_The_Customer.': 'ಗ್ರಾಹಕರಿಂದ ಹಣವನ್ನು ಸಂಗ್ರಹಿಸಿ.',
          'collected': 'ಸಂಗ್ರಹಿಸಲಾಗಿದೆ',
          //ChooseAppLanguageView
          'english': 'ಆಂಗ್ಲ',
          'hindi': 'ಹಿಂದಿ',
          'kannada': 'ಕನ್ನಡ',
          'telugu': 'ತೆಲುಗು',
          'tamil': 'ತಮಿಳು',
          'gujarati': 'ಗುಜರಾತಿ',
          'app_language': 'ಅಪ್ಲಿಕೇಶನ್ ಭಾಷೆ',
          'set_language': 'ಭಾಷೆಯನ್ನು ಹೊಂದಿಸಿ',
          //AddDetailsView
          'add_details': 'ವಿವರಗಳನ್ನು ಸೇರಿಸಿ',
          'personal_Details': 'ವೈಯಕ್ತಿಕ ವಿವರಗಳು',
          'vehicle_Details': 'ವಾಹನದ ವಿವರಗಳು',
          'documents': 'ದಾಖಲೆಗಳು',
          'bank_Details': 'ಬ್ಯಾಂಕ್ ವಿವರಗಳು',
          'i_Agree_to_The ': 'ನಾನು ಒಪ್ಪುತ್ತೇನೆ ',
          'terms_&_conditions': 'ನಿಯಮ ಮತ್ತು ಶರತ್ತುಗಳು',
          'next': 'ಮುಂದೆ',
          //VehicleRegistration
          'vehicle_registration_card_(RC)': 'ವಾಹನ ನೋಂದಣಿ ಕಾರ್ಡ್ (RC)',
          'upload_your_vehicle_registration_card_(RC)':
              'ನಿಮ್ಮ ವಾಹನ ನೋಂದಣಿ ಕಾರ್ಡ್ (RC) ಅಪ್‌ಲೋಡ್ ಮಾಡಿ',
          'front_side': 'ಮುಂಭಾಗದ ಭಾಗ',
          "camera": "ಕ್ಯಾಮೆರಾ",
          "gallery": "ಗ್ಯಾಲರಿ",
          'back_side': 'ಬ್ಯಾಕ್ ಸೈಡ್',
          'rC_number': 'RC ಸಂಖ್ಯೆ',
          'rC_Number_Cant_Be_Empty': 'ಆರ್‌ಸಿ ಸಂಖ್ಯೆ ಖಾಲಿ ಇರುವಂತಿಲ್ಲ',
          'rC_Number_Must_be_Minimum_10_Characters':
              'RC ಸಂಖ್ಯೆಯು ಕನಿಷ್ಠ 10 ಅಕ್ಷರಗಳಾಗಿರಬೇಕು',
          'enter_rC_number': 'RC ಸಂಖ್ಯೆಯನ್ನು ನಮೂದಿಸಿ',
          'save': 'ಉಳಿಸಿ',
//TakeYourSelfie
          'add_your_selfie': 'ನಿಮ್ಮ ಸೆಲ್ಫಿ ಸೇರಿಸಿ',
          'take_your_selfie': 'ನಿಮ್ಮ ಸೆಲ್ಫಿ ತೆಗೆದುಕೊಳ್ಳಿ',
          'we_Use_Your_Selfie_To_Compare_With_Your_id':
              'ನಿಮ್ಮ ಐಡಿಯೊಂದಿಗೆ ಹೋಲಿಸಲು ನಾವು ನಿಮ್ಮ ಸೆಲ್ಫಿಯನ್ನು ಬಳಸುತ್ತೇವೆ',
          'good_Lighting': 'ಉತ್ತಮ ಬೆಳಕು',
          'make_Sure_You_Are_In_A_Well_Lit_Area_And_Both_Ears_Are_Uncovered ':
              'ನೀವು ಚೆನ್ನಾಗಿ ಬೆಳಗಿದ ಪ್ರದೇಶದಲ್ಲಿದ್ದೀರೆಂದು ಖಚಿತಪಡಿಸಿಕೊಳ್ಳಿ ಮತ್ತು ಎರಡೂ ಕಿವಿಗಳು ತೆರೆದಿರುತ್ತವೆ ',
          'look_Straight': 'ನೇರವಾಗಿ ನೋಡಿ',
          'hold_Your_Phone_At_Eye_Level_And_Looks_Straight_To_The_Camera':
              'ನಿಮ್ಮ ಫೋನ್ ಅನ್ನು ಕಣ್ಣಿನ ಮಟ್ಟದಲ್ಲಿ ಹಿಡಿದುಕೊಳ್ಳಿ ಮತ್ತು ನೇರವಾಗಿ ಕ್ಯಾಮೆರಾದತ್ತ ನೋಡಿ',
          'open_camera': 'ಕ್ಯಾಮರಾ ತೆರೆಯಿರಿ',
          'male': 'ಪುರುಷ',
          'female': 'ಹೆಣ್ಣು',
          'Others': 'ಇತರರು',
          'month/date/year': 'ತಿಂಗಳು/ದಿನಾಂಕ/ವರ್ಷ',
          'enter_Valid_Date': 'ಮಾನ್ಯವಾದ ದಿನಾಂಕವನ್ನು ನಮೂದಿಸಿ',
          'enter_Date_In_Valid_Range': 'ಮಾನ್ಯ ವ್ಯಾಪ್ತಿಯಲ್ಲಿ ದಿನಾಂಕ ನಮೂದಿಸಿ',
          'personal_details': 'ವೈಯಕ್ತಿಕ ವಿವರಗಳು',
          'first_name': 'ಮೊದಲ ಹೆಸರು',
          'firstName_Cant_Be_Empty': 'ಮೊದಲ ಹೆಸರು ಖಾಲಿ ಇರುವಂತಿಲ್ಲ',
          'firstName_Must_Be_Minimum_1_Digits':
              'ಮೊದಲ ಹೆಸರು ಕನಿಷ್ಠ 1 ಅಂಕೆಗಳಾಗಿರಬೇಕು',
          'full_name': 'ಪೂರ್ಣ ಹೆಸರು',
          'last_name': 'ಕೊನೆಯ ಹೆಸರು',
          'lastName_Cant_Be_Empty': 'ಕೊನೆಯ ಹೆಸರು ಖಾಲಿ ಇರುವಂತಿಲ್ಲ',
          'lastName_Must_Be_Minimum_1_Digits':
              'ಕೊನೆಯ ಹೆಸರು ಕನಿಷ್ಠ 1 ಅಂಕೆಗಳಾಗಿರಬೇಕು',
          'enter_mail_id': 'ಮೇಲ್ ಐಡಿ ನಮೂದಿಸಿ',
          'e-mail_Address': 'ಇಮೇಲ್ ವಿಳಾಸ',
          "invalid_email": "ಅಮಾನ್ಯ ಇಮೇಲ್",
          'enter_date_Of_birth': 'ಹುಟ್ಟಿದ ದಿನಾಂಕವನ್ನು ನಮೂದಿಸಿ',
          'date_Of_Birth': 'ಹುಟ್ತಿದ ದಿನ',
          'home_address': 'ಮನೆ ವಿಳಾಸ',
          'home_addres_Cant_Be_Empty': 'ಮನೆ ವಿಳಾಸಗಳು ಖಾಲಿ ಇರುವಂತಿಲ್ಲ',
          'home_addres_Must_Be_Minimum_1_Digits':
              'ಮನೆಯ ವಿಳಾಸಗಳು ಕನಿಷ್ಠ 1 ಅಂಕೆಗಳಾಗಿರಬೇಕು',
          'enter_home_address': 'ಮನೆಯ ವಿಳಾಸವನ್ನು ನಮೂದಿಸಿ',
          'city': 'ನಗರ',
          'city_Cant_Be_Empty': 'ನಗರ ಖಾಲಿ ಇರುವಂತಿಲ್ಲ',
          'city_Must_Be_Minimum_1_Digits': 'ನಗರವು ಕನಿಷ್ಠ 1 ಅಂಕೆಗಳಾಗಿರಬೇಕು',
          'enter_City': 'ನಗರವನ್ನು ನಮೂದಿಸಿ',
          'state ': 'ರಾಜ್ಯ ',
          'state_Cant_Be_Empty': 'ರಾಜ್ಯ ಖಾಲಿ ಇರುವಂತಿಲ್ಲ',
          'state_Must_Be_Minimum_1_Digits': 'ರಾಜ್ಯವು ಕನಿಷ್ಠ 1 ಅಂಕೆಗಳಾಗಿರಬೇಕು',
          'enter_State': 'ರಾಜ್ಯವನ್ನು ನಮೂದಿಸಿ',
          'pincode': 'ಪಿನ್‌ಕೋಡ್',
          'pincode_Cant_Be_Empty': 'ಪಿನ್‌ಕೋಡ್ ಖಾಲಿ ಇರುವಂತಿಲ್ಲ',
          'pincode_Must_Be_Minimum_6_Digits':
              'ಪಿನ್‌ಕೋಡ್ ಕನಿಷ್ಠ 6 ಅಂಕಿಗಳಾಗಿರಬೇಕು',
          'enter_Pincode': 'ಪಿನ್‌ಕೋಡ್ ನಮೂದಿಸಿ',
          //PanCard
          'pAN_card': 'ಪ್ಯಾನ್ ಕಾರ್ಡ್',
          'upload_your_pAN_card': 'ನಿಮ್ಮ ಪ್ಯಾನ್ ಕಾರ್ಡ್ ಅನ್ನು ಅಪ್ಲೋಡ್ ಮಾಡಿ',
          'pAN_number': 'ಪ್ಯಾನ್ ಸಂಖ್ಯೆ',
          'pAN_Number_Can_Not_Be_Empty.': 'ಪ್ಯಾನ್ ಸಂಖ್ಯೆ ಖಾಲಿ ಇರುವಂತಿಲ್ಲ.',
          'enter_pAN_number': 'PAN ಸಂಖ್ಯೆಯನ್ನು ನಮೂದಿಸಿ',
          //VechileSelection
          'job_details': 'ಉದ್ಯೋಗದ ವಿವರಗಳು',
          'which_Vehicle_Will_You_Use?': 'ನೀವು ಯಾವ ವಾಹನವನ್ನು ಬಳಸುತ್ತೀರಿ?',
          'vehicle_type': 'ವಾಹನದ ಪ್ರಕಾರ',
          'electric': 'ಎಲೆಕ್ಟ್ರಿಕ್',
          'non-electric': 'ವಿದ್ಯುತ್ ಅಲ್ಲದ',
          //DrivingLicense
          'driving_license': 'ಚಾಲನಾ ಪರವಾನಿಗೆ',
          'upload_your_driving_license':
              'ನಿಮ್ಮ ಚಾಲನಾ ಪರವಾನಗಿಯನ್ನು ಅಪ್‌ಲೋಡ್ ಮಾಡಿ',
          'learner’s_License_Not_Allowed.':
              'ಕಲಿಕಾ ಪರವಾನಗಿಯನ್ನು ಅನುಮತಿಸಲಾಗುವುದಿಲ್ಲ.',
          'driving_license_number': 'ಚಾಲನಾ ಪರವಾನಗಿ ಸಂಖ್ಯೆ',
          'driving_License_Cant_Be_Empty': 'ಚಾಲನಾ ಪರವಾನಗಿ ಖಾಲಿ ಇರುವಂತಿಲ್ಲ',
          'driving_License_Must_Be_Minimum_16_Characters':
              'ಚಾಲನಾ ಪರವಾನಗಿ ಕನಿಷ್ಠ 16 ಅಕ್ಷರಗಳಾಗಿರಬೇಕು',
          'expiry_date': 'ಗಡುವು ದಿನಾಂಕ',
//Documents
          'upload_All_documents,_required_For_Your_Verification.':
              'ನಿಮ್ಮ ಪರಿಶೀಲನೆಗೆ ಅಗತ್ಯವಿರುವ ಎಲ್ಲಾ ಡಾಕ್ಯುಮೆಂಟ್‌ಗಳನ್ನು ಅಪ್‌ಲೋಡ್ ಮಾಡಿ.',
          'aadhar_card': 'ಆಧಾರ್ ಕಾರ್ಡ್',
          //Demo
          'membership_For_45_Days': '45 ದಿನಗಳವರೆಗೆ ಸದಸ್ಯತ್ವ',
          'free': 'ಉಚಿತ',
          '10_Days_Left': '10 ದಿನಗಳು ಉಳಿದಿವೆ',
//BankDetails
          'enter_A_Valid_iFSC_Number.': 'Enter a valid IFSC number.',
          'add_your_bank_details': 'ನಿಮ್ಮ ಬ್ಯಾಂಕ್ ವಿವರಗಳನ್ನು ಸೇರಿಸಿ',
          'account_holder_name': 'ಖಾತೆದಾರನ ಹೆಸರು',
          'enter_bankholder_name_Cant_Be_Empty':
              'ಬ್ಯಾಂಕ್ ಹೋಲ್ಡರ್ ಹೆಸರನ್ನು ನಮೂದಿಸಿ ಖಾಲಿ ಇರುವಂತಿಲ್ಲ',
          'enter_bankholder_name_Must_Be_Minimum_3_Characters':
              'ಬ್ಯಾಂಕ್ ಹೋಲ್ಡರ್ ಹೆಸರನ್ನು ನಮೂದಿಸಿ ಕನಿಷ್ಠ 3 ಅಕ್ಷರಗಳಿರಬೇಕು',
          'enter_Bank_Holder_Name': 'ಬ್ಯಾಂಕ್ ಹೋಲ್ಡರ್ ಹೆಸರನ್ನು ನಮೂದಿಸಿ',
          'account_Number': 'ಖಾತೆ ಸಂಖ್ಯೆ',
          'account_Number_Cant_Be_Empty': 'ಖಾತೆ ಸಂಖ್ಯೆ ಖಾಲಿ ಇರುವಂತಿಲ್ಲ',
          'account_Number_Must_Be_9_To_17_Digits':
              'ಖಾತೆ ಸಂಖ್ಯೆ 9 ರಿಂದ 17 ಅಂಕಿಗಳಾಗಿರಬೇಕು',
          'iFSC_Code': 'IFSC ಕೋಡ್',
          'ifsc_Code_Can_Not_Be_Empty.': 'Ifsc ಕೋಡ್ ಖಾಲಿ ಇರುವಂತಿಲ್ಲ.',
          'enter_Valid_Ifsc_Code': 'ಮಾನ್ಯವಾದ ifsc ಕೋಡ್ ಅನ್ನು ನಮೂದಿಸಿ',
          'enter_Ifsc_Code': 'ifsc ಕೋಡ್ ನಮೂದಿಸಿ',
          'bank_name': 'ಬ್ಯಾಂಕ್ ಹೆಸರು',
          'bank_Name_Can_Not_Be_Empty.': 'ಬ್ಯಾಂಕ್ ಹೆಸರು ಖಾಲಿ ಇರುವಂತಿಲ್ಲ.',
          'enter_bank_Name': 'ಬ್ಯಾಂಕ್ ಹೆಸರನ್ನು ನಮೂದಿಸಿ',
          'add_your_uPI': 'ನಿಮ್ಮ UPI ಸೇರಿಸಿ',
          'uPI': 'UPI',
          'uPI_Id_Can_Not_Be_Empty.': 'UPI ಐಡಿ ಖಾಲಿ ಇರುವಂತಿಲ್ಲ.',
//AdharCard
          'upload_Your_Aadhar_Card': 'ನಿಮ್ಮ ಆಧಾರ್ ಕಾರ್ಡ್ ಅನ್ನು ಅಪ್ಲೋಡ್ ಮಾಡಿ',
          'aadhar_Number': 'ಆಧಾರ್ ಸಂಖ್ಯೆ',
          'aadhar_number_Cant_Be_Empty': 'ಆಧಾರ್ ಸಂಖ್ಯೆ ಖಾಲಿ ಇರುವಂತಿಲ್ಲ',
          'aadhar_number_Must_Be_12_Digits': 'ಆಧಾರ್ ಸಂಖ್ಯೆಯು 12 ಅಂಕೆಗಳಾಗಿರಬೇಕು',
//LoginPageView
          "login ": "ಲಾಗಿನ್ ಮಾಡಿ ",
          "mobile_number ": "ಮೊಬೈಲ್ ನಂಬರ ",
          "mobile_Number_Can't_Be_Empty": "ಮೊಬೈಲ್ ಸಂಖ್ಯೆ ಖಾಲಿ ಇರುವಂತಿಲ್ಲ",
          "mobile_Number_Must_Be_10_Digits": "ಮೊಬೈಲ್ ಸಂಖ್ಯೆ 10 ಅಂಕಿಗಳಾಗಿರಬೇಕು",
          'enter_Mobile_Number': 'ಮೊಬೈಲ್ ಸಂಖ್ಯೆಯನ್ನು ನಮೂದಿಸಿ',
          'login': 'ಲಾಗಿನ್ ಮಾಡಿ',
//NotificationView
          'notifications': 'ಅಧಿಸೂಚನೆಗಳು',
          "clear": "ಸ್ಪಷ್ಟ",
          "start_your_first_ride_with_winter_Offers.":
              "ಚಳಿಗಾಲದ ಕೊಡುಗೆಗಳೊಂದಿಗೆ ನಿಮ್ಮ ಮೊದಲ ಸವಾರಿಯನ್ನು ಪ್ರಾರಂಭಿಸಿ.",
          "happy_winter_offer_On_Your_first_ride,_enjoy_ride_With_best_offers._check_It_Now":
              "ನಿಮ್ಮ ಮೊದಲ ರೈಡ್‌ನಲ್ಲಿ ಹ್ಯಾಪಿ ವಿಂಟರ್ ಆಫರ್, ಅತ್ಯುತ್ತಮ ಆಫರ್‌ಗಳೊಂದಿಗೆ ರೈಡ್ ಅನ್ನು ಆನಂದಿಸಿ. ಈಗ ಅದನ್ನು ಪರಿಶೀಲಿಸಿ",
          "2_Days_Ago": "2 ದಿನಗಳ ಹಿಂದೆ",
//OrderCompletedView
          'ride_completed': 'ಸವಾರಿ ಪೂರ್ಣಗೊಂಡಿದೆ',
          'great_job!': 'ಉತ್ತಮ ಕೆಲಸ!',
          'ride_successfully_completed': 'ಸವಾರಿ ಯಶಸ್ವಿಯಾಗಿ ಪೂರ್ಣಗೊಂಡಿದೆ',
          'total_Distance : ': 'ಒಟ್ಟು ದೂರ : ',
          'total_Ride_Time : ': 'ಒಟ್ಟು ಸವಾರಿ ಸಮಯ : ',
          'amount : ': 'ಮೊತ್ತ : ',
          'ready_for_next_order': 'ಮುಂದಿನ ಆದೇಶಕ್ಕೆ ಸಿದ್ಧವಾಗಿದೆ',
          //ProfileReview
          ' rejected': ' ತಿರಸ್ಕರಿಸಿದ',
          'please_Contact_Admin_Support':
              'ದಯವಿಟ್ಟು ನಿರ್ವಾಹಕ ಬೆಂಬಲವನ್ನು ಸಂಪರ್ಕಿಸಿ',
          "  your_Profile_Is_Under_Reviewing\nprocess._Please_Wait_2_To_4_Days":
              "  ನಿಮ್ಮ ಪ್ರೊಫೈಲ್ ಪರಿಶೀಲಿಸಲಾಗುತ್ತಿದೆ\nಪ್ರಕ್ರಿಯೆಯಲ್ಲಿದೆ. ದಯವಿಟ್ಟು 2 ರಿಂದ 4 ದಿನ ಕಾಯಿರಿ",
//ReferAndEarnView
          "refer_&_earn": "ಉಲ್ಲೇಖಿಸಿ ಮತ್ತು ಗಳಿಸಿ",
          "refer_friends": "ಸ್ನೇಹಿತರನ್ನು ಉಲ್ಲೇಖಿಸಿ",
          "earn_Upto_₹100_Per_Friend_You_Invite":
              "ನೀವು ಆಹ್ವಾನಿಸುವ ಪ್ರತಿ ಸ್ನೇಹಿತರಿಗೆ ₹100 ವರೆಗೆ ಗಳಿಸಿ",
          "my_rewards": "ನನ್ನ ಬಹುಮಾನಗಳು",
          "share_Your_Invite_Code": "ನಿಮ್ಮ ಆಹ್ವಾನ ಕೋಡ್ ಅನ್ನು ಹಂಚಿಕೊಳ್ಳಿ",
          "when_Your_Friends_Sign_Up_This_Referral":
              "ನಿಮ್ಮ ಸ್ನೇಹಿತರು ಈ ಉಲ್ಲೇಖವನ್ನು ಸೈನ್ ಅಪ್ ಮಾಡಿದಾಗ",
          "Code,_You_Can_Received_A_Free_Ride":
              "ಕೋಡ್, ನೀವು ಉಚಿತ ಸವಾರಿಯನ್ನು ಪಡೆಯಬಹುದು",
          'refer': 'ಉಲ್ಲೇಖಿಸಿ',
//ReferalCodeView
          'hello,_skipper': 'ಹಲೋ, ಸ್ಕಿಪ್ಪರ್',
          'your_Account_Will_Be_Registered_With_This_Mobile_Number':
              'ಈ ಮೊಬೈಲ್ ಸಂಖ್ಯೆಯೊಂದಿಗೆ ನಿಮ್ಮ ಖಾತೆಯನ್ನು ನೋಂದಾಯಿಸಲಾಗುತ್ತದೆ',
          "have_a_referral_code?": "ರೆಫರಲ್ ಕೋಡ್ ಅನ್ನು ಹೊಂದಿರಿ?",
          'enter_referral_code': 'ರೆಫರಲ್ ಕೋಡ್ ನಮೂದಿಸಿ',
          'referal_Code_Must_Be_5_Digits': 'ರೆಫರಲ್ ಕೋಡ್ 5 ಅಂಕಿಗಳಾಗಿರಬೇಕು',
//ReviewsView
          'rating_&_reviews': 'ರೇಟಿಂಗ್ ಮತ್ತು ವಿಮರ್ಶೆಗಳು',
          "rating": "ರೇಟಿಂಗ್",
          // "lorem_ipsum_Is_Simply_Dummy_Text_Of_The_Printing_And_Typesetting_Industry._lorem_ipsum_Has_Been_The_Industry's_Standard_Dummy_Text_Ever_Since_The_1500s.":
          //     "ಲೋರೆಮ್ ಇಪ್ಸಮ್ ಮುದ್ರಣ ಮತ್ತು ಟೈಪ್‌ಸೆಟ್ಟಿಂಗ್ ಉದ್ಯಮದ ನಕಲಿ ಪಠ್ಯವಾಗಿದೆ. ಲೊರೆಮ್ ಇಪ್ಸಮ್ 1500 ರ ದಶಕದಿಂದಲೂ ಉದ್ಯಮದ ಪ್ರಮಾಣಿತ ನಕಲಿ ಪಠ್ಯವಾಗಿದೆ.",
//RideHistoryView
          'ride_history': 'ಸವಾರಿ ಇತಿಹಾಸ',
          'today': 'ಇಂದು',
          "all": "ಎಲ್ಲಾ",
          "completed": "ಪೂರ್ಣಗೊಂಡಿದೆ",
          "rejected": "ತಿರಸ್ಕರಿಸಿದ",

          //RideHistoryCard
          'online_paid ': 'ಆನ್‌ಲೈನ್‌ನಲ್ಲಿ ಪಾವತಿಸಲಾಗಿದೆ ',
          'yesterday': 'ನಿನ್ನೆ',
          'week': 'ವಾರ',
          'custom': 'ಕಸ್ಟಮ್',

          'Personal_Details': 'ವೈಯಕ್ತಿಕ ವಿವರಗಳು',
          //homepage drawer
          'earnings': 'ಗಳಿಕೆ',
          'order_history': 'ಆದೇಶ ಇತಿಹಾಸ',
          'rating_reviews': 'ರೇಟಿಂಗ್ ಮತ್ತು ವಿಮರ್ಶೆಗಳು',

          'refer_earn': 'ಉಲ್ಲೇಖಿಸಿ ಮತ್ತು ಗಳಿಸಿ',
          //homepage earningcard
          'enable_location_to_get_nearby_rides':
              'ಹತ್ತಿರದ ಸವಾರಿಗಳನ್ನು ಪಡೆಯಲು ಸ್ಥಳವನ್ನು ಸಕ್ರಿಯಗೊಳಿಸಿ',
          'enable_location': 'ಸ್ಥಳವನ್ನು ಸಕ್ರಿಯಗೊಳಿಸಿ',
          'todays_earnings': 'ಇಂದಿನ ಗಳಿಕೆಗಳು',
          'cash_collected': 'ನಗದು ಸಂಗ್ರಹಿಸಲಾಗಿದೆ',
          //homepage flutterripplewidget
          'go_online': 'ಅಂತರ್ಜಾಲ ಸಂಪರ್ಕಕ್ಕೆ ಹೋಗು',
          //homepage currentlyofflinecard
          'offine_message':
              'ನೀವು ಪ್ರಸ್ತುತ ಆಫ್‌ಲೈನ್‌ನಲ್ಲಿರುವಿರಿ, ಗಳಿಕೆಯನ್ನು ಪ್ರಾರಂಭಿಸಲು ದಯವಿಟ್ಟು\nಆನ್‌ಲೈನ್‌ಗೆ ಹೋಗಿ',
          //homepage RoutingBooking
          'my_route_booking': 'ನನ್ನ ಮಾರ್ಗ ಬುಕಿಂಗ್',
          //riplepage widget
          'offline': 'ಆಫ್‌ಲೈನ್',
          'online': 'ಆನ್ಲೈನ್',
          //riplepage widget AccetedOrderCard
          'pickup': 'ಪಿಕಪ್',
          'min_away': ' ನಿಮಿಷ ದೂರ',
          'reject': 'ತಿರಸ್ಕರಿಸಿ',
          "accept_ride": 'ಸವಾರಿ ಸ್ವೀಕರಿಸಿ',
          'arrived': 'ಬಂದರು',
          'complete_ride': 'ಸಂಪೂರ್ಣ ಸವಾರಿ',
          'ride_id:': 'ರೈಡ್ ಐಡಿ:',
          'enter_otp': 'OTP ನಮೂದಿಸಿ',
          'please_ask_otp_to_the_Customer': 'ದಯವಿಟ್ಟು ಗ್ರಾಹಕರಿಗೆ OTP ಕೇಳಿ',
          'otp_length_didn\'t_match': 'OTP ಉದ್ದ ಹೊಂದಿಕೆಯಾಗುತ್ತಿಲ್ಲ',
          'start_ride': 'ರೈಡ್ ಪ್ರಾರಂಭಿಸಿ',
          'Go_to_drop_Location': 'ಡ್ರಾಪ್ ಸ್ಥಳಕ್ಕೆ ಹೋಗಿ',
          'go_to_pick_up': 'ತೆಗೆದುಕೊಳ್ಳಲು ಹೋಗಿ',
          //earningpage
          'today’s_earning': 'ಇಂದಿನ ಗಳಿಕೆ',
          'payout': 'ಪಾವತಿ',
          'history': 'ಇತಿಹಾಸ',
          //today earning
          'rides': 'ಸವಾರಿಗಳು',
          'Km': 'ಕಿ.ಮೀ',
          'hours': 'ಗಂಟೆಗಳು',
          'avg_rating': 'ಸರಾಸರಿ ರೇಟಿಂಗ್',
          'reject_rides': 'ಸವಾರಿಗಳನ್ನು ತಿರಸ್ಕರಿಸಿ',
          'today\'s_earning': 'ಇಂದಿನ ಗಳಿಕೆ',
          "order_id :": 'ಆರ್ಡರ್ ಐಡಿ :',
          //payout
          'online_collection': 'ಆನ್ಲೈನ್ ​​ಸಂಗ್ರಹ',
          'amount_to_Pay': 'ಪಾವತಿಸಬೇಕಾದ ಮೊತ್ತ',
          'total_collected_cash': 'ಒಟ್ಟು ಸಂಗ್ರಹಿಸಿದ ನಗದು',
          'tax_charges': 'ತೆರಿಗೆ ಶುಲ್ಕಗಳು',
          'gst_payable_to_the_government.': 'ಸರ್ಕಾರಕ್ಕೆ ಪಾವತಿಸಬೇಕಾದ ಜಿಎಸ್‌ಟಿ.',
          'platform_charge': 'ಪ್ಲಾಟ್‌ಫಾರ್ಮ್ ಶುಲ್ಕ',
          'outstation_rides': 'ಔಟ್ಸ್ಟಾಟಿನ್ ರೈಡ್ಸ್',
          'Daily_one_time_fee.': 'ದೈನಂದಿನ ಒಂದು ಬಾರಿ ಶುಲ್ಕ.',
          'transaction_fees': 'ವಹಿವಾಟು ಶುಲ್ಕಗಳು',
          'Towards_unavoidable_costs_for\noperating_the_app':
              'ಅಪ್ಲಿಕೇಶನ್ ಅನ್ನು ನಿರ್ವಹಿಸಲು\nಅನಿವಾರ್ಯ ವೆಚ್ಚಗಳ ಕಡೆಗೆ',
          'payable_amount': 'ಪಾವತಿಸಬೇಕಾದ ಮೊತ್ತ',
          'maximum_payout_limit_is ': 'ಗರಿಷ್ಠ ಪಾವತಿ ಮಿತಿ ',
          'please_pay_below-charges': 'ದಯವಿಟ್ಟು ಕೆಳಗಿನ ಶುಲ್ಕಗಳನ್ನು ಪಾವತಿಸಿ',
          'Immediately': 'ತಕ್ಷಣವೇ',
          'total_earnings': 'ಒಟ್ಟು ಗಳಿಕೆಗಳು',
          'rides)': 'ಸವಾರಿಗಳು)',
          //ride earning details
          'ride_details': 'ಸವಾರಿ ವಿವರಗಳು',
          'time_fare ': 'ಸಮಯದ ಶುಲ್ಕ ',
          'distance_fare ': 'ದೂರದ ದರ ',
          'surge': 'ಉಲ್ಬಣ',
          'your_earnings': 'ನಿಮ್ಮ ಗಳಿಕೆಗಳು',
          // ride details
          'ride_id': 'ರೈಡ್ ಐಡಿ',
          'date': 'ದಿನಾಂಕ',
          'distance': 'ದೂರ',
          'Mins': 'ನಿಮಿಷಗಳು',
          'duration': 'ಅವಧಿ',
          'pickup_location': 'ಪಿಕಪ್ ಸ್ಥಳ',
          'drop_location': 'ಡ್ರಾಪ್ ಸ್ಥಳ',
          //ride details-total rechargrcard
          'ride_amount': 'ಸವಾರಿ ಮೊತ್ತ',
          'amount_pay_to_company': 'ಕಂಪನಿಗೆ ಪಾವತಿಸುವ ಮೊತ್ತ',
          //profile
          'profile': 'ಪ್ರೊಫೈಲ್',

          'vehicle': 'ವಾಹನ',
          'bank_details': 'ಬ್ಯಾಂಕ್ ವಿವರಗಳು',
          //profile- personaldetails
          'FirstName_cant_be_empty': 'ಮೊದಲ ಹೆಸರು ಖಾಲಿ ಇರುವಂತಿಲ್ಲ',
          'FirstName_must_be_minimum_1_digits':
              'ಮೊದಲ ಹೆಸರು ಕನಿಷ್ಠ 1 ಅಂಕೆಗಳಾಗಿರಬೇಕು',
          'mobile_number': 'ಮೊಬೈಲ್ ನಂಬರ',
          'mobile_number_cant_be_empty': 'ಮೊಬೈಲ್ ಸಂಖ್ಯೆ ಖಾಲಿ ಇರುವಂತಿಲ್ಲ',
          'mobile_number_must_be_minimum_10_digits':
              'ಮೊಬೈಲ್ ಸಂಖ್ಯೆ ಕನಿಷ್ಠ 10 ಅಂಕಿಗಳಾಗಿರಬೇಕು',
          'email': 'ಇಮೇಲ್',
          'gender': 'ಲಿಂಗ',
          'others': 'ಇತರರು',
          //profile-liceience
          'upload_rc_back_side': 'RC ಬ್ಯಾಕ್ ಸೈಡ್ ಅನ್ನು ಅಪ್‌ಲೋಡ್ ಮಾಡಿ',
          'please_enter_license_number': 'ದಯವಿಟ್ಟು ಪರವಾನಗಿ ಸಂಖ್ಯೆಯನ್ನು ನಮೂದಿಸಿ',
          'please_enter_valid_driving_license':
              'ದಯವಿಟ್ಟು ಮಾನ್ಯವಾದ ಚಾಲನಾ ಪರವಾನಗಿಯನ್ನು ನಮೂದಿಸಿ',
          'update': 'ನವೀಕರಿಸಿ',

          //profile-editVechileRegister
          'please_enter_rc_number': 'ದಯವಿಟ್ಟು RC ಸಂಖ್ಯೆಯನ್ನು ನಮೂದಿಸಿ',
          'please_enter_valid_rc_number':
              'ದಯವಿಟ್ಟು ಮಾನ್ಯವಾದ Rc ಸಂಖ್ಯೆಯನ್ನು ನಮೂದಿಸಿ',
          //profile-aadharcard

          'upload_Aadhar_back_side': 'ಆಧಾರ್ ಬ್ಯಾಕ್ ಸೈಡ್ ಅನ್ನು ಅಪ್‌ಲೋಡ್ ಮಾಡಿ',

          //profile-pancard
          'please_enter_pancard_number':
              'ದಯವಿಟ್ಟು ಪ್ಯಾನ್‌ಕಾರ್ಡ್ ಸಂಖ್ಯೆಯನ್ನು ನಮೂದಿಸಿ',
          'please_enter_valid_pancard_number':
              'ದಯವಿಟ್ಟು ಮಾನ್ಯವಾದ ಪ್ಯಾನ್‌ಕಾರ್ಡ್ ಸಂಖ್ಯೆಯನ್ನು ನಮೂದಿಸಿ',

          //profile-bandetails
          'ifsc': 'IFSC',
          'please_enter_ifsc_number': 'ದಯವಿಟ್ಟು IFSC ಸಂಖ್ಯೆಯನ್ನು ನಮೂದಿಸಿ',
          'please_enter_valid_ifsc_number':
              'ದಯವಿಟ್ಟು ಮಾನ್ಯ IFSC ಸಂಖ್ಯೆಯನ್ನು ನಮೂದಿಸಿ',
          'please_enter_upi_number': 'ದಯವಿಟ್ಟು UPI ಸಂಖ್ಯೆಯನ್ನು ನಮೂದಿಸಿ',
          'Please_enter_valid_upi_number':
              'ದಯವಿಟ್ಟು ಮಾನ್ಯವಾದ UPI ಸಂಖ್ಯೆಯನ್ನು ನಮೂದಿಸಿ',
        },
      };
}
// <<< END: LanguageTranslations - all on-screen text in English, Hindi, Kannada, Telugu and Tamil
