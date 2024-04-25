import 'package:flutter/material.dart';

const primaryColor = Color(0xFF2697FF);
const secondaryColor = Color(0xFF2A2D3E);
const bgColor = Color(0xFF212332);

const defaultPadding = 16.0;

class Constants {
  static String apiBaseUrl = "https://permatropia-grp2.webturtle.fr";
  static String uriAuthentification = "$apiBaseUrl/auth/login";
  static String uriLogout = "$apiBaseUrl/auth/logout";
  static String uriRefreshToken = "$apiBaseUrl/auth/refresh";

  static String storageKeyAccessToken = "permatropia-grp2.access_token";
  static String storageKeyRefreshToken = "permatropia-grp2.refresh_token";
  static String storageKeyTokenExpire = "permatropia-grp2.token_expiration";
}