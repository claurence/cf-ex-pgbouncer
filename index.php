<?php
// grab connection info
$services = json_decode($_ENV['VCAP_SERVICES'], true);

// check each service
foreach ($services['elephantsql'] as $service) {
    preg_match('|^postgres://(.*):(.*)@(.*):(.*)/(.*)$|', $service['credentials']['uri'], $m);
    $dbname = $m[5];

    $pg = pg_connect("host=127.0.0.1 port=6432 dbname=" . $dbname);
    if (pg_ping($pg)) {
        print "Connected to [$dbname] OK!<br/>\n";
        pg_close($pg);
    } else {
        print "Failed to connect to [$dbname] :(<br/>\n";
    }
}
?>
