# frozen_string_literal: true

# :markup: markdown

module ActionDispatch
  class Once
    def initialize(app, block)
      @app, @block, @called = app, block, false
    end

    def call(env)
      @called ||= begin
        @block.call
        true
      end
      @app.call(env)
    end
  end
end
