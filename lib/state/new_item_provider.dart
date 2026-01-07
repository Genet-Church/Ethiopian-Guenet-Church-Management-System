import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'new_item_provider.g.dart';

@Riverpod(keepAlive: true)
class NewlyAddedItemId extends _$NewlyAddedItemId {
  @override
  String? build() {
    return null;
  }

  void set(String? id) {
    state = id;
  }
}