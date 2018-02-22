module Puppet::Parser::Functions
  newfunction(:exist, :type => :rvalue, :doc => <<-EOS
invokes File::exist? on parameter
    EOS
  ) do |arguments|

    # https://ruby-doc.org/core-2.5.0/File.html#method-c-split
#    raise(Puppet::ParseError, "expand_path(): Wrong number of arguments " +
#      "given (#{arguments.size} for 1)") if arguments.size < 1
#
#    unless first.is_a?(String) && second.is_a?(String)
#      raise(Puppet::ParseError, 'expand_path(): Requires 2 Strings')
#    end

    return File.exist?(arguments[0])
  end
end

# vim: set ts=2 sw=2 et :
