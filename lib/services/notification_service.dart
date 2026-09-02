import 'dart:async';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final _controller = StreamController<String>.broadcast();

  Stream<String> get notificationStream => _controller.stream;

  void triggerNotification(String message) {
    _controller.add(message);
  }

  void triggerWeatherAlert(String city, String alert) {
    triggerNotification("Weather Alert for $city: $alert");
  }

  void triggerOrderAlert(String crop, String status) {
    triggerNotification("Order Update: Your order for $crop is now $status.");
  }
}
