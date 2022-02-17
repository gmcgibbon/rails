# frozen_string_literal: true

require "abstract_unit"

class ControllerHelperTest < ActionView::TestCase
  tests ActionView::Helpers::ControllerHelper

  class SpecializedFormBuilder < ActionView::Helpers::FormBuilder ; end

  MockController = Struct.new(:default_form_builder, keyword_init: true)
  MockControllerWithParams = Struct.new(:default_form_builder, :params, keyword_init: true)

  def test_assign_controller_sets_default_form_builder
    @controller = MockController.new(default_form_builder: SpecializedFormBuilder)
    assign_controller(@controller)

    assert_equal SpecializedFormBuilder, default_form_builder
  end

  def test_assign_controller_skips_default_form_builder
    @controller = MockController.new
    assign_controller(@controller)

    assert_nil default_form_builder
  end

  def test_respond_to
    @controller = MockController.new
    assign_controller(@controller)
    assert_not respond_to?(:params)
    assert respond_to?(:assign_controller)

    @controller = MockControllerWithParams.new
    assert respond_to?(:params)
    assert respond_to?(:assign_controller)
  end
end
