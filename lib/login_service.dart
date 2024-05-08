// Package imports:


import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

// Project imports:
import 'common.dart';
import 'constants.dart';

/// local virtual login
Future<void> login({
  required String userID,
  required String userName,
  required BuildContext context,
}) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString(cacheUserIDKey, userID);

  currentUser.id = userID;
  currentUser.name = 'user_$userID';

onUserLogin(context);


}

/// local virtual logout
Future<void> logout() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove(cacheUserIDKey);
}

/// on user login
void onUserLogin(BuildContext context) {
  /// 4/5. initialized ZegoUIKitPrebuiltCallInvitationService when account is logged in or re-logged in
  ZegoUIKitPrebuiltCallInvitationService().init(
    appID: 1713355947 /*input your AppID*/,
    appSign: "e94a53ca772f8a76e28752d103161acdb698626ed97744162629597a5ce42e63" /*input your AppSign*/,
    userID: currentUser.id,
    userName: currentUser.name,
    plugins: [
      ZegoUIKitSignalingPlugin(),
    ],
    notificationConfig: ZegoCallInvitationNotificationConfig(
      androidNotificationConfig: ZegoCallAndroidNotificationConfig(
        showFullScreen: true,
        fullScreenBackground: 'assets/image/call.png',
        channelID: "ZegoUIKit",
        channelName: "Call Notifications",
        sound: "call",
        icon: "call",
      ),
      iOSNotificationConfig: ZegoCallIOSNotificationConfig(
        systemCallingIconName: 'CallKitIcon',
      ),
    ),
    requireConfig: (ZegoCallInvitationData data) {
      final config = (data.invitees.length > 1)
          ? ZegoCallType.videoCall == data.type
              ? ZegoUIKitPrebuiltCallConfig.groupVideoCall()
              : ZegoUIKitPrebuiltCallConfig.groupVoiceCall()
          : ZegoCallType.videoCall == data.type
              ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
              : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall();

      config.avatarBuilder = customAvatarBuilder;

      /// support minimizing, show minimizing button
      config.topMenuBar.isVisible = true;
      config.topMenuBar.buttons
          .insert(0, ZegoCallMenuBarButtonName.minimizingButton);

      return config;
    },
  );

   Navigator.pushNamed(
     context,
     PageRouteNames.home,
   );




}

/// on user logout
void onUserLogout() {
  /// 5/5. de-initialization ZegoUIKitPrebuiltCallInvitationService when account is logged out
  ZegoUIKitPrebuiltCallInvitationService().uninit();
}
