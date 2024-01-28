import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mostlyrx/core/apimodels/order_response.dart';
import 'package:mostlyrx/core/constants/utils.dart';
import 'package:mostlyrx/core/models/notifications_model.dart';
import 'package:mostlyrx/core/models/user.dart';
import 'package:mostlyrx/core/viewmodels/views/orders_view_model.dart';
import 'package:mostlyrx/ui/constants/colors.dart';
import 'package:mostlyrx/ui/constants/styles.dart';
import 'package:mostlyrx/ui/view/base_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrdersView extends StatefulWidget {
  const OrdersView({Key? key}) : super(key: key);
  @override
  State<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> with TickerProviderStateMixin {
  SharedPreferences? sharedPreferences;
  late NotificationModel? notificationModel;
  int selectedIndex = 0;
  late TabController viwerController;
  late TabController tabController;

  @override
  void initState() {
    SharedPreferences.getInstance().then((value) => sharedPreferences = value);
    viwerController = TabController(length: 3, vsync: this);
    tabController = TabController(length: 3, vsync: this);
    viwerController.addListener(() {
      setState(() {
        selectedIndex = viwerController.index;
      });
      tabController.animateTo(viwerController.index);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<User?>(context);
    notificationModel = Provider.of<NotificationModel?>(context, listen: false);
    return BaseWidget<OrdersViewModel>(
      model: OrdersViewModel(orderService: Provider.of(context)),
      onModelReady: (model) =>
          model.getOrderCollection(user?.id.toString() ?? ''),
      builder: (context, model, child) => model.busy
          ? const Center(child: CircularProgressIndicator())
          : model.orderCollection != null
              ? tabView(model.orderCollection!)
              : const Center(
                  child: Text('No Activity to show...'),
                ),
    );
  }

  tabView(OrderCollection collection) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        shadowColor: AppColors.blackColor.withOpacity(0.3),
        elevation: 5.0,
        title: Text(
          'My orders',
          style: poppinsSemiBold.copyWith(
            fontSize: 20,
            color: AppColors.greyDark,
          ),
        ),
        bottom: TabBar(
          indicatorSize: TabBarIndicatorSize.label,
          controller: tabController,
          indicator: const BoxDecoration(color: Colors.transparent),
          isScrollable: true,
          onTap: (index) {
            viwerController.animateTo(index);
            if (mounted) {
              setState(() {
                selectedIndex = index;
              });
            }
          },
          tabs: [
            tabBarIndicator('Acitve (${collection.active?.length ?? 0})', 0),
            tabBarIndicator(
                'Delivered (${collection.completed?.length ?? 0})', 1),
            tabBarIndicator(
                'Cancelled (${collection.cancelled?.length ?? 0})', 2),
          ],
        ),
      ),
      body: TabBarView(
        controller: viwerController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          getDataList(collection.active, isActive: true),
          getDataList(collection.completed),
          getDataList(collection.cancelled),
        ],
      ),
    );
  }

  getDataList(List<Order>? orders, {bool isActive = false}) {
    if (orders != null && orders.isNotEmpty && isActive) {
      var modelsID = orders.map((e) => e.id.toString()).toList();
      var listOfVus = sharedPreferences!.getStringList('v_orders');
      if (listOfVus == null) {
        // Utils.playSound();
      } else {
        for (var id in modelsID) {
          if (!listOfVus.contains(id)) {
            // Utils.playSound();
            break;
          }
        }
      }
      sharedPreferences!.setStringList('v_orders', modelsID);
    }
    return (orders == null || orders.isEmpty)
        ? const Center(
            child: Text('No Activity to show...'),
          )
        : ListView.builder(
            itemCount: orders.length,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return OrderCard(orders[index], isFirst: index == 0);
            },
          );
  }

  tabBarIndicator(String text, int index) => Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 15),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: selectedIndex == index
              ? AppColors.yellowColor
              : AppColors.whiteColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: selectedIndex == index
              ? null
              : [
                  BoxShadow(
                    color: AppColors.blackColor.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Text(
          text,
          style: poppinsBold.copyWith(
            color: selectedIndex == index
                ? AppColors.blackColor
                : AppColors.greenLight,
          ),
        ),
      );
}

class OrderCard extends StatelessWidget {
  final Order order;
  final bool isFirst;
  const OrderCard(
    this.order, {
    Key? key,
    required this.isFirst,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withOpacity(0.1),
            blurRadius: 4.0,
            offset: const Offset(0, 4.0),
          ),
        ],
        border: isFirst
            ? Border.all(
                color: AppColors.greenLight.withOpacity(0.5),
                width: 3.0,
              )
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  (order.pharmacy?.name ?? '').toUpperCase(),
                  maxLines: 1,
                  style: poppinsBold.copyWith(
                    fontSize: 18,
                    color: AppColors.primaryOneColor,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Image.asset('assets/icons/calenda.png', width: 20, height: 20),
              const SizedBox(width: 5),
              Text(
                DateFormat.yMMMd().format(
                  order.createdAt ?? DateTime.now(),
                ),
                style: poppinsRegular.copyWith(
                  fontSize: 14,
                  color: AppColors.greyText,
                ),
              ),
            ],
          ),
          Text(
            'Pickup Address:',
            style: poppinsSemiBold.copyWith(
              fontSize: 14,
              color: AppColors.greenLight,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            order.pharmacy?.address ?? '',
            style: poppinsRegular.copyWith(
              fontSize: 13,
              color: AppColors.blackColor,
            ),
          ),
          const SizedBox(height: 7),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: 90,
                height: 25,
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed('/order_details', arguments: order);
                  },
                  child: Text(
                    'View',
                    style: poppinsSemiBold.copyWith(
                      fontSize: 12,
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),
              ),
              if (DateTime.now().difference(order.createdAt!) <
                  const Duration(days: 1))
                SizedBox(width: height * 0.012),
              if (DateTime.now().difference(order.createdAt!) <
                  const Duration(days: 1))
                Container(
                  width: 90,
                  height: 25,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF0000),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      'New',
                      style: poppinsSemiBold.copyWith(
                        fontSize: 12,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String getTotalDeliveryPrice(List<OrderRequest> orderRequests) {
    double totalEarning = 0;
    for (OrderRequest orderRequest in orderRequests) {
      totalEarning = totalEarning + orderRequest.deliveryPrice!;
    }
    return totalEarning.toString();
  }
}
