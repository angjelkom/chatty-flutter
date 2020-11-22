
class ChattyFile {
  final String file;
  final String thumbnail;

  ChattyFile({this.file, this.thumbnail});

  factory ChattyFile.fromJson(Map<String, dynamic> json) {
    if(json == null){
      return null;
    }
    return ChattyFile(
      file: json['file'],
      thumbnail: json['thumbnail'],
    );
  }
}