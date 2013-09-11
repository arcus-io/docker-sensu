# Sensu

Sensu Monitoring

* `docker build -t sensu .`
* `docker run sensu`

Ports

* 8080

Environment Variables

* `DASHBOARD_USER`: Sensu dashboard username (default: admin)
* `DASHBOARD_PASS`: Sensu dashboard password (default: sensu)
* `SENSU_CONFIG_URL`: Sensu config url (will download as `/etc/sensu/config.json`)
* `SENSU_CLIENT_CONFIG_URL`: Sensu client config url (will download as `/etc/sensu/conf.d/client.json`)
* `SENSU_CHECKS_CONFIG_URL`: Sensu checks config url (will download as `/etc/sensu/conf.d/checks.json`)
