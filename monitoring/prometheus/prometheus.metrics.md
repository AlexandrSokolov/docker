
Documentation:
- [Histograms and summaries](https://prometheus.io/docs/practices/histograms/)

Metric types:
- [Gauges](#gauge-metrics)
- Counters
- Summaries
- Histograms

- [PromQL Data Selection](#promql-data-selection)

### [Gauge metrics](https://prometheus.io/docs/concepts/metric_types/#gauge)

A Gauge is - is a metric that represents a single numerical value that can arbitrarily go up and down, 
providing a snapshot of the current state.


Unlike Counters, which are cumulative and always increase, 
Gauges are suitable for tracking values where the value can change dynamically like:
- memory usage
- the number of active connections
- queue length

### [Counter metrics](https://prometheus.io/docs/concepts/metric_types/#counter)

A counter is a cumulative metric that represents a single monotonically increasing counter 
whose value can only increase or be reset to zero on restart (Counter Reset). 

For example, you can use a counter to represent:
- the number of requests served
- tasks completed
- errors

Note: Do not use a counter to expose a value that can decrease. 
For example, do not use a counter for the number of currently running processes; instead use a gauge.

#### Querying counters

It is not useful to know absolute values of the counters.
We need to know how fast the counters go up over the preceding time window - the rates.

- rate(): `rate(my_counter[2h])`
- irate()
- increase()

### [Histogram metrics](https://prometheus.io/docs/concepts/metric_types/#histogram)

A histogram samples observations (usually things like request durations or response sizes) 
and counts them in configurable buckets. It also provides a sum of all observed values.

[Histograms and summaries](https://prometheus.io/docs/practices/histograms/)
[Histograms](https://youtu.be/fhx0ehppMGM?list=PLyBW7UHmEXgylLwxdVbrBQJ-fJ_jMvh8h&t=416)

### [Summary metrics](https://prometheus.io/docs/concepts/metric_types/#summary)

[Histograms and summaries](https://prometheus.io/docs/practices/histograms/)
[Quering Summaries](https://youtu.be/fhx0ehppMGM?list=PLyBW7UHmEXgylLwxdVbrBQJ-fJ_jMvh8h&t=361)


https://youtu.be/OxZmn4svOyA?list=PLyBW7UHmEXgylLwxdVbrBQJ-fJ_jMvh8h&t=429
https://youtu.be/fhx0ehppMGM?list=PLyBW7UHmEXgylLwxdVbrBQJ-fJ_jMvh8h&t=544


### Average requests latencies

https://youtu.be/fhx0ehppMGM?list=PLyBW7UHmEXgylLwxdVbrBQJ-fJ_jMvh8h&t=612

### PromQL Data Selection

PromQL Data Selection Explained | Selectors, Lookback Delta, Offsets, and Absolute "@" Timestamps
https://www.youtube.com/watch?v=xIAEEQwUBXQ&list=PLyBW7UHmEXgylLwxdVbrBQJ-fJ_jMvh8h&index=4&pp=iAQB

#### Instant Vector Selections - the latest value for a set of time series

### Docker daemon metrics