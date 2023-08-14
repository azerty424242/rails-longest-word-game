########################################################
##############   4. COMPUTING THE SCORE   ##############
#############    a) games_controller.rb    #############
#############       b) new.html.erb        #############
########################################################


# app/controllers/games_controller.rb
require 'open-uri'
require 'json'

class GamesController < ApplicationController
  # The 'new' action for displaying a new random grid and a form.
  def new
    @letters = ('A'..'Z').to_a.sample(10)
  end

  # The 'score' action for handling the user's word submission and computing the score.
  def score
    # Get the user's word and the original grid from params
    word = params[:word].upcase
    letters = params[:letters].split(",")

    # Check if the word can be built out of the original grid
    if word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
      if english_word?(word)
        score = word.length
        message = "Congratulations! #{word} is a valid English word and you scored #{score} points."
      else
        score = 0
        message = "Sorry, #{word} is not a valid English word."
      end
    else
      score = 0
      message = "Sorry, #{word} can't be built out of the original grid."
    end

    # Set instance variables for the result message and the user's score
    @result_message = message
    @score = score
  end

  private

  # Method to check if a word is a valid English word using the Wagon Dictionary API
  def english_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"

    begin
      response = JSON.parse(open(url).read)
      response["found"]
    rescue OpenURI::HTTPError => e
      # Handle HTTP errors (404, 500, etc.)
      puts "HTTP Error: #{e.message}"
      false
    rescue JSON::ParserError => e
      # Handle JSON parsing errors
      puts "JSON Parsing Error: #{e.message}"
      false
    end
  end
end






########################################################
#############   3. GENERATING A NEW GAME   #############
#############    a) games_controller.rb    #############
#############       b) new.html.erb        #############
########################################################


# class GamesController < ApplicationController
#   def new
#     @letters = generate_random_letters(10)
#   end

#   def score
#     # Expected an error ==> raise (Rails) or binding.break (Terminal)
#   end


#   private

#   def generate_random_letters(number_of_letters)
#     # Generate an array of random letters from the alphabet
#     alphabet = ('A'..'Z').to_a
#     alphabet.sample(number_of_letters)
#   end
# end





=begin

-----------------  THE NEW.HTML.ERB FILE (STEP 3)  ------------------------

<h1>New game</h1>

<p><%= @letters.join(" ") %></p>

<h2>What's your best shot?</h2>
<%= form_with url: { action: :score }, method: :post, data: { turbo: false } do |form| %>
  <%= hidden_field_tag :authenticity_token, form_authenticity_token %>
  <%= form.text_field :word %>
  <%= form.submit "Play" %>
<% end %>

----------------------------------------------------------------------------


EXPLANATION:


To allow the user to submit a word suggestion, you need to add a form below the letters
in the new.html.erb view. The form should have its action attribute setto /score, and
the method attribute set to post. Additionally, we'll disable Rails'Turbo Streams
feature for this form, and include an authenticity token to prevent CSRF attacks.


The url option is set to { action: :score }, which means the form will submit to the
score action of the GamesController. The method option is set to post to indicate
that the form will perform a POST request.


==> The user will be able to input their word in the text field and submit it by
clicking the "Submit" button. The form will perform a POST request to the score
action of the GamesController, where you can implement the logic to compute the
user's score based on their word and the random letters.


NB: The hidden_field_tag will add a hidden input field with an authenticity_token that
ensures the POST request is coming from your website and not from another. This
authenticity token is necessary to protect against CSRF (Cross-Site Request Forgery)
attacks and is added by Rails by default.


=end
