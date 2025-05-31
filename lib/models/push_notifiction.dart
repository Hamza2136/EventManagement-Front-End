// Model class for push notifications
class PushNotification {
  final String? title;
  final String? body;
  final String? dataTitle;
  final String? dataBody;
  final Map<String, dynamic>? data;

  PushNotification({
    this.title,
    this.body,
    this.dataTitle,
    this.dataBody,
    this.data,
  });
}