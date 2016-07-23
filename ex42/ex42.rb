## Animal is-a object
class Animal
	def walk
		"#{@name} walks."
	end

	def run
		"#{@name} runs."
	end

	def jump
		"#{@name} jumps."
	end
end

## Dog is-a Animal
class Dog < Animal

	def initialize(name)
		## Dog has-a name
		@name = name
	end

	def bark
		"Woof!"
	end
end

## Cat is-a Animal
class Cat < Animal

	def initialize(name)
		## Cat has-a name
		@name = name
	end

	def meow
		"Meoooowww"
	end
end

## Person is-a object
class Person
	attr_accessor :pet, :surname

	def initialize(name, surname="Doe")
		## Person has-a name
		@name = name
		@surname = surname

		## Person has-a pet of some kind
		@pet = nil
	end

	def full_name
		"#{@name} #{@surname}"
	end

	def mood
		mood = %w(happy sad uplifted contented)
		"#{@name} is #{mood[rand(mood.length)]}."
	end
end

## Employee is-a Person
class Employee < Person
	attr_accessor :salary

	def initialize(name, salary)
		## Employee has-a name
		super(name)
		## Employee has-a salary
		@salary = salary
	end
end

## Fish is-a object
class Fish
end

## Salmon is-a Fish
class Salmon < Fish
end

## Halibut is-a Fish
class Halibut < Fish
end

## Rover is-a Dog
rover = Dog.new("Rover")

## Satan is-a Cat
satan = Cat.new("Satan")

## Mary is-a Person
mary = Person.new("Mary")

## Mary has-a pet with the name Satan
mary.pet = satan

## Frank is-a Employee and has-a 120_000 salary
frank = Employee.new("Frank", 120_000)

## Frank has-a pet with the name Rover
frank.pet = rover

## Flipper is-a Fish
flipper = Fish.new

## Crouse is-a Salmon
crouse = Salmon.new

## Harry is-a Halibut
harry = Halibut.new