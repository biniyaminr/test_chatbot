class ChatbotFeedback {
  String? feedback;
  // List<String>? recommendation;

  ChatbotFeedback({this.feedback});

  ChatbotFeedback.fromJson(Map<String, dynamic> json) {
    feedback = json['feedback'];
    // recommendation = json['recommendation'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['feedback'] = this.feedback;
    // data['recommendation'] = this.recommendation;
    return data;
  }
}