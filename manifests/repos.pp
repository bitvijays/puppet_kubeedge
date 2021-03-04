# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include puppet_kubeedge::repos
class kubeedge::repos {

if $facts['architecture'] == 'aarch64' {
  $arch = 'arm64'
}
elsif $facts['architecture'] == 'armv7l' {
  $arch = 'armv'
}
elsif $facts['architecture'] == 'amd64' {
  $arch = 'amd64'
}
$version = '1.6.0'
$pkg_name = "keadm-v${version}-linux-${arch}"
$source = "https://github.com/kubeedge/kubeedge/releases/download/v${version}/$pkg_name.tar.gz"

archive { "/tmp/${pkg_name}":
  ensure       => present,
  source       => $source,
  extract      => true,
  extract_path => '/tmp',
  cleanup      => true,
  user         => 0,
  group        => 0,
}
}