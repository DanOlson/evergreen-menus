module V1
  class ApiResponder < ActionController::Responder
    attr_reader :controller_with_namespaces

    def initialize(controller, resources, options={})
      @controller_with_namespaces = controller.class.name.split('::')
      apply_serializer_options resources, options
      super
    end

    def resources
      if @resources.size == 1
        @resources.unshift(*controller_with_namespaces[0...-1].map { |n| n.downcase.to_sym })
      else
        @resources
      end
    end

    protected

    def apply_serializer_options(resources, options)
      key = resources.last.respond_to?(:each) ? :each_serializer : :serializer
      options[key] ||= serializer_for_api_version
    end

    def serializer_for_api_version
      get_serializer_with_namespace
    end

    def resource_name
      controller_with_namespaces.last.sub('Controller', '').singularize
    end

    def serializer_name
      "#{resource_name}Serializer"
    end

    def get_serializer_with_namespace
      version_namespace = controller_with_namespaces[1]
      [version_namespace, serializer_name].join('::').safe_constantize
    end
  end
end
