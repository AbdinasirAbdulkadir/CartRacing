require 'ffi'

module CartGame
  extend FFI::Library
  ffi_lib 'path/to/libcartgame.so'  # Specify the path to the compiled shared library

  # Attach C++ functions to Ruby module
  attach_function :start_game, [:int], :void
  attach_function :update_game, [], :bool
  attach_function :get_positions, [:pointer, :int], :void
  attach_function :is_game_over, [], :bool
  attach_function :apply_event, [:int, :int], :void  # Make sure this is implemented in your C++ code
end

# Method to generate random events
def generate_random_event
  # Run the BASIC script and capture its output (assuming the BASIC interpreter is named 'basic')
  output = `basic path/to/random_event.bas`

  # Parse the output
  event_code, intensity = output.split(',').map(&:to_i)

  # Return the event code and intensity as a hash for easy access
  { event_code: event_code, intensity: intensity }
end

# Start the game with 3 carts
CartGame.start_game(3)

game_tick = 0  # Initialize game tick

# Main game loop
until CartGame.is_game_over
  sleep(1)  # Sleep for a second to slow down game updates
  game_tick += 1  # Increment game tick

  # Here, we'll check if it's time to generate a random event (e.g., every 5 game ticks)
  if game_tick % 5 == 0
    event = generate_random_event

    # Now, apply the event. This will change the game state depending on the event generated.
    CartGame.apply_event(event[:event_code], event[:intensity])
  end

  # Update game state
  game_over = CartGame.update_game

  # Get cart positions
  positions = FFI::MemoryPointer.new(:int, 3)
  CartGame.get_positions(positions, 3)
  position_array = positions.read_array_of_int(3)

  # Print cart positions
  position_array.each_with_index do |position, index|
    puts "Cart #{index + 1} is at position #{position}"
  end

  # Check if the game is over
  if game_over
    puts "The race is over!"
    break
  end
end
