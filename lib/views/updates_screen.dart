import 'package:charliechang/blocs/notification_bloc.dart';
import 'package:charliechang/models/notification_response.dart';
import 'package:charliechang/networking/Repsonse.dart';
import 'package:charliechang/utils/color_constants.dart';
import 'package:charliechang/utils/common_methods.dart';
import 'package:charliechang/utils/size_constants.dart';
import 'package:charliechang/utils/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'bottom_screen.dart';

class UpdatesScreen extends StatefulWidget {
  @override
  _UpdatesScreenState createState() => _UpdatesScreenState();
}

class _UpdatesScreenState extends State<UpdatesScreen> {

  @override
  void initState() {
    notificationAPI();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: switch_bg,
        width: getWidth(context),
       // height: getHeight(context),
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              height: 74,
              width: getWidth(context),
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(right:30.0,left: 30.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                        onTap: ()=>Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BottomScreen())),
                        child: Icon(Icons.keyboard_backspace,color: icon_color,)),
                    SizedBox(width: 10,),
                    Text("Notifications",style: TextStyle(color: text_color,fontSize: 15,fontFamily: "Manrope",fontWeight: FontWeight.bold),)
                  ],
                ),
              ),
            ),
            Container(
              height: 10,
              width: getWidth(context),
              color: switch_bg,
            ),
            Container(
              color: Colors.white,
              width: getWidth(context),
              height: getHeight(context)-172,
              padding: EdgeInsets.only(top: 15),
              child: mNotificationList.length>0?ListView.builder(
                shrinkWrap: true,
                itemCount: mNotificationList.length,
                itemBuilder: (context,index){
                  String dd =  DateFormat("dd-MMM-yyy").format(DateTime.parse("${mNotificationList[index].createdAt}"));

                  return Container(
                    width: getWidth(context),
                    decoration: BoxDecoration(
                        color: Colors.white
                      //borderRadius: BorderRadius.all(Radius.circular(3.3))
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left:30.0,right: 30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          mNotificationList[index].image!=null?Image.network(IMAGE_BASE_URL+"${mNotificationList[index].image}",width: getWidth(context),height: 200,fit: BoxFit.cover,):Container(),
                          SizedBox(height: 15,),
                          Text("${mNotificationList[index].title}", style: TextStyle(fontSize: 15,color: notification_title_color,fontWeight: FontWeight.bold,fontFamily: "Manrope"),),
                          SizedBox(height: 15,),
                          Text("${mNotificationList[index].description}", maxLines: 3,softWrap: true,style: TextStyle(fontSize: 12,color: icon_color,fontFamily: "Manrope",fontWeight: FontWeight.normal),),
                          SizedBox(height: 15,),
                          Text("sent on $dd", style: TextStyle(fontSize: 12,color: notification_date_color,fontFamily: "Manrope",fontWeight: FontWeight.normal),),
                          SizedBox(height: 15,),
                          Container(width: getWidth(context),
                            height: 0.5,
                            color: icon_color,),
                          SizedBox(height: 15,),
                        ],
                      ),
                    ),
                  );
                },
              ):
              Center(
                child: Text("No Notification",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
              ),
            )
          ],
        ),
      ),
    );
  }

  NotificationBloc mNotificationBloc;
  NotificationResponse mNotificationResponse;
  List<Data> mNotificationList = new List();
  notificationAPI()
  {
    mNotificationBloc=NotificationBloc();
    mNotificationBloc.dataStream.listen((onData){
      mNotificationResponse = onData.data;
      if(onData.status == Status.LOADING)
      {
        //CommonMethods.displayProgressDialog(onData.message, context);
      }
      else if(onData.status == Status.COMPLETED)
      {
        //CommonMethods.dismissDialog(context);
          setState(() {
            mNotificationList = mNotificationResponse.data;
          });
      }
      else if(onData.status == Status.ERROR)
      {
       // CommonMethods.dismissDialog(context);
      }
    });
  }
}
