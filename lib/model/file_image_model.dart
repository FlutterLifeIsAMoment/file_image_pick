import 'dart:typed_data';

class FileImageModel {
  final bool isSuccess;
  final Uint8List? fileData;
  final String? filePath;
  final String? fileName;
  final String? failure;

  FileImageModel({
    required this.isSuccess,
    this.fileData,
    this.filePath,
    this.fileName,
    this.failure,
  });

  factory FileImageModel.fromJson(Map<String, dynamic> srcJson) => _$FileImageModelFromJson(srcJson);
}

FileImageModel _$FileImageModelFromJson(Map<String, dynamic> json) {
  return FileImageModel(
    isSuccess: json['isSuccess'] as bool,
    fileData: json['fileData'] != null ? json['fileData'] as Uint8List : null,
    filePath: json['filePath'] as String,
    fileName: json['fileName'] as String,
    failure: json['failure'] as String,
  );
}
