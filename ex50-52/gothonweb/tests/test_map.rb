require "./lib/gothonweb/map.rb"
require "test/unit"

class TestGame < Test::Unit::TestCase

  def test_room
    gold = Map::Room.new("GoldRoom", """This room has gold in it you can grab. There's a door to the north.""")
    assert_equal("GoldRoom", gold.name)
    assert_equal("""This room has gold in it you can grab. There's a door to the north.""", gold.description)
    assert_equal({}, gold.paths)
  end

  def test_room_paths
    center = Map::Room.new("Center", "Test room in the center.")
    north  = Map::Room.new("North", "Test room in the north.")
    south  = Map::Room.new("South", "Test room in the south.")

    center.add_paths({'north' => north, 'south' => south})
    assert_equal(north, center.go('north'))
    assert_equal(south, center.go('south'))
  end

  def test_map
    start = Map::Room.new("Start", "You can go west and down a hole.")
    west  = Map::Room.new("Trees", "There are trees here, you can go east.")
    down  = Map::Room.new("Dungeon", "It's dark down here, you can go up.")

    start.add_paths({'west' => west, 'down' => down})
    west.add_paths({'east' => start})
    down.add_paths({'up' => start})

    assert_equal(west, start.go('west'))
    assert_equal(start, start.go('west').go('east'))
    assert_equal(start, start.go('down').go('up'))
  end

  def test_room_actions_and_keypad
    ending_room = Map::Room.new("Ending room", "This is a room without actions or keypad.")
    assert_equal(false, ending_room.actions)
    assert_equal(false, ending_room.keypad)

    normal_room = Map::Room.new("Room with actions", "This is a room where we have actions available.", actions=true)
    assert_equal(true, normal_room.actions)

    keypad_room = Map::Room.new("Room with keypad", "This is a room with a keypad and without actions available.", actions=false, keypad=true)
    assert_equal(false, keypad_room.actions)
    assert_equal(true, keypad_room.keypad)

    ak_room = Map::Room.new("Room with actions and keypad", "This is a room with actions available and a keypad.", actions=true, keypad=true)
    assert_equal(true, ak_room.actions && ak_room.keypad)
  end

  def test_room_nil_variables
    room = Map::Room.new("Normal room", "This is a room that only has available actions.")

    assert_equal(NilClass, room.code.class)
    assert_equal(NilClass, room.doors.class)
    assert_equal(NilClass, room.good_door.class)
    assert_equal(NilClass, room.bad_door.class)
  end

  def test_generate_random_code
    room = Map::Room.new("Room with code", "This is a room where you need to introduce a code to continue.")
    code = room.generate_random_code
    
    assert_equal(String, code.class)
    assert_equal(code.match(/\d{3}/)[0], code)
  end

  def test_generate_random_doors
    room = Map::Room.new("Room with doors", "This is a room where you need to choose a door to continue.")
    room.generate_random_doors(9)

    assert_equal(Fixnum, room.doors.class)
    assert_equal(String, room.good_door.class)
    assert_equal(String, room.bad_door.class)

    assert_equal(room.doors.to_s.match(/\d+/)[0], room.doors.to_s)

    assert_equal(true, room.good_door != room.bad_door)
  end

  def test_gothon_game_map
    # CENTRAL_CORRIDOR
    assert_equal(Map::SHOOT_DEATH, Map::START.go('shoot!'))
    assert_equal(Map::DODGE_DEATH, Map::START.go('dodge!'))
    assert_equal(Map::CENTRAL_CORRIDOR_2, Map::START.go('tell a joke'))
    assert_equal(Map::CENTRAL_CORRIDOR_2, Map::START.go('next!!'))
    assert_equal("not compute", Map::START.go('asdas'))

    assert_equal(Map::LASER_WEAPON_ARMORY, Map::CENTRAL_CORRIDOR_2.go('do a dive roll'))
    assert_equal(Map::LASER_WEAPON_ARMORY, Map::CENTRAL_CORRIDOR_2.go('next!!'))
    
    # LASER_WEAPON_ARMORY
    assert_equal(Map::LASER_WEAPON_ARMORY_2, Map::LASER_WEAPON_ARMORY.go(Map::LASER_WEAPON_ARMORY.code))
    assert_equal(Map::LASER_WEAPON_ARMORY_2, Map::LASER_WEAPON_ARMORY.go('next!!'))
    assert_equal(Map::WRONG_CODE_DEATH, Map::LASER_WEAPON_ARMORY.go('WRONG_CODE_DEATH'))
    assert_equal("not compute", Map::LASER_WEAPON_ARMORY.go('sdasd'))

    assert_equal(Map::THE_BRIDGE, Map::LASER_WEAPON_ARMORY_2.go('run!'))
    
    # THE_BRIDGE
    assert_equal(Map::BOMB_DEATH, Map::THE_BRIDGE.go('throw the bomb!'))
    assert_equal(Map::THE_BRIDGE_2, Map::THE_BRIDGE.go('next!!'))
    assert_equal(Map::THE_BRIDGE_2, Map::THE_BRIDGE.go('slowly place the bomb'))
    assert_equal("not compute", Map::THE_BRIDGE.go('asdas'))

    assert_equal(Map::ESCAPE_POD, Map::THE_BRIDGE_2.go('run!'))
    
    # ESCAPE_POD
    assert_equal(Map::THE_END_WINNER, Map::ESCAPE_POD.go(Map::ESCAPE_POD.good_door))
    assert_equal(Map::THE_END_WINNER, Map::ESCAPE_POD.go('next!!'))
    assert_equal(Map::THE_END_LOSER_1, Map::ESCAPE_POD.go(Map::ESCAPE_POD.bad_door))
    assert_equal(Map::THE_END_LOSER_2, Map::ESCAPE_POD.go('THE_END_LOSER_2'))
    assert_equal("not compute", Map::ESCAPE_POD.go('asas'))
  end

  def test_check_if_player_is_alive
    assert_equal(false, Map::THE_END_LOSER_1.player_alive)
    assert_equal(false, Map::THE_END_LOSER_2.player_alive)
    assert_equal(false, Map::SHOOT_DEATH.player_alive)
    assert_equal(false, Map::DODGE_DEATH.player_alive)
    assert_equal(false, Map::WRONG_CODE_DEATH.player_alive)
    assert_equal(false, Map::BOMB_DEATH.player_alive)
  end

  def test_if_player_won
    Map::THE_END_WINNER.player_wins
    assert_equal(true, Map::THE_END_WINNER.player_won)
  end

  def test_session_loading
    session = {}

    room = Map::load_room(session)
    assert_equal(room, nil)

    Map::save_room(session, Map::START)
    room = Map::load_room(session)
    assert_equal(room, Map::START)

    room = room.go('tell a joke')
    assert_equal(room, Map::CENTRAL_CORRIDOR_2)

    Map::save_room(session, room)
    assert_equal(room, Map::CENTRAL_CORRIDOR_2)
  end
end