# frozen_string_literal: true

require 'shellwords'
#
# keadm_init_flags.rb
#
module Puppet::Parser::Functions
  # Transforms a hash into a string of kubeadm init flags
  newfunction(:keadm_init_flags, :type => :rvalue) do |args|
    opts = args[0] || {}
    flags = []
    flags << "--advertise-address '#{opts['advertise_address']}'" if opts['advertise_address'] && opts['advertise_address'].to_s != 'undef'
    flags << "--domainname '#{opts['domainname']}'" if opts['domainname'] && opts['domainname'].to_s != 'undef'
    flags << "--kube-config '#{opts['kube-config']}'" if opts['kube-config'] && opts['kube-config'].to_s != 'undef'
    flags << "--cert-dir '#{opts['cert_dir']}'" if opts['cert_dir'] && opts['cert_dir'].to_s != 'undef'
    flags.flatten.join(' ')
  end
end
