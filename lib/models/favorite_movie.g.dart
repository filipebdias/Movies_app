// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_movie.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavoriteMovieAdapter extends TypeAdapter<FavoriteMovie> {
  @override
  final int typeId = 0;

  @override
  FavoriteMovie read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavoriteMovie(
      title: fields[0] as String,
      overview: fields[1] as String,
      posterPath: fields[2] as String,
      releaseDate: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FavoriteMovie obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.overview)
      ..writeByte(2)
      ..write(obj.posterPath)
      ..writeByte(3)
      ..write(obj.releaseDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteMovieAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
