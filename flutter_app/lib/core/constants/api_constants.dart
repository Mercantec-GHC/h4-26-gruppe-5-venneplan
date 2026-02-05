class ApiConstants {
  // Backend API URL 
  static const String baseUrl = 'https://venneplan-api.mercantec.tech/api';
  
  // Weather endpoints
  static const String weatherForecast = '/WeatherForecast';
  static const String chats = '/Chats';
  static const String groups = '/Groups';
  
  // Full URLs
  static String get weatherForecastUrl => '$baseUrl$weatherForecast';
  static String get chatsUrl => '$baseUrl$chats';
  static String get groupsUrl => '$baseUrl$groups';
} 