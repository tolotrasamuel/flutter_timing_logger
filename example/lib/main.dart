import 'package:timing_logger/timing_logger.dart';

void main() {
  const TAG = 'TAG';
  TimingLogger timings = new TimingLogger(TAG, "methodA");
  // ... do some work A ...
  timings.addSplit("work A");
  // ... do some work B ...
  timings.addSplit("work B");
  // ... do some work C ...
  timings.addSplit("work C");
  timings.dumpToLog();
}
