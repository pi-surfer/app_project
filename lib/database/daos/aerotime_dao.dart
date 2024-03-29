import 'package:floor/floor.dart';
import 'package:app_project/database/entities/entities.dart';

@dao
abstract class AerobicTimeDao {
  
  @Query('SELECT * FROM AEROBICTIME AT DAY :dateTime')
  Future<AerobicTime?> findAerobicTimebyDate(String dateTime);

  @Query('SELECT * FROM AEROBICTIME')
  Future<List<AerobicTime>> findAllAerobicTime();

  @insert
  Future<void> insertAerobicTime(AerobicTime aerobicTime);

  @delete
  Future<void> deleteAerobicTime(AerobicTime aerobicTime);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> updateAerobicTime(AerobicTime aerobicTime);
}