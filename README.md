# CloudFoundry PHP Example Application:  pgbouncer

This is an example application which also runs [pgbouncer] for Postgres connection pooling.

This is an example of how it's possible to run an additional process in the background. In this case, we package [pgbouncer] but you could adjust the example to run one or more a different processes.

## Usage

1. Clone the app (i.e. this repo).

  ```bash
  git clone https://github.com/cloudfoundry-samples/cf-ex-pgbouncer
  cd cf-ex-pgbouncer
  ```

1. If you don't have one already, create a Postgres service.  With Pivotal Web Services, the following command will create a free Postgres database through [ElephantSQL].

  ```bash
  cf create-service elephantsql turtle pgsql
  ```

  If you are using a different service provider, make sure that you edit `.profile` and change the provider name.

1. Push it to CloudFoundry.

  ```bash
  cf push cf-ex-pgbouncer  # change this app name to something unique
  ```

  Access your application URL in the browser.  The output should list each service bound to the application and the results of connecting (pg_connect) & pinging (pg_ping) the service.

1. If there are any problems, you can run the following command to get more information.

  ```bash
  cf logs --recent cf-ex-pgbouncer
  ```

## How It Works

When you push the application here's what happens.

1. The local bits are pushed to your target. This includes `apt.yml` which is used by the Apt buildpack to install [pgbouncer].
1. The server downloads the [PHP Buildpack] and runs it.  This installs HTTPD and PHP.
1. Prior to the application starting, the `.profile` script runs. This configures [pgbouncer] based on `VCAP_SERVICES`. If you don't want this automatic configuration, you can manually specify database configurations in the included `pgbouncer.ini` file.  The script also instructs the build pack to run and monitor the [pgbouncer] process.
1. At this point, the app runs which includes the processes for HTTPD, PHP-FPM & [pgbouncer].

## Caution

This example application configures [pgbouncer] so that it *works*.  This does not necessarily mean it's the best configuration or that it's a secure configuration.  You should absolutely audit the configuration and adjust as necessary for your application.

Suggestions for improvements or PR's to the example are welcome as well.

[PHP Buildpack]:https://github.com/cloudfoundry/php-buildpack
[ElephantSQL]:http://www.elephantsql.com/
[pgbouncer]:https://wiki.postgresql.org/wiki/PgBouncer
