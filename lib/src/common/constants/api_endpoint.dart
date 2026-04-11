class ApiEndpoint {
  const ApiEndpoint._();

  static const String chat = '/chat';

  static const String updateEstimate = '/estimates/{id}';
  static const String getEstimate = '/estimates/{id}';

  static const String convertEstimateToInvoice =
      '/users/{userId}/estimates/{estimateId}/invoice';
  static const String convertEstimateToProposal =
      '/users/{userId}/estimates/{estimateId}/proposal';

  static const String projects = '/users/{userId}/projects';

  static const String projectStatuses = '/users/{userId}/project-statuses';
  static const String updateProjectStatus = '/projects/{projectId}/status';

  static const String createStatus = '/users/{userId}/project-statuses';
  static const String updateStatus =
      '/users/{userId}/project-statuses/{statusId}';
  static const String deleteStatus =
      '/users/{userId}/project-statuses/{statusId}';
}
