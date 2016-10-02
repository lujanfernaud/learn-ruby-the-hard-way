require 'pry-byebug'
require 'pry-inline'

module Map
  class Room

    def initialize(name, description, actions=false, keypad=false)
      @name           = name
      @description    = description
      @actions        = actions
      @keypad         = keypad
      @player_alive   = true
      @player_won     = false
      @code           = nil
      @doors          = nil
      @good_door      = nil
      @bad_door       = nil
      @paths          = {}
    end

    attr_reader   :name, :description, :actions, :keypad, :player_alive, :player_won, :code, :doors, :good_door, :bad_door, :paths

    def go(direction)
      if @paths.include?(direction)
        @paths[direction]
      else
        "not compute"
      end
    end

    def add_paths(paths)
      @paths.update(paths)
    end

    def generate_random_code
      @code = "#{rand(1..9)}#{rand(1..9)}#{rand(1..9)}"
    end

    def generate_random_doors(maximum_doors)
      @doors     = maximum_doors
      @good_door = "#{rand(1..maximum_doors)}"
      @bad_door  = "#{rand(1..maximum_doors)}"

      while @bad_door == @good_door
        @bad_door = "#{rand(1..maximum_doors)}"
      end
    end

    def player_dies
      @player_alive = false
    end

    def player_wins
      @player_won = true
    end
  end

  CENTRAL_CORRIDOR = Room.new("Central Corridor",
    """
    <p>
    The Gothons of Planet Percal #25 have invaded your ship and destroyed
    your entire crew. You are the last surviving member and your last
    mission is to get the neutron destruct bomb from the Weapons Armory,
    put it in The Bridge, and blow the ship up after getting into an 
    Escape Pod.
    </p>
    <p>
    You're running down the central corridor to the Weapons Armory when
    a Gothon jumps out, red scaly skin, dark grimy teeth, and evil clown costume
    flowing around his hate filled body. He's blocking the door to the
    Armory and about to pull a weapon to blast you.
    </p>
    """,
    actions = true)

  CENTRAL_CORRIDOR_2 = Room.new("Central Corridor",
    """
    <p>
    Lucky for you they made you learn Gothon insults in the academy.
    You tell the one Gothon joke you know:
    </p>
    <p>
    <i>Lbhe zbgure vf fb sng, jura fur fvgf nebhaq gur ubhfr, fur fvgf nebhaq gur ubhfr.</i>
    </p>
    <p>
    The Gothon stops, tries not to laugh, then busts out laughing and can't move. 
    While he's laughing you run up and shoot him square in the head putting him down.
    </p>
    """,
    actions = true)

  LASER_WEAPON_ARMORY = Room.new("Laser Weapon Armory",
    """
    <p>
    You do a dive roll into the Weapon Armory, crouch and scan the room
    for more Gothons that might be hiding. It's dead quiet, too quiet.
    You stand up and run to the far side of the room and find the
    neutron bomb in its container.
    </p>
    <p>
    There's a keypad lock on the box and you need the code to get the bomb out. If you get the code
    wrong 6 times then the lock closes forever and you can't get the bomb.
    </p>
    <p>
    The code is 3 digits.
    </p>
    """,
    actions = false,
    keypad  = true)

  LASER_WEAPON_ARMORY.generate_random_code

  LASER_WEAPON_ARMORY_2 = Room.new("Laser Weapon Armory",
    """
    <p>
    CLICK!
    </p>
    <p>
    The container clicks open and the seal breaks, letting gas out.
    You grab the neutron bomb and run as fast as you can to The
    Bridge where you must place it in the right spot.
    </p>
    """,
    actions = true)

  THE_BRIDGE = Room.new("The Bridge", 
    """
    <p>
    You burst onto The Bridge with the netron destruct bomb
    under your arm and surprise 5 Gothons who are trying to
    take control of the ship. Each of them has an even uglier
    clown costume than the last. They haven't pulled their
    weapons out yet, as they see the active bomb under your
    arm and don't want to set it off.
    </p>
    """,
    actions = true)

  THE_BRIDGE_2 = Room.new("The Bridge", 
    """
    <p>
    You point your blaster at the bomb under your arm
    and the Gothons put their hands up and start to sweat.
    You inch backward to the door, open it, and then carefully
    place the bomb on the floor, pointing your blaster at it.
    You then jump back through the door, punch the close button
    and blast the lock so the Gothons can't get out.
    </p>
    <p>
    Now that the bomb is placed you run to the Escape Pod to
    get off this tin can before it explodes.
    </p>
    """,
    actions = true)

  ESCAPE_POD = Room.new("Escape Pod", 
    """
    <p>
    You get to the chamber with the escape pods, and
    now need to pick one to take. Some of them could be damaged
    but you don't have time to look.
    </p>
    <p>
    There are 5 pods, which one do you take?
    </p> 
    """,
    actions = false,
    keypad  = true)

  ESCAPE_POD.generate_random_doors(5)

  THE_END_WINNER = Room.new("Pod #{ESCAPE_POD.good_door}",
    """
    <p>
    You jump into pod #{ESCAPE_POD.good_door} and hit the eject button.
    The pod easily slides out into space heading to
    the planet below.
    </p>
    <p>
    As it flies to the planet, you look
    back and see your ship implode then explode like a
    bright star, taking out the Gothon ship at the same
    time.
    </p>
    You won!
    """)

  THE_END_WINNER.player_wins

  THE_END_LOSER_1 = Room.new("Pod #{ESCAPE_POD.bad_door}",
    """
    <p>
    You jump into pod #{ESCAPE_POD.bad_door} and hit the eject button.
    The pod escapes out into the void of space, then
    implodes as the hull ruptures, crushing your body
    into jam jelly.
    </p>
    """)
  
  THE_END_LOSER_2 = Room.new("Escape Pod",
    """
    <p>
    The ship explodes.
    </p>
    """)
  
  SHOOT_DEATH = Room.new("Central Corridor", 
    """
    <p>
    Quick on the draw you yank out your blaster and fire it at the Gothon.
    His clown costume is flowing and moving around his body, which throws
    off your aim. Your laser hits his costume but misses him entirely. This
    completely ruins his brand new costume his mother bought him, which
    makes him fly into an insane rage and blast you repeatedly in the face until
    you are dead. Then he eats you.
    </p>
    """)
  
  DODGE_DEATH = Room.new("Central Corridor", 
    """
    <p>
    Like a world class boxer you dodge, weave, slip and slide right
    as the Gothon's blaster cranks a laser past your head.
    In the middle of your artful dodge your foot slips and you
    bang your head on the metal wall and pass out.
    </p>
    <p>
    You wake up shortly after only to die as the Gothon stomps on
    your head and eats you.
    </p>
    """)

  WRONG_CODE_DEATH = Room.new("Laser Weapon Armory", 
    """
    <p>
    The lock buzzes one last time and then you hear a sickening
    melting sound as the mechanism is fused together.
    </p>
    <p>
    You decide to sit there, and finally the Gothons blow up the
    ship from their ship.
    </p>
    """)

  BOMB_DEATH = Room.new("The Bridge", 
    """
    <p>
    In a panic you throw the bomb at the group of Gothons
    and make a leap for the door. Right as you drop it a
    Gothon shoots you right in the back killing you.
    </p>
    <p>
    As you die you see how another Gothon frantically try to disarm
    the bomb. You die knowing they will probably blow up when
    it goes off.
    </p>
    """)

  DEATH_ROOMS = [
    THE_END_LOSER_1,
    THE_END_LOSER_2,
    SHOOT_DEATH,
    DODGE_DEATH,
    WRONG_CODE_DEATH,
    BOMB_DEATH
  ]

  DEATH_ROOMS.each do |room|
    room.player_dies
  end

  # Now we connect the rooms using Room.add_paths(paths).

  CENTRAL_CORRIDOR.add_paths({
    'shoot!'      => SHOOT_DEATH,
    'dodge!'      => DODGE_DEATH,
    'tell a joke' => CENTRAL_CORRIDOR_2,
    'next!!'      => CENTRAL_CORRIDOR_2 
    })

  CENTRAL_CORRIDOR_2.add_paths({
    'do a dive roll' => LASER_WEAPON_ARMORY,
    'next!!'         => LASER_WEAPON_ARMORY 
    })

  LASER_WEAPON_ARMORY.add_paths({
    LASER_WEAPON_ARMORY.code => LASER_WEAPON_ARMORY_2,
    'next!!'                 => LASER_WEAPON_ARMORY_2, 
    'WRONG_CODE_DEATH'       => WRONG_CODE_DEATH
    })

  LASER_WEAPON_ARMORY_2.add_paths({
    'run!' => THE_BRIDGE
    })

  THE_BRIDGE.add_paths({
    'throw the bomb!'        => BOMB_DEATH,
    'next!!'                => THE_BRIDGE_2,
    'slowly place the bomb' => THE_BRIDGE_2
    })

  THE_BRIDGE_2.add_paths({
    'run!' => ESCAPE_POD
    })

  ESCAPE_POD.add_paths({
    ESCAPE_POD.good_door => THE_END_WINNER,
    'next!!'             => THE_END_WINNER,
    ESCAPE_POD.bad_door  => THE_END_LOSER_1,
    'THE_END_LOSER_2'    => THE_END_LOSER_2
    })

  START = CENTRAL_CORRIDOR

  # A whitelist of allowed room names. We use this so that
  # bad people on the internet can't access random variables
  # with names.
  
  ROOM_NAMES = {
    'CENTRAL_CORRIDOR'      => CENTRAL_CORRIDOR,
    'CENTRAL_CORRIDOR_2'    => CENTRAL_CORRIDOR_2,
    'LASER_WEAPON_ARMORY'   => LASER_WEAPON_ARMORY,
    'LASER_WEAPON_ARMORY_2' => LASER_WEAPON_ARMORY_2,
    'THE_BRIDGE'            => THE_BRIDGE,
    'THE_BRIDGE_2'          => THE_BRIDGE_2,
    'ESCAPE_POD'            => ESCAPE_POD,
    'THE_END_WINNER'        => THE_END_WINNER,
    'THE_END_LOSER_1'       => THE_END_LOSER_1,
    'THE_END_LOSER_2'       => THE_END_LOSER_2,
    'SHOOT_DEATH'           => SHOOT_DEATH,
    'DODGE_DEATH'           => DODGE_DEATH,
    'WRONG_CODE_DEATH'      => WRONG_CODE_DEATH,
    'BOMB_DEATH'            => BOMB_DEATH,
    'START'                 => START
  }

  def Map::load_room(session)
    # Given a session this will return the right room or nil.
    ROOM_NAMES[session[:room]]
  end

  def Map::save_room(session, room)
    # Store the room in the session for later, using its name.
    session[:room] = ROOM_NAMES.key(room)
  end
end