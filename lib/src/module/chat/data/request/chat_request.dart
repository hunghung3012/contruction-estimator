class ChatRequest {
    String? userId;
    String? message;
    String? conversationId;
    String? projectId;
    String? location;

    ChatRequest({
        this.userId,
        this.message,
        this.conversationId,
        this.projectId,
        this.location,
    });

    factory ChatRequest.fromJson(Map<String, dynamic> json) => ChatRequest(
        userId: json["userId"],
        message: json["message"],
        conversationId: json["conversationId"],
        projectId: json["projectId"],
        location: json["location"],
    );

    Map<String, dynamic> toJson() => {
        "userId": userId,
        "message": message,
        "conversationId": conversationId,
        "projectId": projectId,
        "location": location,
    };

    ChatRequest copyWith({
        String? userId,
        String? message,
        String? conversationId,
        String? projectId,
        String? location,
    }) => ChatRequest(
        userId: userId ?? this.userId,
        message: message ?? this.message,
        conversationId: conversationId ?? this.conversationId,
        projectId: projectId ?? this.projectId,
        location: location ?? this.location,
    );
}
