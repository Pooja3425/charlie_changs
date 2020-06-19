import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'color_constants.dart';
import 'size_constants.dart';

class CommonMethods
{
  TextStyle toolBar = TextStyle(color: text_color,fontSize: 15,fontFamily: "Manrope",fontWeight: FontWeight.bold);

  static Widget horizontalLine(BuildContext context)
  {
   return Container(height: 0.2,color: icon_color,
     width: getWidth(context),);
  }

  static Widget appBar(BuildContext context,String title)
  {
    return Container(
      color: Colors.white,
      height: 80,
      width: getWidth(context),
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(right:30.0,left: 30.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            InkWell(
                onTap: ()=> Navigator.of(context).pop(),
                child: Icon(Icons.keyboard_backspace,color: icon_color,)),
            SizedBox(width: 10,),
            Text(title,style: TextStyle(color: text_color,fontSize: 15,fontFamily: "Manrope",fontWeight: FontWeight.bold),)
          ],
        ),
      ),
    );
  }

  Widget thickHorizontalLine(BuildContext context)
  {
    return Container(
      height: 10,
      width: getWidth(context),
      color: switch_bg,
    );
  }
  static final EdgeInsets textFieldPadding = EdgeInsets.only(left:10.0,right:10.0);
  static final EdgeInsets initialPadding =  const EdgeInsets.only(left:40.0,right: 40);
}