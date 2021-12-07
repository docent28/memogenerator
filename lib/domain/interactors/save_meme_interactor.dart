import 'dart:io';

import 'package:memogenerator/data/models/meme.dart';
import 'package:memogenerator/data/models/text_with_position.dart';
import 'package:memogenerator/data/repositories/memes_repository.dart';
import 'package:path_provider/path_provider.dart';

class SaveMemeInteractor {
  final String id;
  final List<TextWithPosition> textWithPositions;
  final String? imagePath;

  static SaveMemeInteractor? _instance;

  factory SaveMemeInteractor.getInstance() =>
      _instance ??= SaveMemeInteractor._internal(
        id: 'id',
        textWithPositions: [],
      );

  SaveMemeInteractor._internal({
    required this.id,
    required this.textWithPositions,
    this.imagePath,
  });

  Future<bool> saveMeme({
    required String id,
    required List<TextWithPosition> textWithPositions,
    final String? imagePath,
  }) async {
    // final imagePath = memePathSubject.value;
    if (imagePath == null) {
      final meme = Meme(id: id, texts: textWithPositions);
      return MemesRepository.getInstance().addToMemes(meme);
    }
    final docsPath = await getApplicationDocumentsDirectory();
    final memePath = "${docsPath.absolute.path}${Platform.pathSeparator}memes";
    await Directory(memePath).create(recursive: true);
    final imageName = imagePath.split(Platform.pathSeparator).last;
    final newImagePath = "$memePath${Platform.pathSeparator}$imageName";
    final tempFile = File(imagePath);
    await tempFile.copy(newImagePath);
    final meme = Meme(
      id: id,
      texts: textWithPositions,
      memePath: newImagePath,
    );
    return MemesRepository.getInstance().addToMemes(meme);
  }
}