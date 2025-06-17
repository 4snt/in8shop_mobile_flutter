String truncateText(String? text, {int maxLength = 25}) {
  if (text == null || text.isEmpty) return '';
  if (text.length <= maxLength) return text;
  return '${text.substring(0, maxLength)}...';
}
