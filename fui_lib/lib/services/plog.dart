import 'package:logger/logger.dart';

import 'package:fui_lib/fui_lib.dart';

class Plogger {
  Plogger({
    required this.level,
    required this.lip,
    required this.name,
    required this.platform,
  }) {
    logger = Logger(
      level: level,
      printer: PrettyPrinter(
        colors: true,
        lineLength: 120,
        methodCount: 0,
        printTime: true,
      ),
    );

    //NOTE: line length can be detected with io package, which cannot be imported
    // on web
    //var logger = Logger(
    //printer: PrettyPrinter(
    //methodCount: 2, // number of method calls to be displayed
    //errorMethodCount:
    //8, // number of method calls if stacktrace is provided
    //lineLength: 120, // width of the output
    //colors: true, // Colorful log messages
    //printEmojis: true, // Print an emoji for each log message
    //printTime: false // Should each log print contain a timestamp
    //),
    //);
  }
  final Level level;
  late final Lip lip;
  late final Logger logger;
  final String name;
  final String platform;

//logger.v("Verbose log");
//logger.d("Debug log");
//logger.i("Info log");
//logger.w("Warning log");
//logger.e("Error log");
//logger.wtf("What a terrible failure log");

  v(String msg) {
    logger.v(msg);
  }

  d(String msg) {
    logger.d(msg);
  }

  i(String msg) {
    logger.i(msg);
  }

  w(String msg) {
    logger.w(msg);
  }

  e(
    String msg, {
    String developerId = '',
    String instanceId = '',
    String surferId = '',
    String category = '',
    int code = -1,
    String meta = '',
    String platform = '',
    String toddMode = '',
    String version = '',
  }) {
    logger.e(msg);

    try {
      lip.api(EndpointsV1.plog, payload: {
        'msg': msg,
        'level': level,
        'developer_id': developerId,
        'instance_id': instanceId,
        'surfer_id': surferId,
        'category': category,
        'code': code,
        'meta': meta,
        'platform': platform,
        'todd_mode': toddMode,
        'version': version,
      });
    } catch (e) {
      logger.wtf('Failed to send plog to PAPI.');
    }
  }

  wtf(
    String msg, {
    String developerId = '',
    String instanceId = '',
    String surferId = '',
    String category = '',
    int code = -1,
    String meta = '',
    String platform = '',
    String toddMode = '',
    String version = '',
  }) {
    logger.wtf(msg);

    try {
      lip.api(EndpointsV1.plog, payload: {
        'msg': msg,
        'level': level,
        'developer_id': developerId,
        'instance_id': instanceId,
        'surfer_id': surferId,
        'category': category,
        'code': code,
        'meta': meta,
        'platform': platform,
        'todd_mode': toddMode,
        'version': version,
      });
    } catch (e) {
      logger.wtf('Failed to send plog to PAPI.');
    }
  }
}
