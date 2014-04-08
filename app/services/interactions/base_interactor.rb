module Interactions
  class BaseInteractor
    def model
      class_name = self.class.name.split('::').last
      Module.const_get "::#{class_name}"
    end
  end
end
