# Class: kubeedge
# ===========================
#
# A module to install a Kubeedge https://kubeedge.io/en/
#
# Parameters
# ----------
# [*kubeedge_version*]
#   The version of Kubeedge you want to install.
#   Defaults to  1.10.2
#
# [*container_runtime*]
#   This is the runtime that the Kubeedge will use.
#   It can only be set to "cri_containerd" or "docker"
#   Defaults to docker
#
# [*docker_version*]
#   This is the version of the docker runtime that you want to install.
#   Defaults to 17.03.0.ce-1.el7.centos on RedHat
#   Defaults to 17.03.0~ce-0~ubuntu-xenial on Ubuntu
#
# [*worker*]
#   This is a bool that sets a node to a worker.
#   defaults to false
#
# [*advertise_address*]
#   This is the ip address that the want to api server to expose.
#   defaults to undef
#
# [*token*]
#   A string to use when joining nodes to the cluster. Must be in the form of '[a-z0-9]{6}.[a-z0-9]{16}'
#   Defaults to undef
#
# Authors
# -------
#
# bitvijays
#
#
#
class kubeedge (
  String $kubeedge_version                                       = '1.6.0',
  String $container_runtime                                      = 'docker',
  Boolean $controller                                            = false,
  Boolean $worker                                                = false,
  Array[String] $default_path                                    = ['/usr/bin', '/usr/sbin', '/bin', '/sbin', '/usr/local/bin'],
  Optional[String] $node_label                                   = undef,
  Optional[String] $advertise_address                            = undef,
  Optional[String] $kube_config                                   = '/home/debian/.kube/config',
  # String $token                                                  = undef,
  # String $discovery_token_hash                                   = undef,
  # Optional[String] $node_label                                   = undef,
  Optional[String] $cloud_provider                               = undef,
) {

  if !$facts['os']['family'] in ['Debian', 'RedHat'] {
    notify { "The OS family ${facts['os']['family']} is not supported by this module": }
  }

  case $cloud_provider {
    # k8s controller in AWS with delete any nodes it can't query in the metadata
    'aws': {
      $node_name = $facts['ec2_metadata']['hostname']
      if (!empty($node_label) and $node_label != $node_name) {
        notify { 'aws_name_override':
          message => "AWS provider requires node name to match AWS metadata: ${node_name}, ignoring node label ${node_label}",
        }
      }
    }
    default: { $node_name = pick($node_label, fact('networking.hostname')) }
  }


  if $controller {
    if $worker {
      fail(translate('A node can not be both a controller and a node'))
    }
  }



  # Not sure if should allow this to be changed
  $config_file = '/etc/kubernetes/config.yaml'

  # Added !cloudcore_path_exists to avoid reinstalling the cloudcore if cloudcore is already present.
  if $controller {
    include kubeedge::repos
    include kubeedge::packages
    # include kubernetes::config::kubeadm
    # include kubernetes::service
    include kubeedge::cluster_roles
    # include kubernetes::kube_addons
    contain kubeedge::repos
    contain kubeedge::packages
    # contain kubernetes::config::kubeadm
    # contain kubernetes::service
    contain kubeedge::cluster_roles
    # contain kubernetes::kube_addons

    Class['kubeedge::repos']
      -> Class['kubeedge::packages']
    # -> Class['kubernetes::config::kubeadm']
    # -> Class['kubernetes::service']
      -> Class['kubeedge::cluster_roles']
    # -> Class['kubernetes::kube_addons']
  }

  if $worker {
    contain kubeedge::repos
    contain kubeedge::packages
    contain kubernetes::config::worker
    Class['kubernetes::config::worker'] -> Class['kubernetes::service']

    contain kubernetes::service
    contain kubernetes::cluster_roles

    Class['kubernetes::repos']
    -> Class['kubernetes::packages']
    -> Class['kubernetes::service']
    -> Class['kubernetes::cluster_roles']
  }
}
