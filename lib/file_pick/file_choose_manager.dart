import 'file_image_pick.dart';
import '../model/file_image_model.dart';

class FileChooseManager {
  Future<FileImageModel> openChooseFile() async {
    final fileMap = await FileImagePick.openChooseFile;
    FileImageModel fileModel = FileImageModel.fromJson(fileMap);
    return fileModel;
  }
}
