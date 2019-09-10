Puppet::Functions.create_function(:'deprecated::parameters', Puppet::Functions::InternalFunction) do
  dispatch :deprecated_parameters do
    scope_param
    param 'Hash[String, Hash]', :deprecations
  end

  def deprecated_parameters(scope, deprecations)
    puppet_class = scope.resource.name.downcase
    deprecations.each do |parameter,info|

      oldparam = "#{puppet_class}::#{parameter}"
      newparam = case info['replacement']
                 when nil
                   nil
                 when %r{::}
                   info['replacement']
                 else
                   "#{puppet_class}::#{info['replacement']}"
                 end


      deprecated_param = scope[oldparam]

      parser = Puppet::Pops::Types::TypeParser.new
      deptype = parser.parse('Deprecated::Param')

      unless Puppet::Pops::Types::TypeCalculator.instance?(deptype, deprecated_param)
        replace = case newparam
                  when nil
                    ''
                  else
                    " Please use #{newparam} instead."
                  end

        rtitle = "Deprecate #{oldparam} => #{newparam}"

        # Ensure that a deprecation check for a given parameter can be made
        # multiple times from different places in code
        if !call_function('defined', "Notify[#{rtitle}]")
          call_function('create_resources', 'notify', {
            rtitle => { 'message' => "#{oldparam} has been deprecated.#{replace}" }
          })
        end
      end

    end
  end
end
