// =============================================================================
// WHAT : The server address and the path of every API call.
// NOTES: apiBaseUrl can be changed at build time with --dart-
//        define=API_BASE_URL=... (default is the live server).
// =============================================================================
// Base Url
// const String apiBaseUrl = 'https://system.rubia.services/api';
// Override for local testing, e.g. an emulator talking to a PC backend:
//   --dart-define=API_BASE_URL=http://10.0.2.2:8080/api
const String apiBaseUrl = String.fromEnvironment('API_BASE_URL',
    defaultValue: 'https://rubiaservices.org/api');
// const String apiBaseUrl = 'https://prod.rubiaservices.org/app/api';

// const String apiBaseUrl = 'http://167.99.120.178/app/api'; //latest
// const String apiBaseUrl = 'https://rubia.services/app/api';
//Basic Login

const String SEND_OTP = '/user/send-otp';
const String LOGOUT = '/user/logout?auth_code=';
const String VERIFY_OTP = '/user/verify-otp';
const String CHECK_API = '/user/check?auth_code=';
const String SIGNUP_FORM = 'manager/signup';
const String EMERGENCY_CONTACT_NUM = '/user/add-user-emergency-contacts?auth_code=';
const String APPLY_REFERRAL = '/user/apply-referral?auth_code=';
const String UPDATE_LAT_LNG = '/user/update-lat-lng?auth_code=';
const String PERSONAL_DETAILS = '/user/update-profile?auth_code=';
const String UPDATE_PROFILE_PIC = '/user/update-profile-pic?auth_code=';
// Terms / Privacy / Refund text written in the admin dashboard (no login needed).
const String LEGAL_PAGE = '/user/legal-page?type=';
// Everything the customer paid in one month, across all services (add &month=YYYY-MM).
const String MY_TRANSACTIONS = '/user/my-transactions?auth_code=';
const String SERVICES = '/user/services?auth_code=';
const String CANCELLATION_CHARGES = '/user/cancellation-charges?auth_code=';
//Notification
const String NOTIFICATION = '/user/list-fcm-notifications?auth_code=';
const String NOTIFICATION_CLEAR = '/user/clear-notifications?auth_code=';
// Emergency Contacts
const String EMERGENCY_CONTACTS = '/user/list-emergency-contacts?auth_code=';
const String ADD_EMERGENCY = '/user/add-emergency-contact?auth_code=';
const String EDIT_EMERGENCY = '/user/update-emergency-contact?auth_code=';
const String DELETE_EMERGENCY = '/user/delete-emergency-contact?auth_code=';
//wallet page
const String WALLET_AMOUNT = '/user-wallet/available-balance?auth_code=';
const String ADD_BALANCE = '/user-wallet/add-balance?auth_code=';
const String ALL_TRANSACTIONS = '/user-wallet/transaction-list?auth_code=';
//favorite location
const String FAVORITE_LIST = '/user/list-favourite-location?auth_code=';
const String CREATE_FAVORITE = '/user/create-favourite-location?auth_code=';
const String DELETE_FAVORITE = '/user/delete-favourite-location?auth_code=';
const String EDIT_FAVORITE = '/user/update-favourite-location?auth_code=';
//Booking List
// const String BOOKINGS_LIST='/booking/list-bookings?auth_code=';

const String COUPONS_LIST = '/user/coupons-list?auth_code=';
const String APPLY_COUPON = '/user/apply-coupon?auth_code=';
const String REMOVE_COUPON = '/user/apply-coupon?auth_code=';

const String BOOKINGS_LIST = '/booking/list-bookings?auth_code=';
// const String ALL_TRANSACTIONS = '/user-wallet/transaction-list?auth_code=';
// //favorite location

// const String COUPONS_LIST = '/user-wallet/coupons-list?auth_code=';
const String CHECK_BOUNDARY = '/user/check-boundary?auth_code=';
const String CURRENT_CITY = '/user/current-city?auth_code=';
const String VEHICLE_TYPES = '/user/vehicle-types?auth_code=';
const String GET_ESTIMATE = '/user/get-estimate?auth_code=';
const String RIDE_INFO = '/user/ride-info?auth_code=';
const String CANCEL_RIDE = '/user/cancel-ride?auth_code=';
const String VIEW_BOOKING = '/user/view-booking-details?auth_code=';
//rating & review
const String ADD_REVIEW = '/user/add-review?auth_code=';
const String RATING_ADD_REVIEW = '/user/rating-and-reviews?auth_code=';
const String BANNER_WITH_CATEGORY = '/user/banner-with-category?auth_code=';
// refer and earn
const String REFER_EARN = '/user/my-referral-earings?auth_code=';
const String GET_VEHICLES = '/taxi-user/get-vehicles?auth_code=';
const String RIDE_REQUEST = '/taxi-user/ride-request?auth_code=';
const String RIDE_REQUEST_DETAIL = '/taxi-user/ride-request-detail?auth_code=';
const String AUTO_ASSIGN_RIDE = '/taxi-user/auto-assign?auth_code=';
const String RIDE_HISTORY = '/taxi-user/my-rides?auth_code=';
const String RIDE_COMPLETION_DETAIL = '/taxi-user/ride-completion-detail?auth_code=';
const String SKIPPER_RATING = '/taxi-user/add-rating?auth_code=';
const String SKIPPER_CANCEL_RIDE = '/taxi-user/cancel-ride?auth_code=';
const String DOWNLOAD_INNVOICE = '/user/invoice?auth_code=';
const String TAXI_RIDE_INFO = '/taxi-user/my-rides-detail?auth_code=';
