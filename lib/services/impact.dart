import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';

import 'package:app_project/services/server_strings.dart';
import 'package:app_project/utils/shared_preferences.dart';
import 'package:app_project/models/db.dart';


class ImpactService {

  Preferences prefs;

  final Dio _dio = Dio(BaseOptions(baseUrl: ServerStrings.backendBaseUrl));
  // Here we define backendBaseUrl (defined inside server_strings.dart) as starting
  // path for all the future urls. URLs: backendBaseUrl/nextUrlPath

  ImpactService(this.prefs) {
    updateBearer();
    // This helper method is defined below
  }

  String? retrieveSavedToken(bool refresh) {
    if (refresh) {
      return prefs.impactRefreshToken;
    } else {
      return prefs.impactAccessToken;
    }
  }
  // if refresh function was called we need the RefreshToken,
  // if not we can use the AccessToken

  bool checkSavedToken({bool refresh = false}) {
    // By deafault refresh = false

    String? token = retrieveSavedToken(refresh);
    if (token == null) {
      return false;
      // no token
    }
    try {
      return ImpactService.checkToken(token);
      // checking token validity
    } catch (_) {
      return false;
    }
  }

  static bool checkToken(String token) {    
  // this method is static because we to make it available
  // also outside this class

    if (JwtDecoder.isExpired(token)) {
      return false;
    }
    // Check if the token is expired using JwtDecoder library
    // It is a small library for decoding a json web token

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    // Decode a string JWT token into a Map<String, dynamic> containing
    // the decoded JSON payload.

    // After this we need to check the iss claim.

    // In the JSON Web Token (JWT) standard, the "iss" (issuer) claim is a string
    // that identifies the principal that issued the JWT. This can be a human user,
    // an organization, or a service. The "iss" claim is used to prevent JWT token
    // abuse, and to provide some basic information about the context in which the
    // JWT was issued.

    if (decodedToken['iss'] == null) {
      return false;
    } else {
      if (decodedToken['iss'] != ServerStrings.issClaim) {
        return false;
        // if the issuer is not the expected one
      } //else
    } //if-else

    // Check that the user is a patient/researcher or whatever
    // stated into server_strings.dart
    if (decodedToken['role'] == null) {
      return false;
    } else {
      if (decodedToken['role'] != ServerStrings.researcherRoleIdentifier) {
        return false;
      } //else
    } //if-else

    return true;
    // if none of the previous undesired conditions occurs the token is valid
  } //checkToken

  // This method makes the call to get the tokens
  Future<bool> getTokens(String username, String password) async {
    try {
    // We use a try loop to handle exceptions

      Response response = await _dio.post(
        // Handy method to make http POST request

          '${ServerStrings.authServerUrl}token/',
          data: {'username': username, 'password': password},
          // We pass authentication credentials

          options: Options(
              contentType: 'application/json',
              followRedirects: false,
              validateStatus: (status) => true,
              headers: {"Accept": "application/json"}));

      if (ImpactService.checkToken(response.data['access']) &&
          ImpactService.checkToken(response.data['refresh'])) {
        prefs.impactRefreshToken = response.data['refresh'];
        prefs.impactAccessToken = response.data['access'];
        // get and save refresh and access tokens
        
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> refreshTokens() async {
    String? refToken = await retrieveSavedToken(true);
    // now we are trying to refresh a token so we pass refresh = true
    // to [retrieveSavedToken()]

    try {
      Response response = await _dio.post(
          '${ServerStrings.authServerUrl}refresh/',
          data: {'refresh': refToken},
          options: Options(
              contentType: 'application/json',
              followRedirects: false,
              validateStatus: (status) => true,
              headers: {"Accept": "application/json"}));

      if (ImpactService.checkToken(response.data['access']) &&
          ImpactService.checkToken(response.data['refresh'])) {
        prefs.impactRefreshToken = response.data['refresh'];
        prefs.impactAccessToken = response.data['access'];
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  // helper method used in the first lines of this class
  Future<void> updateBearer() async {
    if (!await checkSavedToken()) {
      await refreshTokens();
      // if the access token is no more valid we have to perform a refresh to
      // obtain new tokens by using the method defined above
    }
    String? token = await prefs.impactAccessToken;
    if (token != null) {
      _dio.options.headers = {'Authorization': 'Bearer $token'};
      // We are changing the headers cause we want to ask for authorization.
      // Bearer authentication (also called token authentication) is an HTTP
      // authentication scheme that involves security tokens called bearer tokens.
    }
  }

  // Method to retrieve a patient:

  Future<void> getPatient() async {
    await updateBearer();
    Response r = await _dio.get('study/v1/patients/active');
    prefs.impactUsername = r.data['data'][0]['username'];
    return r.data['data'][0]['username'];
  }

  // Method to retrieve HR data of a single day:

  Future<List<HR>> getDataFromDay(DateTime startTime) async {
    await updateBearer();
    Response r = await _dio.get(
        'data/v1/heart_rate/patients/${prefs.impactUsername}/daterange/start_date/${DateFormat('y-M-d').format(startTime)}/end_date/${DateFormat('y-M-d').format(DateTime.now().subtract(const Duration(days: 1)))}/');
    List<dynamic> data = r.data['data'];
    List<HR> hr = [];
    for (var daydata in data) {
      String day = daydata['date'];
      for (var dataday in daydata['data']) {
        String hour = dataday['time'];
        String datetime = '${day}T$hour';
        DateTime timestamp = _truncateSeconds(DateTime.parse(datetime));
        HR hrnew = HR(timestamp: timestamp, value: dataday['value']);
        if (!hr.any((e) => e.timestamp.isAtSameMomentAs(hrnew.timestamp))) {
          hr.add(hrnew);
        }
      }
    }
    var hrlist = hr.toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return hrlist;
  }

  DateTime _truncateSeconds(DateTime input) {
    return DateTime(
        input.year, input.month, input.day, input.hour, input.minute);
  }
}