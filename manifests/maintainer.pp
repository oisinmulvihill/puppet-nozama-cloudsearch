#
# Install or upgrade the nozama-cloudsearch-service using the easy_install passed in.
#
include nozama_cloudsearch

define nozama_cloudsearch::maintainer (
        $easy_install_exe = 'easy_install',
        $basket = '',
        $opts = '-ZU',
        $cwd = '/tmp',
        $user = 'nozama',
        $group = 'nozama',
        $install_log = '/tmp/nozama-install.log',
        $install_timeout = 0,
        $egg='nozama-cloudsearch-service',
    ) {

    if !defined(User[$user]) {
        fail("User '${user}' does not exist! Please create first.")
    }

    if !defined(Group[$group]) {
        fail("Group '${group}' does not exist! Please create first.")
    }

    if $basket == 0 {
        fail("the basket args must be set by the callee!")
    }

    $cmd = "${easy_install_exe} ${opts} ${basket} ${egg} > ${install_log} 2>&1"

    exec {
        "easy_install-${name}":
            command => $cmd,
            path => "/bin:/usr/bin:/usr/local/bin",
            cwd => $cwd,
            user => $user,
            group => $group,
            timeout => $install_timeout,
    }
}
