puppet-nozama-cloudsearch
=========================

.. contents::

Install nozama-cloudsearch-service via puppet. This installs the service into a
python environment from pypi. You will need python and a preconfigured
virtualenv set up.

Contributions are welcome!

 * https://github.com/oisinmulvihill/puppet-nozama-cloudsearch


Dependancies
------------

I require my supervisor module as I use this to create service program entries:

 * https://github.com/oisinmulvihill/puppet-supervisor


Usage
-----

The follow is an example of how I call this when used as part of a larger
set up:

.. code-block:: puppet

    $user_home = '/home/vagrant'
    $nozama = 'nozama'
    $nozama_env = "${user_home}/src/virtualenvs/${nozama}"
    $nozama_python = "${nozama_env}/bin/python"
    $nozama_cmd = "${nozama_python} pserve development.ini"
    $nozama_dir = "${user_home}/nozama"

    exec { $nozama_env:
        command => "virtualenv --clear --system-site-packages ${nozama_env}",
        path => "/usr/local/bin:/usr/bin:/bin",
        user => $user,
        group => $user,
        creates => $nozama_env,
    }

    file { $nozama_dir:
        name => $nozama_dir,
        ensure => directory,
        owner => $user,
        group => $user,
        mode => 0750;
    }

    nozama_cloudsearch::maintainer { 'nozama-prod-egg':
        easy_install_exe => "${nozama_env}/bin/easy_install",
        user => $user,
        group => $user,
    }

    nozama_cloudsearch::service { 'nozama-cloudsearch':
        service_user => $user,
        config_dir => $nozama_dir,
        run_dir => $nozama_dir,
        pserve => "${nozama_env}/bin/pserve",
        template_vars => {
            rundir => $nozama_dir,
            service_interface => '0.0.0.0',
            service_port => 15808,
            mongodb_dbname => 'nozama-cloudsearch',
            mongodb_port => 27017,
            mongodb_host => 'localhost',
            es_port => 9200,
            es_host => 'localhost',
            log_level => 'DEBUG',
            nozama_site_name => 'NozamaCloudSearchService',
            nozama_cookie_name => 'abcefg',
            nozamacookie_secret => 'abcefg-secret',
        },
    }


This will create a python environment. The maintainer will then install the
https://pypi.python.org/pypi/nozama-cloudsearch-service egg into the
environment. The service call sets up the configuration and supervisord entry
for the service.

You could skip the virtualenv part and just run the maintainer and service
steps using the system python. I just have a preference for isolating services
into their own envs.


License
-------

Copyright (c) 2013, Oisin Mulvihill
All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

  Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

  Redistributions in binary form must reproduce the above copyright notice, this
  list of conditions and the following disclaimer in the documentation and/or
  other materials provided with the distribution.

  Neither the name of the {organization} nor the names of its
  contributors may be used to endorse or promote products derived from
  this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
