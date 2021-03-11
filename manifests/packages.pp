# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include puppet_kubeedge::package

class kubeedge::packages (
    String $source = $kubeedge::repos::source,
    String $pkg_name = $kubeedge::repos::pkg_name
){
    # Install the Debian Package
    package {
        'keadm':
          ensure  => installed,
          source  => "/tmp/${pkg_name}.deb",
          require => File["/tmp/${pkg_name}.deb"],
    }
}
