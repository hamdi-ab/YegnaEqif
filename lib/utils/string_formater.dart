// utils/string_utils.dart

String formatAccountNumber(String accountNumber, {int chunkSize = 4, String separator = ' '}) {
  final buffer = StringBuffer();
  for (int i = 0; i < accountNumber.length; i++) {
    if (i > 0 && i % chunkSize == 0) {
      buffer.write(separator);
    }
    buffer.write(accountNumber[i]);
  }
  return buffer.toString();
}
