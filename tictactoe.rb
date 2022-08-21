require 'pry'

INITIAL_MARKER = " "
PLAYER_MARKER = 'X'
COMPUTER_MARKER = 'O'
WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # row
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                [[1, 5, 9], [3, 5, 7]]              # diags
player_score = 0
computer_score = 0
SCORE_TO_WIN = 5


def prompt(msg)
  puts "=> #{msg}"
end

def display_board(brd)
  system 'clear'
  puts "You are #{PLAYER_MARKER}. Computer is #{COMPUTER_MARKER}"
  puts ""
  puts "     |     |"
  puts "  #{brd[1]}  |  #{brd[2]}  |  #{brd[3]}"
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{brd[4]}  |  #{brd[5]}  |  #{brd[6]}"
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{brd[7]}  |  #{brd[8]}  |  #{brd[9]}"
  puts "     |     |"
  puts ""
end

def initialize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = INITIAL_MARKER }
  new_board
end

def empty_squares(brd)
  brd.keys.select { |num| brd[num] == INITIAL_MARKER }
end

def joinor(arr, punct=', ', word='or') 
  case arr.length
  when 0 then ''
  when 1 then arr.first
  when 2 then arr.join(' ').insert(-2, word + ' ')
  else
    arr.join(punct).insert(-2, word + ' ')
  end
end

def player_places_piece!(brd)
  square = ''
  loop do
    prompt "choose a square: #{joinor(empty_squares(brd))}: "
    square = gets.chomp.to_i
    break if empty_squares(brd).include?(square)
    prompt "sorry, that's not a valid choice."
  end
  brd[square] = PLAYER_MARKER
end

def computer_places_piece!(brd)
  square = empty_squares(brd).sample
  brd[square] = COMPUTER_MARKER
end

def board_full?(brd)
  empty_squares(brd).empty?
end

def someone_won?(brd)
  !!detect_winner(brd)
end

def detect_winner(brd)
  WINNING_LINES.each do |line|
    if brd.values_at(*line).count(PLAYER_MARKER) == 3
      return 'Player'
    elsif brd.values_at(*line).count(PLAYER_MARKER) == 3
      return 'Computer'
    end
  end
  nil
end

def display_score(player_scr, computer_scr)
  prompt "Currect score Player: #{player_scr}, Computer: #{computer_scr}."
end

def check_if_5?(player_scr, computer_scr)
  return if player_scr == 5 or computer_scr == 5
end

# main loop
loop do
  board = initialize_board

  loop do
    display_board(board)
    player_places_piece!(board)
    break if someone_won?(board) || board_full?(board)
    computer_places_piece!(board)
    break if someone_won?(board) || board_full?(board)
  end

  display_board(board)
 
  if someone_won?(board)
    prompt "#{detect_winner(board)} won!"
    if detect_winner(board) == 'Player'
      player_score += 1
    else
      computer_score += 1
    end
  else
    prompt "It's a tie!"
  end

 
  display_score(player_score, computer_score)
  


  prompt "Play again? (y or n)"
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')
end

prompt "Thanks for playing! Goodbye!"
