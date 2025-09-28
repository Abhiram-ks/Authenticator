class PasswordGenerationOptions {
  final bool includeDigits;
  final bool includeLowercase;
  final bool includeUppercase;
  final bool includeSpecialCharacters;
  final int length;

  const PasswordGenerationOptions({
    this.includeDigits = true,
    this.includeLowercase = true,
    this.includeUppercase = true,
    this.includeSpecialCharacters = true,
    this.length = 12,
  });

  PasswordGenerationOptions copyWith({
    bool? includeDigits,
    bool? includeLowercase,
    bool? includeUppercase,
    bool? includeSpecialCharacters,
    int? length,
  }) {
    return PasswordGenerationOptions(
      includeDigits: includeDigits ?? this.includeDigits,
      includeLowercase: includeLowercase ?? this.includeLowercase,
      includeUppercase: includeUppercase ?? this.includeUppercase,
      includeSpecialCharacters: includeSpecialCharacters ?? this.includeSpecialCharacters,
      length: length ?? this.length,
    );
  }

  bool get hasValidOptions {
    return (includeDigits || includeLowercase || includeUppercase || includeSpecialCharacters) &&
           length > 0;
  }

  @override
  String toString() {
    return 'PasswordGenerationOptions(includeDigits: $includeDigits, includeLowercase: $includeLowercase, includeUppercase: $includeUppercase, includeSpecialCharacters: $includeSpecialCharacters, length: $length)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PasswordGenerationOptions &&
        other.includeDigits == includeDigits &&
        other.includeLowercase == includeLowercase &&
        other.includeUppercase == includeUppercase &&
        other.includeSpecialCharacters == includeSpecialCharacters &&
        other.length == length;
  }

  @override
  int get hashCode {
    return includeDigits.hashCode ^
        includeLowercase.hashCode ^
        includeUppercase.hashCode ^
        includeSpecialCharacters.hashCode ^
        length.hashCode;
  }
}
