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

  $exec_init = "/tmp/${keadm_path}/keadm/keadm init ${keadm_init_flags}"
  $only_init = "kubectl get nodes | grep ${node_name}"

  notify { 'resource title':
    message  => $keadm_init_flags
  }

  exec { 'keadm init':
    command     => $exec_init,
    environment => $env,
    path        => $path,
    logoutput   => true,
    timeout     => 0,
#    onlyif      => $only_init,
  }
}