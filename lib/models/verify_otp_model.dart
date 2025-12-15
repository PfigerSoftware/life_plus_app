import 'dart:convert';
/// message : "Mobile verified successfully (bypass OTP)"
/// access_token : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIiwiZXhwIjoxNzY1MzU4NTMxfQ.mBh2MobmMV_kc4s0iFZNNWkf_cgZD5kml_ISqSNWPW8"
/// refresh_token : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIiwiZXhwIjoxNzY1OTYyNDMxfQ._Did9mEModEyH152aVfSGX3n8xpkQjVrL2opLfUcfqY"
/// user : {"id":1,"name":"afsdf","email":"use123r@example.com","mobile":"9876543211","product_id":1,"is_mobile_verified":true,"is_active":true,"role":"user","lpc_id":"LPC002"}

VerifyOtpModel verifyOtpModelFromJson(String str) => VerifyOtpModel.fromJson(json.decode(str));
String verifyOtpModelToJson(VerifyOtpModel data) => json.encode(data.toJson());
class VerifyOtpModel {
  VerifyOtpModel({
      String? message, 
      String? accessToken, 
      String? refreshToken, 
      User? user,}){
    _message = message;
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    _user = user;
}

  VerifyOtpModel.fromJson(dynamic json) {
    _message = json['message'];
    _accessToken = json['access_token'];
    _refreshToken = json['refresh_token'];
    _user = json['user'] != null ? User.fromJson(json['user']) : null;
  }
  String? _message;
  String? _accessToken;
  String? _refreshToken;
  User? _user;
VerifyOtpModel copyWith({  String? message,
  String? accessToken,
  String? refreshToken,
  User? user,
}) => VerifyOtpModel(  message: message ?? _message,
  accessToken: accessToken ?? _accessToken,
  refreshToken: refreshToken ?? _refreshToken,
  user: user ?? _user,
);
  String? get message => _message;
  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;
  User? get user => _user;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = _message;
    map['access_token'] = _accessToken;
    map['refresh_token'] = _refreshToken;
    if (_user != null) {
      map['user'] = _user?.toJson();
    }
    return map;
  }

}

/// id : 1
/// name : "afsdf"
/// email : "use123r@example.com"
/// mobile : "9876543211"
/// product_id : 1
/// is_mobile_verified : true
/// is_active : true
/// role : "user"
/// lpc_id : "LPC002"

User userFromJson(String str) => User.fromJson(json.decode(str));
String userToJson(User data) => json.encode(data.toJson());
class User {
  User({
      num? id, 
      String? name, 
      String? email, 
      String? mobile, 
      num? productId, 
      bool? isMobileVerified, 
      bool? isActive, 
      String? role, 
      String? lpcId,}){
    _id = id;
    _name = name;
    _email = email;
    _mobile = mobile;
    _productId = productId;
    _isMobileVerified = isMobileVerified;
    _isActive = isActive;
    _role = role;
    _lpcId = lpcId;
}

  User.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _email = json['email'];
    _mobile = json['mobile'];
    _productId = json['product_id'];
    _isMobileVerified = json['is_mobile_verified'];
    _isActive = json['is_active'];
    _role = json['role'];
    _lpcId = json['lpc_id'];
  }
  num? _id;
  String? _name;
  String? _email;
  String? _mobile;
  num? _productId;
  bool? _isMobileVerified;
  bool? _isActive;
  String? _role;
  String? _lpcId;
User copyWith({  num? id,
  String? name,
  String? email,
  String? mobile,
  num? productId,
  bool? isMobileVerified,
  bool? isActive,
  String? role,
  String? lpcId,
}) => User(  id: id ?? _id,
  name: name ?? _name,
  email: email ?? _email,
  mobile: mobile ?? _mobile,
  productId: productId ?? _productId,
  isMobileVerified: isMobileVerified ?? _isMobileVerified,
  isActive: isActive ?? _isActive,
  role: role ?? _role,
  lpcId: lpcId ?? _lpcId,
);
  num? get id => _id;
  String? get name => _name;
  String? get email => _email;
  String? get mobile => _mobile;
  num? get productId => _productId;
  bool? get isMobileVerified => _isMobileVerified;
  bool? get isActive => _isActive;
  String? get role => _role;
  String? get lpcId => _lpcId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['email'] = _email;
    map['mobile'] = _mobile;
    map['product_id'] = _productId;
    map['is_mobile_verified'] = _isMobileVerified;
    map['is_active'] = _isActive;
    map['role'] = _role;
    map['lpc_id'] = _lpcId;
    return map;
  }

}