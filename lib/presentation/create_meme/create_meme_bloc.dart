import 'package:memogenerator/presentation/create_meme/models/meme_text.dart';
import 'package:memogenerator/presentation/create_meme/models/meme_text_with_selection.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';
import 'package:collection/collection.dart';

class CreateMemeBloc {
  final memeTextsSubject = BehaviorSubject<List<MemeText>>.seeded(<MemeText>[]);
  final selectedMemeTextSubject = BehaviorSubject<MemeText?>.seeded(null);

  void addNewText() {
    final newMemeText = MemeText.create();
    memeTextsSubject.add([...memeTextsSubject.value, newMemeText]);
    selectedMemeTextSubject.add(newMemeText);
  }

  void changeMemeText(final String id, final String text) {
    final copiedList = [...memeTextsSubject.value];
    final index = copiedList.indexWhere((memeText) => memeText.id == id);
    if (index == -1) {
      return;
    }
    copiedList.removeAt(index);
    copiedList.insert(index, MemeText(id: id, text: text));
    memeTextsSubject.add(copiedList);
  }

  void selectMemeText(final String id) {
    final foundMemeText = memeTextsSubject.value
        .firstWhereOrNull((memeText) => memeText.id == id);
    selectedMemeTextSubject.add(foundMemeText);
  }

  void deselectMemeText() {
    selectedMemeTextSubject.add(null);
  }

  Stream<List<MemeText>> observeMemeTexts() => memeTextsSubject
      .distinct((prev, next) => ListEquality().equals(prev, next));

  Stream<MemeText?> observeSelectedMemeText() =>
      selectedMemeTextSubject.distinct();

  Stream<List<MemeTextWithSelection>> observeMemeTextsWithSelection() {
    return Rx.combineLatest2<List<MemeText>, MemeText?,
        List<MemeTextWithSelection>>(
      observeMemeTexts(),
      observeSelectedMemeText(),
      (memeText, selectedMemeText) {
        return memeText.map(
          (memeText) {
            return MemeTextWithSelection(
              memeText: memeText,
              selected: memeText.id == selectedMemeText?.id,
            );
          },
        ).toList();
      },
    );
  }

  void dispose() {
    memeTextsSubject.close();
    selectedMemeTextSubject.close();
  }
}
