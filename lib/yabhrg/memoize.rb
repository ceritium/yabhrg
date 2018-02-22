module Yabhrg
  module Memoize
    def memoize(reload)
      caller_method = caller_locations(1..1).first.label
      var_name = "@_memoize_#{caller_method}"

      instance_variable_set(var_name, yield) if !instance_variable_defined?(var_name) || reload

      instance_variable_get(var_name)
    end
  end
end
