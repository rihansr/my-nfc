class Arguments<T> {
  const Arguments({
    this.tag,
    required this.data,
    this.additional,
  });

  final String? tag;
  final T data;
  final Map<String, dynamic>? additional;

  Arguments<T> copyWith({
    String? tag,
    T? data,
    Map<String, dynamic>? additional,
  }) {
    return Arguments<T>(
      tag: tag ?? this.tag,
      data: data ?? this.data,
      additional: additional ?? this.additional,
    );
  }
}
