class FullFile {
  final List<UploadedFile> files;

  const FullFile({required this.files});

  factory FullFile.fromJson(List<dynamic> parsedJson) {
    List<UploadedFile> files = [];
    files = parsedJson.map((i) => UploadedFile.fromJson(i)).toList();

    return FullFile(files: files);
  }
}

class UploadedFile {
  final int id;
  final String fileName;
  final String fileExtension;
  final String fileUrl;
  final String? description;
  final int sharedTo;
  final int uploadedBy;
  final String createdAt;
  final String updatedAt;

  const UploadedFile({
    required this.id,
    required this.fileName,
    required this.fileExtension,
    required this.fileUrl,
    this.description,
    required this.sharedTo,
    required this.uploadedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UploadedFile.fromJson(Map<String, dynamic> json) {
    return UploadedFile(
      id: json['id'],
      fileName: json['file_name'],
      fileExtension: json['file_extention'],
      fileUrl: json['file_url'],
      description: json['description'],
      sharedTo: json['shared_to'],
      uploadedBy: json['uploaded_by'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
