class AppConstants {
  static const String APP_NAME = "DBFood";
  static const int APP_VERSION = 1;
  static const double TAX = 0.05;
  static const String EMPTY_STRING = "Temp";
  static const String STORE_ADDRESS = "3116 parsons road NW Edmonton";

  // static const String BASE_URL = "http://mvs.bslmeiyu.com";
  static const String BASE_URL = "https://jayu.tech/shopping-app";
  // static const String POPULAR_PRODUCT_URI = "/api/v1/products/popular";
  // static const String RECOMMENDED_PRODUCT_URI = "/api/v1/products/recommended";
  static const String UPLOAD_URL = "/";
  static const String TOKEN = "";
  static const String PHONE = "";
  static const String PASSWORD = "";
  static const String CART_LIST = "Cart-list";
  static const String CART_HISTORY_LIST = "Cart-history-list";

  // System
  static const String GET_SYSTEM_INFO = BASE_URL + "/backend/system/Get_System_Info.php";
  static const String GET_Product_TYPE = BASE_URL + "/backend/system/Get_Product_Type.php";

  static const String REGISTRATION_URI = "/api/v1/auth/register";
  static const String LOGIN_URI = "/api/v1/auth/login";

  static const String USER_INFO_URI="/api/v1/customer/info";

  static const String USER_ADDRESS="user_address";
  static const String GEOCODE_URI="/api/v1/config/geocode-api";

  static const String USER_ACCOUNT = "User-account";
  static const String ALL_PRODUCT_TYPE_ID = "All";
  static const String POPULAR_PRODUCT_TYPE_ID = "2";
  static const String RECOMMENDED_PRODUCT_TYPE_ID = "3";
  static const String VEGETABLE_AND_FRUIT_TYPE_ID = "4";
  static const String MEAT_AND_SEAFOOD_TYPE_ID = "5";
  static const String DAIRY_AND_EGGS_TYPE_ID = "6";
  static const String SAUCES_TYPE_ID = "7";
  static const String BEVERAGE_TYPE_ID = "8";
  static const String PET_TYPE_ID = "9";

  static const double ZOOM_IN = 17;

  static const String LOGIN_URL = BASE_URL + "/backend/account/Customer_Login.php";
  static const String SIGN_UP_URL = BASE_URL + "/backend/account/Add_New_Customer.php";
  static const String GET_PRODUCTS_URL = BASE_URL + "/backend/product/Get_Products.php";
  static const String GET_RECOMMENDED_URL = BASE_URL + "/backend/product/Get_Products.php";
  static const String GET_FoodPerType_URL = BASE_URL + "/backend/product/Get_Products.php";
  static const String MAP_HOST = 'https://maps.google.com/maps/api/geocode/json';
  static const String APP_API = 'AIzaSyAxZOV5TpE9YjJh77040FSbTyGmtZqZtWU';

  static const String ADD_USER_ADDRESS_URL= BASE_URL + "/backend/address/Add_New_Customer_Address.php";
  static const String ADDRESS_LIST_URL= BASE_URL + "/backend/address/Get_Address_List.php";

  static const String TUTORIAL_BASE_URL = "https://jayu.tech";
  static const String ZONE_URL = TUTORIAL_BASE_URL + "/api/v1/config/get-zone-id";

  static const String SEARCH_LOCATION_URL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=';
  static const String PLACE_DETAILS_URL = 'https://maps.googleapis.com/maps/api/place/details/json?placeid=';

  // Orders
  static const String PLACE_ORDER_URL = BASE_URL + "/backend/order/Place_Order.php";
  static const String GET_ORDER_LIST_URL = BASE_URL + "/backend/order/Get_Order_List.php";

  // Payments
  // static const String STRIPE_ID = "pk_live_51R9uXgDYdBDUOafZ5X4sWTLZo8FogRMaN2FkjuQ9mWzRJgor7CRGBYulNgCmoqZYc3ZgpeaIDYku5xI0ju4OwKD100s5v4fv3S";
  static const String STRIPE_ID = "pk_test_51R9uXpDCr32zAbMuHoOIGzyKVwIl9X3quDuREfAdz2w1WCcMO9AKzLitTerWmv9JK4FNjOoQ19kxlqZbM5X3qpyH00zm5Majf8";
  static const String ADD_STRIPE_CUSTOMER_URL= BASE_URL + "/stripe/Add_Stripe_Customer.php";
  static const String ATTACH_PAYMENT_URL= BASE_URL + "/stripe/Attach_Payment_Method_To_Customer.php";
  static const String CHARGE_CUSTOMER_URL= BASE_URL + "/stripe/Charge_A_Customer.php";
}