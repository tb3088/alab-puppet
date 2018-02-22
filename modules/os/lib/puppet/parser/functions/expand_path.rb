module Puppet::Parser::Functions
  newfunction(:expand_path, :type => :rvalue, :doc => <<-EOS
invokes File::expand_path() on parameter
    EOS
  ) do |arguments|

    # https://ruby-doc.org/core-2.5.0/File.html#method-c-split
#    raise(Puppet::ParseError, "expand_path(): Wrong number of arguments " +
#      "given (#{arguments.size} for 1)") if arguments.size < 1
#
#    unless first.is_a?(String) && second.is_a?(String)
#      raise(Puppet::ParseError, 'expand_path(): Requires 2 Strings')
#    end

    return File.expand_path(arguments[0], arguments[1])
  end
end

# vim: set ts=2 sw=2 et :
