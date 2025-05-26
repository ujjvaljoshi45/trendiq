import 'package:intl/intl.dart';
import 'package:trendiq/services/toast_service.dart';
import 'package:url_launcher/url_launcher_string.dart';

void launchUrl(String url) async {
  try {
    await launchUrlString(url, mode: LaunchMode.externalApplication);
  } catch (e) {
    ToastService().showToast("Unable to launch URL", isError: true);
  }
}

String getDateStr(DateTime date) {
  final res = DateFormat.yMMMMd().format(date);
  return res.splitMapJoin(",",onMatch: (p0) {
    return "${res[p0.start]}\n${res[p0.end]}";
  },);
}