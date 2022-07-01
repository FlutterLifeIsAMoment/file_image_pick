import 'file_image_pick.dart';
import '../model/file_image_model.dart';

class FileChooseManager {
  static final _instance = FileChooseManager._internal();
  static FileChooseManager get instance => _instance;
  factory FileChooseManager() {
    return _instance;
  }
  FileChooseManager._internal();

  //open choose file
  Future<FileImageModel> openChooseFile() async {
    final fileMap = await FileImagePick.openChooseFile;
    FileImageModel fileModel = FileImageModel.fromJson(fileMap);
    return fileModel;
  }

  //get Image
  Future<FileImageModel> getImage() async {
    final fileMap = await FileImagePick.getImage;
    FileImageModel fileModel = FileImageModel.fromJson(fileMap);
    return fileModel;
  }
}
