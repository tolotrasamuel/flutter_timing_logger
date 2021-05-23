library timing_logger;

import 'package:flutter/foundation.dart';

/// A utility class to help log timings splits throughout a method call.
/// Typical usage is:
///
/// <pre>
///     TimingLogger timings = new TimingLogger(TAG, "methodA");
///     // ... do some work A ...
///     timings.addSplit("work A");
///     // ... do some work B ...
///     timings.addSplit("work B");
///     // ... do some work C ...
///     timings.addSplit("work C");
///     timings.dumpToLog();
/// </pre>
///
/// <p>The dumpToLog call would add the following to the log:</p>
///
/// <pre>
///     D/TAG     ( 3459): methodA: begin
///     D/TAG     ( 3459): methodA:      9 ms, work A
///     D/TAG     ( 3459): methodA:      1 ms, work B
///     D/TAG     ( 3459): methodA:      6 ms, work C
///     D/TAG     ( 3459): methodA: end, 16 ms
/// </pre>
class TimingLogger {
  /// The Log tag to use for checking Log.isLoggable and for
  /// logging the timings.
  String? mTag;

  /// A label to be included in every log. */
  String? mLabel;

  /// Used to track whether Log.isLoggable was enabled at reset time. */
  late bool mDisabled;

  /// Stores the time of each split. */
  List<int>? mSplits;

  /// Stores the labels for each split. */
  late List<String?> mSplitLabels;

  /// Create and initialize a TimingLogger object that will log using
  /// the specific tag. If the Log.isLoggable is not enabled to at
  /// least the Log.VERBOSE level for that tag at creation time then
  /// the addSplit and dumpToLog call will do nothing.
  /// @param tag the log tag to use while logging the timings
  /// @param label a string to be displayed with each log
  TimingLogger(String tag, String label) {
    init(tag, label);
  }

  /// Clear and initialize a TimingLogger object that will log using
  /// the specific tag. If the Log.isLoggable is not enabled to at
  /// least the Log.VERBOSE level for that tag at creation time then
  /// the addSplit and dumpToLog call will do nothing.
  /// @param tag the log tag to use while logging the timings
  /// @param label a string to be displayed with each log
  void init(String tag, String label) {
    mTag = tag;
    mLabel = label;
    reset();
  }

  /// Clear and initialize a TimingLogger object that will log using
  /// the tag and label that was specified previously, either via
  /// the constructor or a call to reset(tag, label). If the
  /// Log.isLoggable is not enabled to at least the Log.VERBOSE
  /// level for that tag at creation time then the addSplit and
  /// dumpToLog call will do nothing.
  void reset() {
    mDisabled = kReleaseMode;
//    !Log.isLoggable(mTag, Log.VERBOSE);
    if (mDisabled) return;
    if (mSplits == null) {
      mSplits = [];
      mSplitLabels = [];
    } else {
      mSplits!.clear();
      mSplitLabels.clear();
    }
    addSplit(null);
  }

  /// Add a split for the current time, labeled with splitLabel. If
  /// Log.isLoggable was not enabled to at least the Log.VERBOSE for
  /// the specified tag at construction or reset() time then this
  /// call does nothing.
  /// @param splitLabel a label to associate with this split.
  void addSplit(String? splitLabel) {
    if (mDisabled) return;
    int now = DateTime.now().millisecondsSinceEpoch;
    mSplits!.add(now);
    mSplitLabels.add(splitLabel);
  }

  /// Dumps the timings to the log using Log.d(). If Log.isLoggable was
  /// not enabled to at least the Log.VERBOSE for the specified tag at
  /// construction or reset() time then this call does nothing.
  void dumpToLog() {
    if (mDisabled) return;
    print("$mTag, $mLabel: begin");
    final int first = mSplits![0];
    int now = first;
    for (int i = 1; i < mSplits!.length; i++) {
      now = mSplits![i];
      final String? splitLabel = mSplitLabels[i];
      final int prev = mSplits![i - 1];

      print("$mTag, $mLabel:       ${(now - prev)}  ms, $splitLabel");
    }
    print("$mTag, $mLabel: end, ${(now - first)}  ms");
  }
}
