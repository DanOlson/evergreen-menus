module V1
  class ApiResponder < ActionController::Responder
    attr_reader :controller_with_namespace

    def initialize(controller, resources, options={})
      @controller_with_namespace = controller.class.name.split('::')
      add_serializer_options resources, options
      super
    end

    def resources
      # Set location header with namespace
      if @resources.size == 1
        @resources.unshift(*controller_with_namespace[0...-1].map { |n| n.downcase.to_sym })
      else
        @resources
      end
    end

    protected

    def add_serializer_options(resources, options)
      serializer_key = resources.last.respond_to?(:each) ? :each_serializer : :serializer
      options[serializer_key] ||= serializer_for_api_version
    end

    def serializer_for_api_version
      resource_name = controller_with_namespace.last.sub('Controller', '').singularize
      serializer_name = "#{resource_name}Serializer"
      get_serializer_with_namespace serializer_name
    end

    def get_serializer_with_namespace(serailizer_name)
      namespace = controller_with_namespace[1]
      [namespace, serailizer_name].join('::').safe_constantize
    end
  end
end
