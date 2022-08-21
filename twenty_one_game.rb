SUITS = ['H', 'D', 'S', 'C']
VALUES = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']

def prompt(msg)
  puts "=> #{msg}"
end

def initalize_deck
  SUITS.product(VALUES).shuffle
end

# aces can be worth 1 or 11 depending on context
def total(cards)
  # cards = [['H', '3'], ['S', 'Q'],...]
  values = cards.map { |card| card[1] }

  sum = 0
  values.each do |value|
    if value == 'A'
      sum += 11
    elsif value.to_i == 0 # J, Q, K
      sum += 10
    else
      sum += value.to_i
    end
  end

  # correct for Aces
  values.select { |value| value == "A" }.count.times do
    sum -= 10 if sum > 21
  end

  sum
end

def busted?(cards)
  total(cards) > 21
end

def detect_results(dealer_cards, player_cards)
  player_total = total(player_cards)
  dealer_total = total(dealer_cards)

  if player_total > 21
    :player_busted
  elsif dealer_total > 21
    :dealer_busted
  elsif dealer_total < player_total
    :player
  elsif dealer_total > player_total
    :dealer
  else
    :tie
  end
end

def display_result(dealer_cards, player_cards)
  result = detect_results(dealer_cards, player_cards)

  case result
  when :player_busted
    prompt "you busted! Dealer wins!"
  when :dealer_busted
    prompt "Dealer busted! You win!"
  when :player
    prompt "you win!"
  when :dealer
    prompt "Dealer wins!"
  when :tie
    prompt "It's a tie!"
  end
end

def play_again?
  puts "---------"
  prompt "do you want to play again? (y or n)"
  answer = gets.chomp
  answer.downcase == "y"
end

# main loop
loop do
  system 'clear'
  prompt "welcome to the game!"

  # initalize vars
  deck = initalize_deck
  player_cards = []
  dealer_cards = []

  # initial deal
  2.times do
    player_cards << deck.pop
    dealer_cards << deck.pop
  end

  prompt "dealer has #{dealer_cards[0]} and unknown"
  prompt "You have: #{player_cards[0]} and #{player_cards[1]}."
  prompt "Your total is: #{total(player_cards)}."

  # player turn
  loop do
    player_turn = nil
    loop do
      prompt "Do you want to hit or stay? (type h for hit or s for stay)"
      player_turn = gets.chomp.downcase
      break if ['h', 's'].include?(player_turn)
      prompt "Please enter 'h' to hit or 's' to stay"
    end

    if player_turn == 'h'
      player_cards << deck.pop
      prompt "you chose to hit!"
      prompt "your cards are now #{player_cards}"
      prompt "your total is now #{total(player_cards)}"
    end

    break if player_turn == 's' || busted?(player_cards)
  end

  if busted?(player_cards)
    display_result(dealer_cards, player_cards)
    play_again? ? next : break
  else
    prompt "you chose to stay at #{total(player_cards)}"
  end

  # dealer turn
  prompt "dealer turn..."

  loop do
    break if total(dealer_cards) >= 17
    prompt "dealer hits!"
    dealer_cards << deck.pop
    prompt "dealer's cards are now: #{dealer_cards}"
  end

  if busted?(dealer_cards)
    prompt "Dealer total is now #{total(dealer_cards)}"
    display_result(dealer_cards, player_cards)
    play_again? ? next : break
  else
    prompt "dealer stays at #{total(dealer_cards)}"
  end

  # both dealer and payer stay
  system 'clear'
  puts "========="
  prompt "Dealer has #{dealer_cards}, for a total of #{total(dealer_cards)}."
  prompt "player has #{player_cards}, for a total of #{total(player_cards)}."
  puts "=========="

  display_result(dealer_cards, player_cards)

  break unless play_again?
end

prompt "thank you for playing Twenty-one! Bye!"
