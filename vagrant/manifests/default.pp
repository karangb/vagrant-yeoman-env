class must-have {
  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

  include apt

  apt::ppa { "ppa:chris-lea/node.js": }

  exec { 'apt-get update':
    command => '/usr/bin/apt-get update',
    before => Apt::Ppa["ppa:chris-lea/node.js"],
  }

  exec { 'apt-get update 2':
    command => '/usr/bin/apt-get update',
    require => Apt::Ppa["ppa:chris-lea/node.js"],
  }

/*
  exec { 'install gem compass':
    command => 'gem install compass',
  }

  exec { 'install gem sass':
    command => 'gem install sass',
  }
*/

  exec { 'install yeoman':
    command => '/usr/bin/npm install -g yo grunt-cli bower phantomjs',
    creates => [
      '/usr/lib/node_modules/bower/bin/bower',
      '/usr/lib/node_modules/yo/bin/yo',
      '/usr/lib/node_modules/grunt-cli/bin/grunt',
      '/usr/lib/node_modules/phantomjs/bin/phantomjs'
      ],
    require => [ Exec["apt-get update 2"], Package["nodejs"] ],
  }

  exec { 'install angular generator':
    command => '/usr/bin/npm install -g generator-booang',
    creates => '/usr/lib/node_modules/generator-booang',
    require => Exec["install yeoman"],
  }

  file { "/home/vagrant/yeoman/angular":
      ensure => "directory",
      before => Exec['create angular site'],
      require => Exec['install angular generator'],
  }

  exec { 'create angular site':
    command => '/usr/bin/yes | /usr/lib/node_modules/yo/bin/yo booang',
    cwd => '/home/vagrant/yeoman/angular',
    creates => '/home/vagrant/yeoman/angular/app',
    require => File["/home/vagrant/yeoman/angular"],
  }
/*
  file_line { "update hostname in gruntfile":
    line => "        hostname: '0.0.0.0'",
    path => "/home/vagrant/yeoman/angular/Gruntfile.js",
    match => "hostname: '*'",
    ensure => present,
    require => Exec["create angular site"],
  }

  file_line { "update port in gruntfile":
    line => "        port: 9000,",
    path => "/home/vagrant/yeoman/angular/Gruntfile.js",
    match => "port: 3000,",
    ensure => present,
    require => Exec["create angular site"],
  }

  file_line { "update browser in karma":
    line => "browsers = ['PhantomJS'];",
    path => "/home/vagrant/yeoman/angular/karma.conf.js",
    match => "browsers = ['Chrome'];",
    ensure => present,
    require => Exec["create angular site"],
  }

  file_line { "update browser in karma e2e":
    line => "browsers = ['PhantomJS'];",
    path => "/home/vagrant/yeoman/angular/karma-e2e.conf.js",
    match => "browsers = ['Chrome'];",
    ensure => present,
    require => Exec["create angular site"],
  }

  exec { 'bower update':
    command => 'bower update',
    cwd => '/home/vagrant/yeoman/angular',
    creates => '/home/vagrant/yeoman/angular/app/libs',
    require => File["/home/vagrant/yeoman/angular"],
  }
*/
  package { ["vim",
             "bash",
             "nodejs",
             "git-core",
             "fontconfig"]:
    ensure => present,
    require => Exec["apt-get update 2"],
  }


}

include must-have
