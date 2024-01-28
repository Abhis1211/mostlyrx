import 'package:flutter/material.dart';
import 'package:mostlyrx/core/constants/app_contstants.dart';

class OrderStatusScreen extends StatefulWidget {
  final String title;
  final String img;
  final int orderStatus;///0-accepted,1-already assigned,2-completed
  const OrderStatusScreen({Key? key, required this.title, required this.img, required this.orderStatus}) : super(key: key);

  @override
  State<OrderStatusScreen> createState() => _OrderStatusScreenState();
}

class _OrderStatusScreenState extends State<OrderStatusScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){

        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
//          mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 50,left: 10,right: 10),
                alignment: Alignment.center,
                child: Text(widget.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 30,
                        color: Color(0xFF000000))),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height*0.15,
              ),
              Container(
                  alignment: Alignment.center,

                  child: Image.asset("assets/images/${widget.img}",height: 170,width: 170,)),
              SizedBox(
                height: MediaQuery.of(context).size.height*0.2,
              ),
              Container(
                width: MediaQuery.of(context).size.width * .9,
                height: 52,
                padding: const EdgeInsets.only(left: 10.0,right: 10),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff009045),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(20))),
                    onPressed: () {
                      if(widget.orderStatus==0)
                        {
                          Navigator.of(Constants
                              .appNavigationKey.currentState!.context)
                              .pushNamedAndRemoveUntil(
                              '/home', (Route<dynamic> route) => false,
                              arguments: 1);
                        }
                      else if(widget.orderStatus==2)
                        {
                          Navigator.of(Constants
                              .appNavigationKey.currentState!.context)
                              .pushNamedAndRemoveUntil(
                              '/home', (Route<dynamic> route) => false,
                              arguments: 1);
                        }
                      else{
                        Navigator.pop(context);
                      }
                    },
                    child:  Text(widget.orderStatus==0?'My orders':'Go Back')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
