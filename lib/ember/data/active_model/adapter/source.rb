module Ember
  module Data
    module ActiveModel
      module Adapter
        # A tiny Ruby wrapper around the `active-model-adapter-source` gem.
        #
        # Older versions of `active-model-adapter-source` shipped Ruby helpers;
        # newer versions may only ship JS assets. ember-rails expects a stable
        # `bundled_path_for` API so it can copy the bundled JS into the asset
        # pipeline at runtime.
        module Source
          def self.bundled_path_for(asset = nil)
            spec = Gem::Specification.find_by_name('active-model-adapter-source')
            dist = File.join(spec.gem_dir, 'dist')
            asset ? File.join(dist, asset) : dist
          end
        end
      end
    end
  end
end

