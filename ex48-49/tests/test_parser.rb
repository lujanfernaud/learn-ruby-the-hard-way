require "ex48/parser.rb"
require "test/unit"

class TestParser < Test::Unit::TestCase

  def test_peek
    assert_equal(peek([['verb', 'go'], ['direction', 'left']]), 'verb')
  end

  def test_match
    result = match([['verb', 'go'], ['direction', 'left']], 'verb')
    assert_equal(result, ['verb', 'go'])
  end

  def test_skip
    word_list = [['verb', 'go'], ['stop', 'to'], ['stop', 'the'], ['direction', 'left']]
    assert_equal(skip(word_list, 'stop'), [['verb', 'go'], ['direction', 'left']])
  end

  def test_parse_verb
    word_list = [['verb', 'go'], ['stop', 'to'], ['stop', 'the'], ['direction', 'left']]
    assert_equal(parse_verb(word_list), ['verb', 'go'])
  end

  def test_parse_object
    word_list = [['verb', 'go'], ['stop', 'to'], ['stop', 'the'], ['direction', 'left']]
    assert_equal(parse_object(word_list), ['direction', 'left'])
  end

  def test_parse_subject
    word_list = [['verb', 'go'], ['stop', 'to'], ['stop', 'the'], ['direction', 'left']]
    assert_equal(parse_subject(word_list), ['noun', 'player'])
  end

  def test_parse_sentence
    word_list = [['verb', 'go'], ['stop', 'to'], ['stop', 'the'], ['direction', 'left']]
    result = parse_sentence(word_list)
    assert_equal(result.subject, 'player')
    assert_equal(result.verb, 'go')
    assert_equal(result.object, 'left')
  end
end