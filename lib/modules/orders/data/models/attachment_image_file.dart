class AttachmentImageFile {
  String? front;
  String? back;

  AttachmentImageFile({this.front, this.back});

  AttachmentImageFile.fromJson(Map<String, dynamic> json) {
    front = json['front'];
    back = json['back'];
  }
}
