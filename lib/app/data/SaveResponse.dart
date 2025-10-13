
class SaveResponse{
  String? responseCode;
  dynamic responseMessage;

  SaveResponse({
    this.responseCode,
    this.responseMessage,
  });

  SaveResponse.fromJson(Map<String, dynamic> json) {
    responseCode = json['responseCode'];
    responseMessage = json['responseMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['responseCode'] = responseCode;
    data['responseMessage'] = responseMessage;
    return data;
  }
}