class UploadResponseModel {
  final String publicId;
  final String secureUrl;
  final String format;
  final int bytes;

  UploadResponseModel({
    required this.publicId,
    required this.secureUrl,
    required this.format,
    required this.bytes,
  });

  factory UploadResponseModel.fromMap(Map<String, dynamic> map) {
    return UploadResponseModel(
      publicId: map['public_id'] ?? '',
      secureUrl: map['secure_url'] ?? '',
      format: map['format'] ?? '',
      bytes: map['bytes'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'public_id': publicId,
      'secure_url': secureUrl,
      'format': format,
      'bytes': bytes,
    };
  }
}
