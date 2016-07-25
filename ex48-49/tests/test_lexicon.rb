require "ex48/lexicon.rb"
require "test/unit"

class TestLexicon < Test::Unit::TestCase

  def test_directions
    assert_equal(Lexicon.scan("north"), [['direction', 'north']])

    result = Lexicon.scan("north south east")
    assert_equal(result, [['direction', 'north'],
                          ['direction', 'south'],
                          ['direction', 'east']])

    result = Lexicon.scan("forward ahead")
    assert_equal(result, [['direction', 'forward'],
                          ['direction', 'ahead']])
  end

  def test_verbs
    assert_equal(Lexicon.scan("the"), [['stop', 'the']])
    
    result = Lexicon.scan("go kill eat")
    assert_equal(result, [['verb', 'go'],
                          ['verb', 'kill'],
                          ['verb', 'eat']])

    assert_equal(Lexicon.scan("take"), [['verb', 'take']])
    assert_equal(Lexicon.scan("use"), [['verb', 'use']])
    assert_equal(Lexicon.scan("open"), [['verb', 'open']])
    assert_equal(Lexicon.scan("close"), [['verb', 'close']])
  end

  def test_stops
    assert_equal(Lexicon.scan("the"), [['stop', 'the']])

    result = Lexicon.scan("the in of")
    assert_equal(result, [['stop', 'the'],
                          ['stop', 'in'],
                          ['stop', 'of']])
  end

  def test_nouns
    assert_equal(Lexicon.scan("bear"), [['noun', 'bear']])

    result = Lexicon.scan("bear princess")
    assert_equal(result, [['noun', 'bear'],
                          ['noun', 'princess']])
  end

  def test_numbers
    assert_equal(Lexicon.scan("1234"), [['number', 1234]])

    result = Lexicon.scan("3 91234")
    assert_equal(result, [['number', 3],
                          ['number', 91234]])
  end

  def test_full_actions
    result = Lexicon.scan("go to the left")
    assert_equal(result, [['verb', 'go'],
                          ['stop', 'to'],
                          ['stop', 'the'],
                          ['direction', 'left']])

    result = Lexicon.scan("take the key")
    assert_equal(result, [['verb', 'take'],
                          ['stop', 'the'],
                          ['noun', 'key']])

    result = Lexicon.scan("use the key in the cabinet")
    assert_equal(result, [['verb', 'use'],
                          ['stop', 'the'],
                          ['noun', 'key'],
                          ['stop', 'in'],
                          ['stop', 'the'],
                          ['noun', 'cabinet']])
  end

  def test_case
    assert_equal(Lexicon.scan("Go"), [['verb', 'go']])
    assert_equal(Lexicon.scan("THE"), [['stop', 'the']])

    result = Lexicon.scan("OPEN THE DOOR")
    assert_equal(result, [['verb', 'open'],
                          ['stop', 'the'],
                          ['noun', 'door']])
  end

  def test_errors
    assert_equal(Lexicon.scan("asdfadfasdf"), [['error', 'asdfadfasdf']])

    result = Lexicon.scan("bear ias princess")
    assert_equal(result, [['noun', 'bear'],
                          ['error', 'ias'],
                          ['noun', 'princess']])
  end

end
