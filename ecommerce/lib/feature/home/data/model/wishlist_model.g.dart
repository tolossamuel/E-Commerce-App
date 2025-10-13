// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WishListModelAdapter extends TypeAdapter<WishListModel> {
  @override
  final int typeId = 1;

  @override
  WishListModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WishListModel(
      id: fields[0] as int,
      title: fields[1] as String,
      image: fields[2] as String,
      price: fields[3] as double,
      descr: fields[4] as String,
      rating: (fields[5] as Map).cast<String, dynamic>(),
      category: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, WishListModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.image)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.descr)
      ..writeByte(5)
      ..write(obj.rating)
      ..writeByte(6)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WishListModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
