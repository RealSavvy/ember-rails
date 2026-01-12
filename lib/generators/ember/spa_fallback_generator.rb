require 'generators/ember/generator_helpers'

module Ember
  module Generators
    class SpaFallbackGenerator < ::Rails::Generators::Base
      include Ember::Generators::GeneratorHelpers

      source_root File.expand_path('../../templates', __FILE__)

      desc "Create a Rails catch-all route/controller for Ember deep links"

      class_option :controller,
        :type => :string,
        :default => 'ember',
        :desc => "Controller name to render the Ember app shell"

      class_option :action,
        :type => :string,
        :default => 'index',
        :desc => "Controller action to render the Ember app shell"

      class_option :skip_root,
        :type => :boolean,
        :default => false,
        :desc => "Do not add a root route pointing at the app shell"

      class_option :skip_routes,
        :type => :boolean,
        :default => false,
        :desc => "Do not modify config/routes.rb"

      def create_controller
        template 'spa_fallback_controller.rb', "app/controllers/#{controller_file_name}_controller.rb"
      end

      def create_view
        template 'spa_fallback_view.html.erb', "app/views/#{controller_file_name}/#{action_name}.html.erb"
      end

      def add_routes
        return if options[:skip_routes]

        unless options[:skip_root]
          route "root to: '#{controller_file_name}##{action_name}'"
        end

        route <<-RUBY

  # Ember app fallback: allow direct/deep links (including dots) to be handled client-side.
  # Place this at the bottom of routes.rb so it does not shadow other routes.
  get '*path',
      to: '#{controller_file_name}##{action_name}',
      format: false,
      constraints: ->(req) { req.format.html? && !req.xhr? }
        RUBY
      end

      private

      def controller_file_name
        options[:controller].to_s.underscore
      end

      def action_name
        options[:action].to_s
      end
    end
  end
end

