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

  Map<K, List<T>> groupBy<K>(K Function(T) keyFunction) => fold(
      <K, List<T>>{},
      (Map<K, List<T>> map, T element) =>
          map..putIfAbsent(keyFunction(element), () => <T>[]).add(element));
}

class InvalidPrefixError extends Error {}
