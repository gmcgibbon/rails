# frozen_string_literal: true

require "abstract_unit"

module ActionDispatch
  class OncesTest < ActionDispatch::IntegrationTest
    setup do
      @call_count = 0
      @call_increment = proc { @call_count += 1 }
      build_app
    end

    def test_runs_block_only_once
      5.times { get "/test" }

      assert_equal(@call_count, 1)
    end

    private
      def build_app
        @app = self.class.build_app do |middleware|
          middleware.use Once, @call_increment
        end
      end
  end
end
