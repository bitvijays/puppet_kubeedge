# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include puppet_kubeedge::service
class kubeedge::service {

    # Move the cloudcore.service from /etc/kubeedge/cloudcore.service to systemd folder and 
    # ensure the cloudcore service is enabled and running
    if $kubeedge::controller{
        file {
            '/etc/systemd/system/cloudcore.service':
            source => '/etc/kubeedge/cloudcore.service',
        }

        service { 'cloudcore':
            ensure => running,
            enable => true,
        }
    }

    # Move the edgecore.service from /etc/kubeedge/cloudcore.service to systemd folder and 
    # ensure the edgecore service is enabled and running
    if $kubeedge::worker{
        file {
            '/etc/systemd/system/edgecore.service':
            source => '/etc/kubeedge/edgecore.service',
        }

        service { 'edgecore':
            ensure => running,
            enable => true,
        }
    }
}
