// lib/core/constants/api.dart
import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;

class ApiConstants {
  static String androidHost = 'localhost';
  static String iosHost = 'localhost';
  static String webHost = 'localhost';
  static int port = 3000;

  static String get baseUrl {
    if (kIsWeb) return 'http://$webHost:$port';
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://$androidHost:$port';
    } else {
      return 'http://$iosHost:$port';
    }
  }

  static String get baseServerUrl => baseUrl;

  // Auth routes
  static String get register => '$baseUrl/api/auth/register';
  static String get login => '$baseUrl/api/auth/login';
  static String get sendVerifyCode => '$baseUrl/api/auth/send-verify-code';
  static String get verifyAccount => '$baseUrl/api/auth/verify-account';
  static String get resetPassword => '$baseUrl/api/auth/reset-password';

  // Profile routes
  static String get profile => '$baseUrl/api/profile';
  static String get updateProfile => '$baseUrl/api/profile';

  // Tour Type routes
  static String get tourtype => '$baseUrl/api/tour-types/tour_type';

  // Tour Categories routes
  static String get tourcategories => '$baseUrl/api/tour-categories';

  // Tour routes
  static String get tours => '$baseUrl/api/tours';
  static String get latestTours => '$baseUrl/api/tours/latest';
  static String tourById(int id) => '$baseUrl/api/tours/$id';
  static String updateTour(int id) => '$baseUrl/api/tours/$id';
  static String deleteTour(int id) => '$baseUrl/api/tours/$id';
  static String get createTour => '$baseUrl/api/tours';

  // Tour Prices routes
  static String get tourPrices => '$baseUrl/api/tour-prices/prices';
  static String get tourAssignments => '$baseUrl/api/tour-prices/assignments';
  static String get tourPriceTours => '$baseUrl/api/tour-prices/tours';
  static String tourAssignmentByTour(int tourId) =>
      '$baseUrl/api/tour-prices/assignment/$tourId';

  // Tour Images routes
  static String firstImage(int tourId) =>
      '$baseUrl/api/tour-images/first/$tourId';
  static String allImages(int tourId) => '$baseUrl/api/tour-images/all/$tourId';

  // Tour Locations routes
  static String get tourLocations => '$baseUrl/api/tour-locations';
  static String tourLocationsByTour(int tourId) =>
      '$baseUrl/api/tour-locations/$tourId';

  // Post Images routes
  static String get posts => '$baseUrl/api/posts';
  static String updatePost(String id) => '$baseUrl/api/posts/$id';
  static String deletePost(String id) => '$baseUrl/api/posts/$id';
  static String postsByUser(String userId) => '$baseUrl/api/posts/user/$userId';

  // Post Reactions routes
  static String get postReactions => '$baseUrl/api/post-reactions';
  static String postReactionsByPost(String postId) =>
      '$postReactions/post/$postId';
  static String userReaction(String userId, String postId) =>
      '$postReactions/user/$userId/post/$postId';

  // Post Comments routes
  static String get postComments => '$baseUrl/api/post-comments';
  static String postCommentsByPost(String postId) =>
      '$postComments/post/$postId';
  static String postCommentCount(String postId) =>
      '$postComments/post/$postId/count';
  static String updateComment(String commentId) => '$postComments/$commentId';
  static String deleteComment(String commentId) => '$postComments/$commentId';

  // Post Shares routes
  static String get postShares => '$baseUrl/api/post-shares';
  static String postSharesByPost(String postId) => '$postShares/post/$postId';
  static String postShareCount(String postId) =>
      '$postShares/post/$postId/count';

  // Orders routes
  static String get orders => '$baseUrl/api/orders';
  static String orderById(int id) => '$baseUrl/api/orders/$id';
  static String updateOrderStatus(int id) => '$baseUrl/api/orders/$id/status';
  static String userCompleted(int id) =>
      '$baseUrl/api/orders/$id/user-completed';

  // Tour Schedules routes
  static String get schedules => '$baseUrl/api/tour-schedules';
  static String schedulesByTour(int tourId) =>
      '$baseUrl/api/tour-schedules/tour/$tourId';
  static String get scheduleTours => '$baseUrl/api/tour-schedules/tours/list';

  // Payments routes
  static String get payments => '$baseUrl/api/payments';
  static String paymentByOrder(int orderId) => '$baseUrl/api/payments/$orderId';

  static String get momoPayment => '$baseUrl/api/momo/payment';

  static String momoRedirect(String orderId) =>
      '$baseUrl/api/momo/redirect?orderId=$orderId';
  static String get momoIpn => '$baseUrl/api/momo/ipn';

  // Notifications routes
  static String get notifications => '$baseUrl/api/notifications';
  static String notificationsByUser(String userId) =>
      '$notifications/user/$userId';
  static String unreadNotifications(String userId) =>
      '$notifications/user/$userId/unread-count';
  static String markAllNotifications(String userId) =>
      '$notifications/user/$userId/read-all';
  static String markNotification(int id) => '$notifications/$id/read';
  static String deleteNotification(int id) => '$notifications/$id';

  // Tour Guide routes
  static String get tourGuides => '$baseUrl/api/tour-guides';
  static String tourGuidesByTour(int tourId) =>
      '$baseUrl/api/tour-guide-assignment/$tourId';

  // Tour Ratings routes
  static String submitRating(int tourId) => '$baseUrl/api/tours/$tourId/rating';

  static String getRating(int tourId) => '$baseUrl/api/tours/$tourId/rating';
}
