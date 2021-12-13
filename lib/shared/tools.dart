extension IterableExtension<T> on Iterable<T> {
  Iterable<T> distinctBy(Object Function(T e) getComparableValue) {
    var result = <T>[];
    for (var element in this) {
      if (!result.any((x) => getComparableValue(x) == getComparableValue(x))) {
        result.add(element);
      }
    }

    return result;
  }
}
