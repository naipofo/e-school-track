extension TogglableSet<T> on Set<T> {
  void toggle(T e) {
    if (contains(e)) {
      remove(e);
    } else {
      add(e);
    }
  }
}

extension MappableSet<T> on Set<T> {
  void editWithMap(Map<T, bool> table) {
    for (var el in table.entries) {
      if (el.value) {
        add(el.key);
      } else {
        remove(el.key);
      }
    }
  }
}
