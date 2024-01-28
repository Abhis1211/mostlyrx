// ignore_for_file: unnecessary_null_comparison

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:mostlyrx/core/apimodels/earnings_response.dart';

import 'package:mostlyrx/core/models/user.dart';
import 'package:mostlyrx/core/viewmodels/views/earnings_view_model.dart';
import 'package:mostlyrx/ui/constants/colors.dart';
import 'package:mostlyrx/ui/constants/icons.dart';
import 'package:mostlyrx/ui/constants/styles.dart';
import 'package:mostlyrx/ui/view/base_widget.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class EarningsView extends StatefulWidget {
  const EarningsView({Key? key}) : super(key: key);

  @override
  State<EarningsView> createState() => _EarningsViewState();
}

class _EarningsViewState extends State<EarningsView> {
  List<_SalesData> data = [
    _SalesData('Mon', 0,'Nov 1'),
    _SalesData('Tue', 0,'Nov 1'),
    _SalesData('Wed', 0,'Nov 1'),
    _SalesData('Thu', 0,'Nov 1'),
    _SalesData('Fri', 0,'Nov 1'),
    _SalesData('Sat', 0,'Nov 1'),
    _SalesData('Sun', 0,'Nov 1')
  ];

  late final ScrollController _scrollController;
  double currIndex = 0;
  int totalEarningInWeek = 0;
  List<int> weekearning = [];
  var totalStops=0;
  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      setState(() {
        var newPos = (_scrollController.position.pixels ~/ 140).toDouble();
        if (newPos >= 10) {
          currIndex = 9;
        } else {
          currIndex = newPos;
        }
      });
    });
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    if (!mounted) return;
    _scrollController.dispose();
    super.dispose();
  }

  Earnings? localModel;
  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<User?>(context);
    Size size = MediaQuery.of(context).size;
    return BaseWidget<EarningsViewModel>(
      model: EarningsViewModel(orderService: Provider.of(context)),
      onModelReady: (model) async {
        localModel = await model.getEarnings(user?.id.toString() ?? '');
        setState(() {
          if (localModel != null) weekearning = _weekEarning();
          if (localModel != null)  _lastWeekEarning();
        });
        return localModel;
      },
      builder: (context, model, child) => model.busy
          ? const Center(child: CircularProgressIndicator())
          : model.earnings != null
              ? Stack(
                children: [
                  Container(
                    height: size.height * 0.22,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          AppColors.one,
                          AppColors.one,
                          AppColors.two,
                        ],
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // const SizedBox(height: 15),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.end,
                        //   children: [
                        //     Text(
                        //         '${DateFormat('MMMd', 'en_US').format(DateTime.now().subtract(const Duration(days: 8)))}  - ${DateFormat('MMMd', 'en_US').format(DateTime.now())}',
                        //         style: const TextStyle(fontSize: 12)),
                        //     SizedBox(
                        //       child: IconButton(
                        //           onPressed: () {},
                        //           icon: const Icon(Icons.arrow_drop_down)),
                        //     )
                        //   ],
                        // ),
                        // Container(
                        //     margin: const EdgeInsets.symmetric(horizontal: 10),
                        //     height: 190,
                        //     padding: const EdgeInsets.all(15),
                        //     decoration: const BoxDecoration(
                        //       borderRadius: BorderRadius.all(Radius.circular(20)),
                        //       gradient: LinearGradient(
                        //           begin: Alignment.topRight,
                        //           colors: [
                        //             Color(0xFF15A752),
                        //             Color(0xFF27E377),
                        //           ]),
                        //     ),
                        //     child: Column(
                        //       children: [
                        //         Row(
                        //           mainAxisAlignment:
                        //               MainAxisAlignment.spaceBetween,
                        //           children: [
                        //             const Text(
                        //               'Current',
                        //               style: TextStyle(
                        //                   color: Colors.white, fontSize: 15),
                        //             ),
                        //             Text('\$$totalEarningInWeek',
                        //                 style: const TextStyle(
                        //                     color: Colors.white, fontSize: 17))
                        //           ],
                        //         ),
                        //         const SizedBox(height: 12),
                        //         SingleChildScrollView(
                        //           scrollDirection: Axis.horizontal,
                        //           child: Row(
                        //               children: weekearning
                        //                   .map((e) => _priceIndicator(e))
                        //                   .toList()),
                        //         )
                        //       ],
                        //     )),

                        ///
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text('My Earnings',
                                  style: poppinsSemiBold.copyWith(
                                    fontSize: 18,
                                    color: AppColors.whiteColor,
                                  ),
                                ),
                              ),
                              SvgPicture.asset(AppIcons.menu),
                            ],
                          ),
                        ),



                        ///
                        const SizedBox(height: 10),
                        Expanded(
                          child: ListView(
                            ///padding: const EdgeInsets.symmetric(horizontal: 24),
                            physics: const BouncingScrollPhysics(),
                            children: [

                              ///
                              SizedBox(height: size.height * 0.024),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                margin: const EdgeInsets.symmetric(horizontal: 24),
                                decoration: BoxDecoration(
                                  color: AppColors.whiteColor,
                                  borderRadius: BorderRadius.circular(8.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.blackColor.withOpacity(0.1),
                                      blurRadius: 4.0,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    ///
                                    Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: (){

                                        },
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                                       '${DateFormat('MMMd', 'en_US').format(DateTime.parse(localModel!.duration_start.toString()))}  - ${DateFormat('MMMd', 'en_US').format(DateTime.parse(localModel!.duration_end.toString()))}',
                                              style: poppinsSemiBold.copyWith(
                                                fontSize: 12,
                                                color: AppColors.primaryOneColor,
                                              ),
                                            ),
                                            const Icon(Icons.arrow_drop_down_sharp, color: AppColors.primaryOneColor, size: 20),
                                          ],
                                        ),
                                      ),
                                    ),

                                    ///
                                    Center(
                                      child: Text('Current',
                                        style: poppinsMedium.copyWith(
                                          fontSize: 16,
                                          color: AppColors.primaryOneColor,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),

                                    /// price with icon buttons
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        IconButton(onPressed: (){}, icon: const Icon(Icons.arrow_left_outlined, color: AppColors.blackColor, size: 30),),

                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                          child: Text('\$$totalEarningInWeek',
                                            style: poppinsSemiBold.copyWith(
                                              fontSize: 34,
                                              color: AppColors.blackColor,
                                            ),
                                          ),
                                        ),
                                        IconButton(onPressed: (){}, icon: const Icon(Icons.arrow_right_outlined, color: AppColors.blackColor, size: 30),),
                                      ],
                                    ),
                                    SizedBox(height: size.height * 0.03),

                                    const Divider(
                                      height: 1.0,
                                      thickness: 1.0,
                                      color: AppColors.dividerColor1,
                                    ),
                                    SizedBox(height: size.height * 0.016),

                                    ///
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Stops ${localModel!.totalOrders??''}',
                                          style: poppinsSemiBold.copyWith(
                                            fontSize: 14,
                                            color: AppColors.purpleDark,
                                          ),
                                        ),
                                        Text(localModel!.duration_start.toString()=='null' || localModel!.duration_current.toString()=='null' ||
                                            localModel!.duration_start.toString()=='' || localModel!.duration_current.toString()=='' ?'':
                                        ('${DateTime.parse(localModel!.duration_current.toString()).difference( DateTime.parse(localModel!.duration_start.toString())).inDays}d ${DateTime.parse(localModel!.duration_current.toString()).difference( DateTime.parse(localModel!.duration_start.toString())).inHours%  24}h').toString(),
                                          style: poppinsSemiBold.copyWith(
                                            fontSize: 14,
                                            color: AppColors.purpleDark,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: size.height * 0.02),
                                  ],
                                ),
                              ),

                              ///
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Ongoing month',
                                      style: poppinsMedium.copyWith(
                                        fontSize: 14,
                                        color: AppColors.primaryOneColor,
                                      ),
                                    ),
                                    Text(
                                      model.earnings.totalEarning,
                                      style: poppinsBold.copyWith(
                                        fontSize: 16,
                                        color: AppColors.blackColor,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24.0),
                                child: Divider(
                                  height: 1,
                                  thickness: 1,
                                  color: AppColors.dividerColor1,
                                ),
                              ),

                              ///
                              const SizedBox(height: 20),
                              SfCartesianChart(
                                  plotAreaBorderWidth: 0,
                                  isTransposed: false,
                                  primaryXAxis: CategoryAxis(majorGridLines: const MajorGridLines(width: 0)),
                                  primaryYAxis: CategoryAxis(),
                                  // Chart title
//                          title: ChartTitle(text: 'Half yearly sales analysis'),
                                  // Enable legend
                                  //                        legend: Legend(isVisible: true),
                                  // Enable tooltip
//                          tooltipBehavior: TooltipBehavior(enable: true),
                                  series: <ChartSeries<_SalesData, String>>[
                                    ColumnSeries<_SalesData, String>(
                                        dataSource: data,
                                        onPointTap:(ChartPointDetails e) async {
                                          if(e.pointIndex!=null)
                                          {
                                            Fluttertoast.showToast(msg:data[e.pointIndex??0].date);
                                          }
                                        },
                                        xValueMapper: (_SalesData sales, _) => sales.year,
                                        yValueMapper: (_SalesData sales, _) => sales.sales,
                                        borderRadius: BorderRadius.circular(20),
                                        color: const Color(0xff65C58D),
                                        dataLabelSettings: const DataLabelSettings(isVisible: true))
                                  ]),

                              ///
                              Padding(
                                padding: const EdgeInsets.only(left: 24.0, right: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Recent Earnings',
                                        style: poppinsSemiBold.copyWith(
                                          fontSize: 18,
                                          color: AppColors.blackColor,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: (){},
                                      child: Text(
                                        'More',
                                        style: poppinsMedium.copyWith(
                                          fontSize: 14,
                                          color: AppColors.purpleDark,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              model.earnings.thisMonthOrders.isEmpty
                                  ? const SizedBox.shrink()
                                  : Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: SizedBox(
                                  height: size.height * 0.12,
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    physics: const BouncingScrollPhysics(),
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    itemCount:
                                    model.earnings.thisMonthOrders.length < 50
                                        ? model
                                        .earnings.thisMonthOrders.length
                                        : 50,
                                    controller: _scrollController,
                                    separatorBuilder: (cnx, index) =>
                                    const SizedBox.shrink(),
                                    itemBuilder: (cnx, index) {
                                      var item =
                                      model.earnings.thisMonthOrders[index];
                                      return Container(
                                        padding: const EdgeInsets.fromLTRB(18, 0, 30, 0),
                                        width: size.height * 0.3,
                                        margin: const EdgeInsets.only(right: 10),
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(14),
                                            bottomLeft: Radius.circular(14),
                                            topRight: Radius.circular(4.0),
                                            topLeft: Radius.circular(4.0),
                                          ),
                                          gradient: LinearGradient(
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                            colors: [
                                              AppColors.greenLight,
                                              AppColors.greenDark,
                                            ],
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    '\$ ${double.tryParse(item.deliveryPrice.toString())?.toStringAsPrecision(3) ?? 0}',
                                                    style: poppinsSemiBold.copyWith(
                                                      fontSize: 24,
                                                      color: AppColors.whiteColor,
                                                    ),
                                                  ),
                                                ),

                                                SvgPicture.asset(AppIcons.dSign, height: size.height * 0.05),
                                              ],
                                            ),
                                            Text(item.customerName,
                                              style: poppinsRegular.copyWith(
                                                fontSize: 14,
                                                color: AppColors.whiteColor,
                                              ),
                                            ),


                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),

                              SizedBox(height: size.height * 0.02),
                              // model.earnings.thisMonthOrders.isEmpty
                              //     ? const SizedBox.shrink()
                              //     : Row(
                              //         mainAxisAlignment: MainAxisAlignment.center,
                              //         children: [
                              //           DotsIndicator(
                              //             position: currIndex,
                              //             dotsCount:
                              //                 model.earnings.thisMonthOrders.length > 10
                              //                     ? 10
                              //                     : model
                              //                         .earnings.thisMonthOrders.length,
                              //             decorator: DotsDecorator(
                              //               activeColor: const Color(0xFF1E9F53),
                              //               size: const Size.square(9.0),
                              //               activeSize: const Size(25.0, 9.0),
                              //               activeShape: RoundedRectangleBorder(
                              //                   borderRadius:
                              //                       BorderRadius.circular(5.0)),
                              //             ),
                              //           ),
                              //         ],
                              //       ),
                              // const SizedBox(height: 50),
                              Padding(
                                padding: const EdgeInsets.only(left: 24.0, right: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Payment History',
                                        style: poppinsSemiBold.copyWith(
                                          fontSize: 18,
                                          color: AppColors.blackColor,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: (){},
                                      child: Text(
                                        'More',
                                        style: poppinsMedium.copyWith(
                                          fontSize: 14,
                                          color: AppColors.purpleDark,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5),
                              Padding(
                                padding: const EdgeInsets.only(left: 18.0),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: localModel!.payementRecord
                                        .map((e) => _paymentContainer(
                                        e.status == 'New'
                                            ? 'Pending Payment'
                                            : 'Amount Paid',
                                        e.invoiceTotal,
                                        e.status == 'New'))
                                        .toList(),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 120),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
              : const Center(
                  child: Text('No Activity to show...'),
                ),
    );
  }

  Widget _priceIndicator(int top) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7.0),
        child: Column(
          children: [
            Container(
              width: 7,
              height: 100,
              margin: const EdgeInsets.symmetric(horizontal: 0),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(15)),
              child: Column(
                children: [
                  Container(
                      height: (100 - top).toDouble(),
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15)))),
                  Container(
                      height: top.toDouble(),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15)))),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Text('\$$top',
                style: const TextStyle(color: Colors.white, fontSize: 12)),
          ],
        ),
      );

  Widget _paymentContainer(String status, String amount, bool isPanding) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
            width: 160,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: isPanding
                  ? const Color.fromRGBO(205, 232, 217, .7)
                  : const Color(0xffEAEAEA),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(status,
                    style: poppinsRegular.copyWith(
                      fontSize: 14,
                      color: AppColors.blackColor,
                    ),),
                Text('\$ $amount',
                    style: poppinsSemiBold.copyWith(
                      fontSize: 24,
                      color: AppColors.blackColor,
                    ),
                ),
              ],
            ),),
      );

  List<int> _weekEarning() {
    if (localModel == null) [];

    var thisWeek = localModel!.thisMonthOrders
        .where((element) =>
            element.updatedAt
                .compareTo(DateTime.now().subtract(const Duration(days: 7))) ==
            1)
        .map((e) => double.tryParse(e.deliveryPrice.toString())?.toInt() ?? 0)
        .toList();
     totalStops=thisWeek.length;
    totalEarningInWeek = thisWeek
        .fold<double>(0, (previousValue, element) => previousValue + element)
        .toInt();

    return thisWeek.toList();
  }

  _lastWeekEarning() {
    if (localModel == null) [];
    localModel!.thisWeekEarning.forEach((element) {
      print(element.day);
      print(element.total_earning);
    });
    data = [
      _SalesData('Mon', localModel!.thisWeekEarning.firstWhereOrNull((element) => element.day.toLowerCase()=='mon')==null?0:
      double.parse(localModel!.thisWeekEarning.firstWhereOrNull((element) => element.day.toLowerCase()=='mon')!.total_earning),
          localModel!.thisWeekEarning.firstWhereOrNull((element) => element.day.toLowerCase()=='mon')==null?"":
          localModel!.thisWeekEarning.firstWhereOrNull((element) => element.day.toLowerCase()=='mon')!.date.toString()
      ),

      _SalesData('Tue', localModel!.thisWeekEarning.firstWhereOrNull((element) => element.day.toLowerCase()=='tue')==null?0:
      double.parse(localModel!.thisWeekEarning.firstWhereOrNull((element) => element.day.toLowerCase()=='tue')!.total_earning),
          localModel!.thisWeekEarning.firstWhereOrNull((element) => element.day.toLowerCase()=='tue')==null?'':
          localModel!.thisWeekEarning.firstWhereOrNull((element) => element.day.toLowerCase()=='tue')!.date.toString()
      ),

      _SalesData('Wed', localModel!.thisWeekEarning.firstWhereOrNull((element) => element.day.toLowerCase()=='wed')==null?0:
      double.parse(localModel!.thisWeekEarning.firstWhereOrNull((element) => element.day.toLowerCase()=='wed')!.total_earning),
          localModel!.thisWeekEarning.firstWhereOrNull((element) => element.day.toLowerCase()=='wed')==null?'':
          localModel!.thisWeekEarning.firstWhereOrNull((element) => element.day.toLowerCase()=='wed')!.date.toString()

      ),

      _SalesData('Thu', localModel!.thisWeekEarning.firstWhereOrNull((element) => element.day.toLowerCase()=='thu')==null?0:
      double.parse(localModel!.thisWeekEarning.firstWhereOrNull((element) => element.day.toLowerCase()=='thu')!.total_earning),
          localModel!.thisWeekEarning.firstWhereOrNull((element) => element.day.toLowerCase()=='thu')==null?"":
          localModel!.thisWeekEarning.firstWhereOrNull((element) => element.day.toLowerCase()=='thu')!.date.toString()
      ),

      _SalesData('Fri', localModel!.thisWeekEarning.firstWhereOrNull((element) => element.day.toLowerCase()=='fri')==null?0:
      double.parse(localModel!.thisWeekEarning.firstWhereOrNull((element) => element.day.toLowerCase()=='fri')!.total_earning),
          localModel!.thisWeekEarning.firstWhereOrNull((element) => element.day.toLowerCase()=='fri')==null?"":
          localModel!.thisWeekEarning.firstWhereOrNull((element) => element.day.toLowerCase()=='fri')!.date.toString()
      ),

      _SalesData('Sat', localModel!.thisWeekEarning.firstWhereOrNull((element) => element.day.toLowerCase()=='sat')==null?0:
      double.parse(localModel!.thisWeekEarning.firstWhereOrNull((element) => element.day.toLowerCase()=='sat')!.total_earning),
          localModel!.thisWeekEarning.firstWhereOrNull((element) => element.day.toLowerCase()=='sat')==null?"":
          localModel!.thisWeekEarning.firstWhereOrNull((element) => element.day.toLowerCase()=='sat')!.date.toString()

      ),

      _SalesData('Sun', localModel!.thisWeekEarning.firstWhereOrNull((element) => element.day.toLowerCase()=='sun')==null?0:
      double.parse(localModel!.thisWeekEarning.firstWhereOrNull((element) => element.day.toLowerCase()=='sun')!.total_earning),
          localModel!.thisWeekEarning.firstWhereOrNull((element) => element.day.toLowerCase()=='sun')==null?'':
          localModel!.thisWeekEarning.firstWhereOrNull((element) => element.day.toLowerCase()=='sun')!.date.toString()

      ),

    ];  }
}
class _SalesData {
  _SalesData(this.year, this.sales,this.date);

  final String year;
  final String date;
  final double sales;
}