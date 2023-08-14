#####################################################
#########  1. GENERATE THE GAMESCONTROLLER  #########
#####################################################

#   Terminal: rails generate controller Games new score
#=> This will create the GamesController with the new and score actions.



####################################################
#############   2. UPDATE THE ROUTES   #############
####################################################


Rails.application.routes.draw do
  get '/new', to: 'games#new'
  post '/score', to: 'games#score'
end
