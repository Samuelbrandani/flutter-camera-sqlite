import 'package:camera_sqlite/DAO/Sqlite/DBCreator.dart';
import 'package:camera_sqlite/Models/Photo.dart';

class DBHelper {
  save(Photo save) async {
    print(save.id);
    print(save.photoName);
    var res = await db.rawInsert(
      "INSERT into ${DatabaseCreator.TABLE} ( ${DatabaseCreator.ID}, ${DatabaseCreator.NAME} ) VALUES ( ${save.id}, '${save.photoName}' )",
    );
    return res;
  }

  Future<List<Photo>> getPhotos() async {
    List<Map> maps =
        await db.rawQuery("SELECT * FROM ${DatabaseCreator.TABLE}");
    List<Photo> employees = [];
    if (maps != null) {
      if (maps.length > 0) {
        for (int i = 0; i < maps.length; i++) {
          employees.add(Photo.fromMap(maps[i]));
        }
      }
    }
    return employees;
  }

  Future close() async {
    db.close();
  }
}
