class Urls {
  static const String _baseUrl = 'https://task.teamrabbil.com/api/v1';

  static const String registration = '$_baseUrl/registration';
  static const String login = '$_baseUrl/login';
  static const String createTask = '$_baseUrl/createTask';
  static const String newTask = '$_baseUrl/listTaskByStatus/New';
  static const String progressedTask = '$_baseUrl/listTaskByStatus/Progressed';
  static const String completedTask = '$_baseUrl/listTaskByStatus/Completed';
  static const String canceledTask = '$_baseUrl/listTaskByStatus/Canceled';
  static const String taskStatusCount = '$_baseUrl/taskStatusCount';
  static String deleteTask(String id) => '$_baseUrl/deleteTask/$id';
  static const String updateProfile = '$_baseUrl/profileUpdate';
  static String updateTaskStatus(String id, String status) => '$_baseUrl/updateTaskStatus/$id/$status';
  static String recoveryEmail(String email) => '$_baseUrl/RecoverVerifyEmail/$email';
  static String recoveryVerifyOTP(String email, String otp) => '$_baseUrl/RecoverVerifyOTP/$email/$otp';
  static String recoverResetPass = '$_baseUrl/RecoverResetPass';
}