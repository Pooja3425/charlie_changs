import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final Color input_border_color = new Color.fromARGB(255, 149, 149, 149);
final Color fab_color = new Color.fromARGB(255, 215, 24, 39);
final Color button_color = new Color.fromARGB(255, 204, 0, 0);
final Color hint_text_color = new Color.fromARGB(255, 109, 109, 109);
final Color text_color = new Color.fromARGB(255, 57, 57, 57);
final Color switch_bg = new Color.fromARGB(255, 240, 240, 240);
final Color icon_color = new Color.fromARGB(255,  93, 93, 93);
final Color notification_title_color = new Color.fromARGB(255, 101, 101, 101);
final Color notification_date_color = new Color.fromARGB(255, 100, 100, 100);
final Color progress_text_color = new Color.fromARGB(255, 238, 189, 38);
final Color delivered_text_color = new Color.fromARGB(255, 114, 201, 87);

Map<int, Color> color =
{
  50:Color.fromRGBO(255, 24, 39, .1),
  100:Color.fromRGBO(255, 24, 39, .2),
  200:Color.fromRGBO(255, 24, 39, .3),
  300:Color.fromRGBO(255, 24, 39, .4),
  400:Color.fromRGBO(255, 24, 39, .5),
  500:Color.fromRGBO(255, 24, 39, .6),
  600:Color.fromRGBO(255, 24, 39, .7),
  700:Color.fromRGBO(255, 24, 39, .8),
  800:Color.fromRGBO(255, 24, 39, .9),
  900:Color.fromRGBO(255, 24, 39, 1),
};
MaterialColor colorCustom = MaterialColor(0xFFFF1827, color);
