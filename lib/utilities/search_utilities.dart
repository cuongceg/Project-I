class SearchUtilities{
  String extractString(String input) {
    final regex = RegExp(r'\(([^)]+)\)');
    final match = regex.firstMatch(input);
    return match != null ? match.group(1) ?? '' : '';
  }
}