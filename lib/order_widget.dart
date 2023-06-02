import 'dart:async';
import 'package:c_delivery/theme_data.dart';
import 'package:flutter/material.dart';

import 'order_class.dart';

class OrderWidget extends StatefulWidget {
  MyOrder order;
  OrderWidget({required this.order, Key? key}) : super(key: key);

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  Timer? timer;
  late int minutes;
  int seconds = 0;
  Color timerColor = Colors.green;
  late DateTime limit;

  @override
  void initState() {
    super.initState();
    if (DateTime
        .now()
        .minute < widget.order.startDate.minute) {
      minutes = DateTime
          .now()
          .minute - widget.order.startDate.minute + 60;
      minutes = 30 - minutes;
    } else {
      minutes = DateTime
          .now()
          .minute - widget.order.startDate.minute;
      minutes = 30 - minutes;
    }

    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  void startTimer() {
    const duration = Duration(seconds: 1);
    timer = Timer.periodic(duration, (Timer timer) {
      setState(() {
        if (minutes >= 0) {
          if (seconds > 0) {
            seconds--;
          } else {
            minutes--;
            if (minutes >= 0) {
              seconds = 59;
            } else {
              seconds = 0;
            }
          }
        } else {
          timerColor = Colors.red;
          if (seconds < 60) {
            seconds++;
          } else {
            minutes--;
            seconds = 0;
          }
        }
      });
    });
  }

  String formatTime(int time) {
    return time.toString().padLeft(2, '0');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(10),
        child: Container(
              margin: const EdgeInsets.fromLTRB(0, 1, 0, 0),
              padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
              decoration: BoxDecoration(
                  color: Theme
                      .of(context)
                      .scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 1), // changes position of shadow
                    ),
                  ]),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.order.user.firstName,
                          style: TextStyle(
                            color: MyTheme.textColor(context),
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Text(
                        '${formatTime(minutes)}:${formatTime(seconds)}',
                        style: TextStyle(
                          color: timerColor,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text('${widget.order.total.toStringAsFixed(2)} lei',
                          style: TextStyle(
                            color: MyTheme.textColor(context),
                            fontSize: 16,
                          )),
                    ],
                  )
                ],
              ),
            ),
    );
  }
}

