import 'package:mostlyrx/ui/constants/icons.dart';

class NotifyModel {
  final String iconPath;
  final String heading;
  final String description;
  final String time;

  NotifyModel({
    required this.iconPath,
    required this.heading,
    required this.description,
    required this.time,
  });
}

List<NotifyModel> todayItems = [
  NotifyModel(iconPath: AppIcons.reward, heading: 'Rewards', description: 'Loyal user rewards!😘', time: '1m ago'),
  NotifyModel(iconPath: AppIcons.moneyTransfer, heading: 'Money Transfer', description: 'You have successfully sent money to Maria of...', time: '10m ago'),
];

List<NotifyModel> weekItems = [
  NotifyModel(iconPath: AppIcons.paymentNotification, heading: 'Payment Notification', description: 'Successfully paid!🤑', time: 'Dec 23'),
  NotifyModel(iconPath: AppIcons.topup, heading: 'Top Up', description: 'Your top up is successfully!', time: 'Dec 20'),
  NotifyModel(iconPath: AppIcons.moneyTransfer, heading: 'Money Transfer', description: 'You have successfully sent money to Maria of...', time: 'Dec 20'),
  NotifyModel(iconPath: AppIcons.cashback, heading: 'Cashback 25%', description: 'You have successfully sent money to Maria of...', time: 'Dec 20'),
  NotifyModel(iconPath: AppIcons.paymentNotification, heading: 'Payment Notification', description: 'Successfully paid!🤑', time: 'Dec 19'),
];