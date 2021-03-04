# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include kubeedge::kubeedge::cluster_roles
# This class configures the RBAC roles for Kubernetes 1.10.x

class kubeedge::cluster_roles (
  Optional[Boolean] $controller = $kubeedge::controller,
  Optional[Boolean] $worker = $kubeedge::worker,
  String $node_name = $kubeedge::node_name,
  String $container_runtime = $kubeedge::container_runtime,
  Optional[String] $join_discovery_file = $kubeedge::join_discovery_file,
  Optional[Array] $ignore_preflight_errors = $kubeedge::ignore_preflight_errors,
  Optional[Array] $env = $kubeedge::environment,
) {
  if $container_runtime == 'cri_containerd' {
    $preflight_errors = flatten(['Service-Docker',$ignore_preflight_errors])
    $cri_socket = '/run/containerd/containerd.sock'
  } else {
    $preflight_errors = $ignore_preflight_errors
    $cri_socket = undef
  }

  if $controller {
    kubeedge::keadm_init { $node_name:
      ignore_preflight_errors => $preflight_errors,
      env                     => $env,
    }
  }

  if $worker {
    kubeedge::kubeadm_join { $node_name:
      cri_socket              => $cri_socket,
      ignore_preflight_errors => $preflight_errors,
      discovery_file          => $join_discovery_file,
      env                     => $env,
    }
  }
}