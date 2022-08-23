class ImageHelper {

  ImageHelper({this.url, this.bucket});

  ImageHelper.fromMap(Map<String, dynamic> map) {
    url = map['url'] as String;
    bucket = map['bucket'] as String;
  }

  String? url;
  String? bucket;

  String get nomeImagem => bucket!.split('/').last;

}