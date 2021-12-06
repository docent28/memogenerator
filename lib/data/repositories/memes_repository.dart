import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:memogenerator/data/models/meme.dart';
import 'package:memogenerator/data/shared_preference_data.dart';
import 'package:rxdart/rxdart.dart';
import 'package:collection/collection.dart';


class MemesRepository {
  final updater = PublishSubject<Null>();
  final SharedPreferenceData spData;

  static MemesRepository? _instance;

  factory MemesRepository.getInstance() => _instance ??=
      MemesRepository._internal(SharedPreferenceData.getInstance());

  MemesRepository._internal(this.spData);

  Future<bool> addToMemes(final Meme meme) async {
    final rawMemes = await spData.getMemes();
    //////////////////////////////////////////////

   final findId = rawMemes.firstWhereOrNull((element) => Meme.fromJson(json.decode(element)).id== meme.id);
   final findIdd = rawMemes.indexOf(json.encode(meme.toJson()));
   final findIddd = rawMemes.indexOf(meme.toJson().toString());

   // final findIdddd = rawMemes.map((meme){
   //   var index =    rawMemes.indexOf(meme);
   //   return Container();
   // }).toList();

//  .indexOf(json.encode(meme.toJson()));

    /////////////////////////////////////////////
    rawMemes.add(json.encode(meme.toJson()));
    return _setRawMemes(rawMemes);
  }

  Future<bool> removeFromMemes(final String id) async {
    final memes = await getMemes();
    memes.removeWhere((meme) => meme.id == id);
    return _setMemes(memes);
  }

  Stream<List<Meme>> observeMemes() async* {
    yield await getMemes();
    await for (final _ in updater) {
      yield await getMemes();
    }
  }

  Future<List<Meme>> getMemes() async {
    final rawMemes = await spData.getMemes();
    return rawMemes
        .map((rawMeme) => Meme.fromJson(json.decode(rawMeme)))
        .toList();
  }

  Future<Meme?> getMeme(final String id) async {
    final memes = await getMemes();
    return memes.firstWhereOrNull((meme) => meme.id == id);
  }

  Future<bool> _setMemes(final List<Meme> memes) async {
    final rawMemes = memes.map((meme) => json.encode(meme.toJson())).toList();
    return _setRawMemes(rawMemes);
  }

  Future<bool> _setRawMemes(final List<String> rawMemes) {
    updater.add(null);
    return spData.setMemes(rawMemes);
  }
}
