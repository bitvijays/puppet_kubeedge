# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include puppet_kubeedge::keadm_join
define kubeedge::keadm_join (
    String $node_name                        = $kubeedge::node_name,
    String $cloudcore_ipport                 = $kubeedge::cloudcore_ipport,
    String $token                            = $kubeedge::token,
    Array $path                              = $kubeedge::default_path,
  ) {
    case $keadm_version {
      # K1.11 and below don't use the config file
      /^1.1(0|1)/: {
        $keadm_join_flags = keadm_join_flags( {
            node_name                => $node_name,
            token                    => $token,
        })
      }
      default: {
        $keadm_join_flags = keadm_join_flags( {
            kubeedge-version         => $kubeedge::kubeedge_version,
            token                    => $kubeedge::token,
            cloudcore-ipport         => $kubeedge::cloudcore_ipport,
        })
      }
    }

    $exec_join = "keadm join ${keadm_join_flags}"
    $unless_join = "kubectl get nodes | grep ${node_name}"
    $only_init2= 'edgecore --version | grep "command not found"'

    exec { 'keadm join':
      command   => $exec_join,
      path      => $path,
      logoutput => true,
      timeout   => 0,
      onlyif    => $only_init2
#      unless      => $unless_join,
    }
  }
