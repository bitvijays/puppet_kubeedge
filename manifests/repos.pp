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
$pkg_name = "keadm_${version}_${arch}"
$source = "puppet:///modules/kubeedge/v${version}/${pkg_name}.deb"

file {
  "/tmp/${pkg_name}.deb":
    ensure => present,
    mode   => '0777',
    source => $source,
    notify => Package['keadm'],
}

}