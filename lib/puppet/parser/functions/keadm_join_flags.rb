# frozen_string_literal: true

require 'shellwords'
#
# keadm_join_flags.rb
#
module Puppet::Parser::Functions
  # Transforms a hash into a string of keadm init flags
  newfunction(:keadm_join_flags, :type => :rvalue) do |args|
    opts = args[0] || {}
    flags = []
    flags << "--kubeedge-version '#{opts['kubeedge-version']}'" if opts['kubeedge-version'] && opts['kubeedge-version'].to_s != 'undef'
    flags << "--cloudcore-ipport '#{opts['cloudcore-ipport']}'" if opts['cloudcore-ipport'] && opts['cloudcore-ipport'].to_s != 'undef'
    flags << "--node-name '#{opts['node_name']}'" if opts['node_name'] && opts['node_name'].to_s != 'undef'
    flags << "--token '#{opts['token']}'" if opts['token'] && opts['token'].to_s != 'undef'

    flags.flatten.join(' ')
  end
end
