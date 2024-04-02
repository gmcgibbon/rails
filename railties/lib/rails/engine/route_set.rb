# frozen_string_literal: true

# :markup: markdown

require "action_dispatch/routing/route_set"

module Rails
  class Engine
    class RouteSet < ActionDispatch::Routing::RouteSet # :nodoc:
      attr_accessor :application

      def generate_url_helpers(supports_path)
        application = self.application

        method_missing = Module.new do
          define_method(:method_missing) do |method_name, *args, &block|
            if application && application.initialized? && application.routes_reloader.execute_unless_loaded
              ActiveSupport.run_load_hooks(:after_routes_loaded, application)
              public_send(method_name, *args, &block)
            else
              super(method_name, *args, &block)
            end
          end
        end
        url_helpers = super.tap do |mod|
          mod.singleton_class.prepend(method_missing)
        end
      end
    end
  end
end
