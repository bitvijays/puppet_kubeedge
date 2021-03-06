# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include puppet_kubeedge::keadm_init
define kubeedge::keadm_init (
  String $node_name                             = $kubeedge::node_name,
  Optional[String] $config                      = $kubeedge::config_file,
  Boolean $dry_run                              = false,
  Array $path                                   = $kubeedge::default_path,
  Optional[Array] $env                          = $kubeedge::environment,
  Optional[Array] $ignore_preflight_errors      = $kubeedge::ignore_preflight_errors,
  String $keadm_path                            = $kubeedge::repos::pkg_name
) {
  $keadm_init_flags = keadm_init_flags( {
      advertise-address       => $kubeedge::advertise_address,
      kube-config             => $kubeedge::kube_config
  })

  # exec_init is used to initialise the Cloudcore 
  $exec_init = "keadm init ${keadm_init_flags}"
  # The exec is only executed if the Kubernetes is ready 
  $only_init = "kubectl get nodes --kubeconfig=${kubeedge::kube_config} | grep ${node_name}"
  # The exec should only run if cloudcore is not installed.
  $only_init2= 'cloudcore --version | grep "command not found"'

  # Exec for Installing Cloudcore
  exec { 'keadm init':
    command     => $exec_init,
    environment => $env,
    path        => $path,
    logoutput   => true,
    timeout     => 0,
    unless      => $only_init,
    onlyif      => $only_init2
  }

  # We also need to get the token for joining the nodes
  $exec_gettoken = "keadm gettoken --kube-config=${kubeedge::kube_config}"
  $only_gettoken = 'pgrep cloudcore'

  exec { 'keadm gettoken':
    command     => $exec_gettoken,
    environment => $env,
    creates     => '/etc/kubeedge/token',
    path        => $path,
    logoutput   => true,
    timeout     => 0,
    onlyif      => $only_gettoken,
    notify      => File['/etc/kubeedge/token'],
  }

  # By default, keadm gettoken is only printed once.
  file { '/etc/kubeedge/token':
    content => 'token',
    require => Exec['keadm gettoken'],
  }
}