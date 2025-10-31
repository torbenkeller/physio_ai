extension ObjectExt<T> on T? {
  S? let<S>(S Function(T) fn) {
    if (this == null) return null;
    return fn(this as T);
  }
}

extension StringExt on String {
  String? get orEmpty => trim().isEmpty ? null : this;
}
