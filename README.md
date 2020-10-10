# timing_logger

A utility class to help log timings splits throughout a method call.

## Getting Started

Typical usage is:

```
     TimingLogger timings = new TimingLogger(TAG, "methodA");
     // ... do some work A ...
     timings.addSplit("work A");
     // ... do some work B ...
     timings.addSplit("work B");
     // ... do some work C ...
     timings.addSplit("work C");
     timings.dumpToLog();
 ```

The dumpToLog call would add the following to the log:

```
     D/TAG     ( 3459): methodA: begin
     D/TAG     ( 3459): methodA:      9 ms, work A
     D/TAG     ( 3459): methodA:      1 ms, work B
     D/TAG     ( 3459): methodA:      6 ms, work C
     D/TAG     ( 3459): methodA: end, 16 ms
```