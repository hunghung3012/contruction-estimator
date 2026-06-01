class ApiEndpoint {
  const ApiEndpoint._();

  //Chat
  static const String chat = '/chat';
  static const String chatHistory = '/users/{userId}/projects/{projectId}/chat/messages';

  //Estimates
  static const String createEstimate = '/projects/{projectId}/estimates';
  static const String updateEstimate = '/estimates/{id}';
  static const String getEstimate = '/estimates/{id}';
  static const String deleteEstimate = '/estimates/{estimateId}';
  static const String convertEstimateToInvoice =
      '/users/{userId}/estimates/{estimateId}/invoice';
  static const String createProposalFromEstimate =
      '/users/{userId}/estimates/{estimateId}/proposal';

  //Projects
  static const String projects = '/users/{userId}/projects';
  static const String estimatesFromProject = '/projects/{projectId}/estimates';

  //Projects status
  static const String projectStatuses = '/users/{userId}/project-statuses';
  static const String updateProjectStatus = '/projects/{projectId}/status';
  static const String createStatus = '/users/{userId}/project-statuses';
  static const String updateStatus =
      '/users/{userId}/project-statuses/{statusId}';
  static const String deleteStatus =
      '/users/{userId}/project-statuses/{statusId}';

  //Invoices
  static const invoices = '/users/{userId}/invoices';
  static const createInvoice = '/users/{userId}/invoices';
  static const updateInvoice = '/invoices/{invoiceId}';
  static const deleteInvoice = '/invoices/{invoiceId}';
  static const deleteAllInvoices = '/users/{userId}/invoices';

  //Proposals
  static const proposal = '/proposals/{proposalId}';
  static const proposals = '/users/{userId}/proposals';
  static const createProposal = '/users/{userId}/proposals';
  static const updateProposal = '/proposals/{proposalId}';
  static const deleteProposal = '/proposals/{proposalId}';
  static const deleteAllProposals = '/users/{userId}/proposals';

  //Change Orders
  static const changeOrders = '/users/{userId}/change-orders';
  static const createChangeOrder = '/users/{userId}/change-orders';
  static const updateChangeOrder = '/change-orders/{changeOrderId}';
  static const deleteChangeOrder = '/change-orders/{changeOrderId}';

  //Clients
  static const String client = '/users/{userId}/clients/{clientId}';
  static const String clients = '/users/{userId}/clients';
  static const String createClient = '/users/{userId}/clients';
  static const String updateClient = '/users/{userId}/clients/{clientId}';
  static const String deleteClient = '/users/{userId}/clients/{clientId}';
}
