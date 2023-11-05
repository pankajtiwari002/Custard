// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../constants.dart';

// class NotificationMethods {
//   Future<void> sendNotificationWithProgressBar(int progress,int maxProgress) async {
//     final String apiUrl = 'https://onesignal.com/api/v1/notifications';

//     Map<String, dynamic> notificationData = {
//       'app_id': Constants.oneSignalAppId,
//       'contents': {'en': 'Downloading file...'},
//       'data': {'progress': progress}, // Set the progress value here (0-100)
//       'include_player_ids': [Constants.fCMToken],
//     };

//     var response = await http.post(
//       Uri.parse(apiUrl),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization':
//             Constants.oneSignalApiKey, // Replace with your OneSignal REST API key
//       },
//       body: jsonEncode(notificationData),
//     );

//     if (response.statusCode == 200) {
//       print('Notification sent successfully');
//     } else {
//       print('Error sending notification: ${response.statusCode}');
//     }
//   }
// }
