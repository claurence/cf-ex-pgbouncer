## CloudFoundry PHP Example Application:  pgbouncer

This is an example application which also runs [pgbouncer] for Postgres connection pooling.

This is an example of how it's possible to package an extension with your application to run an additional process in the background.  In this case, we package [pgbouncer] but you could adjust the example to run one or more a different process.

### Usage

1. Clone the app (i.e. this repo).

  ```bash
  git clone https://github.com/dmikusa-pivotal/cf-ex-pgbouncer
  cd cf-ex-pgbouncer
  ```

1. If you don't have one already, create a Postgres service.  With Pivotal Web Services, the following command will create a free Postgres database through [ElephantSQL].

  ```bash
  cf create-service elephantsql turtle pgsql-db
  ```

1. Edit the manifest.yml file.  Change the 'host' attribute to something unique.  Then under "services:" change "pgsql-db" to the name of your Postgres service.  This is the name of the service that will be bound to your application and thus available to [pgbouncer].  You can specify multiple services here, if you like.

1. Push it to CloudFoundry.

  ```bash
  cf push
  ```

  Access your application URL in the browser.  The output should list each service bound to the application and the results of connecting (pg_connect) & pinging (pg_ping) the service.

1. If there are any problems, you can run the following command to get more information.

  ```bash
  cf logs --recent cf-ex-pgbouncer
  ```

### How It Works

When you push the application here's what happens.

1. The local bits are pushed to your target.  This includes the [pgbouncer] binary, which this example does because it's small.  If you had a larger binary, the extension could download this from somewhere and extract it during the compile phase to make pushing the application faster.
1. The server downloads the [PHP Build Pack] and runs it.  This installs HTTPD and PHP.
1. The build pack sees the custom extension that we pushed and runs it.  The extension configures [pgbouncer] based on VCAP_SERVICES.  If you don't want this automatic configuration, you can manually specify database configurations in the included pgbouncer.ini file.  The extension also instructs the build pack to run and monitor the [pgbouncer] process.
1. At this point, the build pack is done and CF runs our droplet.  This includes HTTPD, PHP & [pgbouncer].

### Caution

This example application configures [pgbouncer] so that it *works*.  This does not necessarily mean it's the best configuration or that it's a secure configuration.  You should absolutely audit the configuration and adjust as necessary for your application.  

Suggestions for improvements or PR's to the example are welcome as well.


[PHP Build Pack]:https://github.com/dmikusa-pivotal/cf-php-build-pack
[ElephantSQL]:http://www.elephantsql.com/
[pgbouncer]:https://wiki.postgresql.org/wiki/PgBouncer
