netdata : 19999
grafana : 3000
prometheus : 9090

1. Allow custom-checks/scripts
2. Server/client model
3. Aggregate views
4. Phase out ganglia

https://www.loomsystems.com/single-post/2017/06/07/Prometheus-vs-Grafana-vs-Graphite---A-Feature-Comparison
https://milinda.svbtle.com/cluster-and-service-monitoring-using-grafana-influxdb-and-collecd

== ganglia phaseout ==
wikimedia:
  https://wikitech.wikimedia.org/wiki/Prometheus#Replacing_Ganglia
  https://ganglia.wikimedia.org/latest/  # note 'ganglia deprecated in favour of grafana'


2017
Pretty, time-based, feature-rich Graphs.
Monitoring switches from rrd to Time Series databases.
  Before
    rrdtool used to store historical data
  Now
    stored in a time-series DB
    https://www.xaprb.com/blog/2014/03/02/time-series-databases-influxdb/
pull becomes popular.
legacy (nagios) checkers still useful as they give quick oneshot status of services

Need to carefully consider HPC monitoring vs Systems monitoring.
Cloud-based monitoring has rough synergy with HPC monitoring.

grafana (visualiser)
  need to tell it to read from a metrics collector (Prometheus)
  doesn't do long-term storage

netdata (visualiser)
  only has graphite as a backend
  seems can use influxdb
    https://blog.hda.me/2017/01/09/using-netdata-with-influxdb-backend.html

graphite (visualiser + backend)
  https://www.vividcortex.com/blog/2015/11/05/nobody-loves-graphite-anymore/
  http://obfuscurity.com/2015/11/Everybody-Loves-Graphite
  stores in whispher format, rrd-based,
  statsd/collectd as the backend/metrics scraper ?

prometheus (metrics collector)
  pull based metrics
  time-series database
  does not do long-term storage - you need a solution for that (Influx/Chronix)
    https://bitworking.org/news/2017/03/prometheus

collectd (metrics collector)

Influx/Chronix (metrics storage)
