class apache {

    package { "httpd":
        ensure => installed,
    }
    
    service { "httpd":
        ensure     => running,
        enable     => true,
        hasstatus  => true,
        hasrestart => true,
        require    => Package["httpd"],
        subscribe  => [ File["/etc/httpd/conf/httpd.conf"], File["/etc/httpd/conf.d"] ],
    }

    # Update default httpd: DefaultType text/html
    file {
        "/etc/httpd/conf/httpd.conf":
            ensure  => file,
            owner   => "root",
            group   => "root",
            mode    => "0644",
            source  => "puppet:///modules/apache/httpd.conf",
            require => Package["httpd"];
        "/etc/httpd/conf.d":
            ensure  => directory,
            owner   => "root",
            group   => "root",
            mode    => "0644",
            recurse => true,
            require => Package["httpd"];
        "/etc/httpd/conf.d/welcome.conf":
            content => "NameVirtualHost *:80",
            require => [Package["httpd"],File["/etc/httpd/conf.d"]],
            notify  => Service["httpd"];
    }
}

