#
#
#
include stdlib
include nozama_cloudsearch

# Set up a new service instance based on the given criteria.
#
define nozama_cloudsearch::service (
        $instance_name = $title,
        $service_user = "nozama",
        $config_dir = "/etc/nozama",
        $run_dir = "/var/run/nozama",
        $pserve = "pserve",
        $template_vars,
    ) {

    if !defined(User[$service_user]) {
        fail("User '${service_user}' does not exist!")
    }

    if !defined(File[$config_dir]) {
        fail("The config dir '${config_dir}' does not exist!")
    }

    if !defined(File[$run_dir]) {
        fail("The run dir '${run_dir}' does not exist!")
    }

    # Make sure template vars is a hash:
    validate_hash($template_vars)

    $config_filename = "${config_dir}/${instance_name}.ini"

    file {
        "nozama_cloudsearch-config-${instance_name}":
            ensure => file,
            path => $config_filename,
            content => template("nozama_cloudsearch/config.ini.erb"),
            mode => 644,
    }

    include supervisor

    supervisor::program {"nozama-service-${instance_name}":
        name => $title,
        command => "${pserve} ${config_filename}",
        directory => $run_dir,
        autostart => 'true',
        user => $service_user,
        require => [
            File["nozama_cloudsearch-config-${instance_name}"]
        ]
    }

}