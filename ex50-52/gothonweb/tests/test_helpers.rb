require './bin/helpers.rb'
require 'test/unit'

require 'pry-byebug'
require 'pry-inline'

class TestHelpers < Test::Unit::TestCase
  include Helpers

  def test_show_code_hint
    hint = show_code_hint("324")
    assert_equal(hint.match(/(\d|\*)(\d|\*)(\d|\*)/)[0], hint)
  end

  def test_show_door_hint
    # Test without bad door
    hint = show_door_hint("3", 9)
    assert_equal(hint.match(/(\d\,\s)*\d/)[0], hint)
    # Test number of doors
    assert_equal(7, hint.split(", ").size)

    # Test with bad door
    hint = show_door_hint("1", "4", 5)
    assert_equal(hint.match(/(\d\,\s)*\d/)[0], hint)
    # Test number of doors
    assert_equal(2, hint.split(", ").size)
  end
end