import 'package:floor/floor.dart';


@Entity(primaryKeys: ['dateTime'])
class Steps {
  final int value;
  final String dateTime;

  Steps(this.value, this.dateTime);
}