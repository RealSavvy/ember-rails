require 'test_helper'
require 'generators/ember/spa_fallback_generator'

class SpaFallbackGeneratorTest < Rails::Generators::TestCase
  tests Ember::Generators::SpaFallbackGenerator
  destination File.join(Rails.root, "tmp", "spa_fallback_generator_test_output")

  setup :prepare_destination

  def copy_directory(dir)
    source = Rails.root.join(dir)
    dest = Rails.root.join("tmp", "spa_fallback_generator_test_output", File.dirname(dir))

    FileUtils.mkdir_p dest
    FileUtils.cp_r source, dest
  end

  def prepare_destination
    super
    copy_directory "config"
  end

  test "creates controller, view, and adds routes with format: false" do
    run_generator

    assert_file "app/controllers/ember_controller.rb", /class EmberController < ApplicationController/
    assert_file "app/views/ember/index.html.erb", /id="ember-app"/

    assert_file "config/routes.rb", /root to: 'ember#index'/
    assert_file "config/routes.rb", /get '\*path'/
    assert_file "config/routes.rb", /format: false/
    assert_file "config/routes.rb", /constraints: ->\(req\) \{ req\.format\.html\? && !req\.xhr\? \}/
  end

  test "supports custom controller/action names" do
    run_generator %w(--controller=spa --action=show)

    assert_file "app/controllers/spa_controller.rb", /class SpaController < ApplicationController/
    assert_file "app/views/spa/show.html.erb"

    assert_file "config/routes.rb", /root to: 'spa#show'/
    assert_file "config/routes.rb", /to: 'spa#show'/
  end

  test "can skip modifying routes" do
    run_generator %w(--skip-routes)

    assert_file "app/controllers/ember_controller.rb"
    assert_file "app/views/ember/index.html.erb"
    assert_file "config/routes.rb", /Dummy::Application\.routes\.draw do/
    assert_no_match(/get '\*path'/, File.read(File.join(destination_root, "config/routes.rb")))
  end
end

