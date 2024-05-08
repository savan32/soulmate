// Flutter imports:
import 'package:call_with_invitation_and_notification/caller_static_list.dart';
import 'package:call_with_invitation_and_notification/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:faker/faker.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:zego_uikit/zego_uikit.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

// Project imports:
import 'constants.dart';
import 'login_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final TextEditingController singleInviteeUserIDTextCtrl =
      TextEditingController();
  final TextEditingController groupInviteeUserIDsTextCtrl =
      TextEditingController();

  List<CallList> callList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    singleInviteeUserIDTextCtrl.text="141851";

    createCallList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        appBar: AppBar(
          leading:Icon(Icons.home_filled,color: Colors.white,),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black,
          title:  RichText(
          text: const TextSpan(
            text: 'So',
            style: TextStyle(color: Colors.white, fontSize: 20),
            children: <TextSpan>[
              TextSpan(
                text: 'ul',
                style: TextStyle(color: Colors.purpleAccent),
              ),
              TextSpan(text: 'mate', style: TextStyle(color: Colors.white, fontSize: 20),),
            ],
          ),
        ),
        actions: [

          IconButton(
            icon: Icon(Icons.exit_to_app_sharp),

            color: Colors.white,
            onPressed: () {
              logout().then((value) {
                onUserLogout();

                Navigator.pushNamed(
                  context,
                  PageRouteNames.login,
                );
              });
            },
          )
        ],

        ),
        body: WillPopScope(
          onWillPop: () async {
            return ZegoUIKit().onWillPop(context);
          },

          child: Container(
            margin: EdgeInsets.only(left: 30,right: 30,top: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*Positioned(
                  top: 20,
                  right: 10,
                  child: logoutButton(),
                ),
                Positioned(
                  top: 50,
                  left: 10,
                  child: Text('Your Phone Number: ${currentUser.id}',style: TextStyle(color: Colors.white),),
                ),*/



                Container(
                  height: 50,
                  width: double.infinity,
                  padding: EdgeInsets.only(left: 20,right: 20),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(Radius.circular(15))
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Your Phone Number : ${currentUser.id}",style: TextStyle(fontSize: 18,color: Colors.white)),
                        Icon(Icons.copy,color: Colors.white,)
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20,),

                Flexible(
                  child: ListView.builder(
                    itemCount: callList.length, // Change this to your desired number of items
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: ListTile(
                          leading: Container(
                            height: 42,width: 42,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(callList[index].image!),
                            ),
                          ),
                          title: Text(callList[index].UserName!),
                          subtitle: Text('Phone Number : ${callList[index].Id}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                             /* IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  // Add your edit action here
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  // Add your delete action here
                                },
                              ),*/
                              sendCallButton(
                                isVideoCall: false,
                                id: callList[index].Id!,
                                onCallFinished: onSendCallInvitationFinished,
                              ),
                              sendCallButton(
                                isVideoCall: true,
                                id: callList[index].Id!,
                                onCallFinished: onSendCallInvitationFinished,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),


          //  userListView(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget logoutButton() {
    return Ink(
      width: 35,
      height: 35,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.redAccent,
      ),
      child: IconButton(
        icon: const Icon(Icons.exit_to_app_sharp),
        iconSize: 20,
        color: Colors.white,
        onPressed: () {
          logout().then((value) {
            onUserLogout();

            Navigator.pushNamed(
              context,
              PageRouteNames.login,
            );
          });
        },
      ),
    );
  }



  void onSendCallInvitationFinished(
    String code,
    String message,
    List<String> errorInvitees,
  ) {
    if (errorInvitees.isNotEmpty) {
      String userIDs = "";
      for (int index = 0; index < errorInvitees.length; index++) {
        if (index >= 5) {
          userIDs += '... ';
          break;
        }

        var userID = errorInvitees.elementAt(index);
        userIDs += userID + ' ';
      }
      if (userIDs.isNotEmpty) {
        userIDs = userIDs.substring(0, userIDs.length - 1);
      }

      var message = 'User doesn\'t exist or is offline: $userIDs';
      if (code.isNotEmpty) {
        message += ', code: $code, message:$message';
      }
      showToast(
        message,
        position: StyledToastPosition.top,
        context: context,
      );
    } else if (code.isNotEmpty) {
      showToast(
        'code: $code, message:$message',
        position: StyledToastPosition.top,
        context: context,
      );
    }
  }

  void createCallList() {
    callList.clear();
    for(int i=0;i<3;i++)
      {
        if(i==0)
          {
            callList.add(CallList(image: 'https://randomuser.me/api/portraits/men/35.jpg',UserName:"Savan",Id:"111"));
          }
        if(i==1)
        {
          callList.add( CallList(image: 'https://randomuser.me/api/portraits/men/68.jpg',UserName:"Kishan",Id:"222"));
        }
        if(i==2)
        {
          callList.add(CallList(image: 'https://randomuser.me/api/portraits/women/22.jpg',UserName:"Sweeta",Id:"333"));
        }
      }

  }
}

Widget inviteeIDFormField({
  required TextEditingController textCtrl,
  List<TextInputFormatter>? formatters,
  String hintText = '',
  String labelText = '',
}) {
  const textStyle = TextStyle(fontSize: 12.0);
  return Expanded(
    flex: 100,
    child: SizedBox(
      height: 30,
      child: TextFormField(
        style: textStyle,
        controller: textCtrl,
        inputFormatters: formatters,
        decoration: InputDecoration(
          isDense: true,
          hintText: hintText,
          hintStyle: textStyle,
          labelText: labelText,
          labelStyle: textStyle,
          border: const OutlineInputBorder(),
        ),
      ),
    ),
  );
}

Widget sendCallButton({
  required bool isVideoCall,
  required String id,
  void Function(String code, String message, List<String>)? onCallFinished,
}) {
  var invitees = getInvitesFromTextCtrl(id);

  return ZegoSendCallInvitationButton(
    isVideoCall: isVideoCall,
    invitees: invitees,
    resourceID: "zego_call",
    iconSize: const Size(40, 40),
    buttonSize: const Size(50, 50),
    onPressed: onCallFinished,
  );
}

List<ZegoUIKitUser> getInvitesFromTextCtrl(String textCtrlText) {
  List<ZegoUIKitUser> invitees = [];

  var inviteeIDs = textCtrlText.trim().replaceAll('，', '');
  inviteeIDs.split(",").forEach((inviteeUserID) {
    if (inviteeUserID.isEmpty) {
      return;
    }

    invitees.add(ZegoUIKitUser(
      id: inviteeUserID,
      name: 'user_$inviteeUserID',
    ));
  });


  return invitees;
}


