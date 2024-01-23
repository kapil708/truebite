enum ServerType { develop, production }

// Development Server Config
var developConfig = {
  'API_URL': 'https://google.com.app/api',
  'BASE_URL': 'https://google.com.app/',
  'API_KEY': 'AIzaSyBnMTjHX0bAOeBJ6xm6qF5hiAmzsEV6pec',
};

// Production Server Config
var productionConfig = {
  'API_URL': 'https://google.com.app/api',
  'BASE_URL': 'https://google.com.app/',
  'API_KEY': 'AIzaSyBnMTjHX0bAOeBJ6xm6qF5hiAmzsEV6pec',
};

class Environment {
  /// Before create a production build change server type
  static ServerType defaultServer = ServerType.production;

  static String getEnvData(key) {
    //printLog("storage : ${getStorage(Session.serverConfig)}");
    //printLog("local : ${(defaultServer == ServerType.develop) ? developConfig : productionConfig}");
    //var serverConfig = getStorage(Session.serverConfig) ?? ((defaultServer == ServerType.develop) ? developConfig : productionConfig);

    var serverConfig = (defaultServer == ServerType.develop) ? developConfig : productionConfig;
    return serverConfig[key].toString();
  }

  /// Static links
  static String get playStoreUrl => '';
  static String get appStoreUrl => '';

  /// For server config
  static String get apiUrl => getEnvData('API_URL');
  static String get baseUrl => getEnvData('BASE_URL');
  static String get apiKey => getEnvData('API_KEY');
}
