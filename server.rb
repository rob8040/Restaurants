require 'sinatra'
require 'sinatra/reloader'

require 'pry'
require 'csv'
require_relative 'app/models/restaurant.rb'

set :bind,'0.0.0.0'  # bind to all interfaces, http://www.sinatrarb.com/configuration.html

get "/" do
  redirect "/restaurants"
end

def retreive_restaurants
  restaurant_csv = CSV.readlines('restaurants.csv', headers: true)
  @restaurant_array = []
  restaurant_csv.each do |restaurant|
    @restaurant_array << Restaurant.new(
      restaurant['id'], restaurant['name'], restaurant['address'], restaurant['description'], restaurant['url'], restaurant['image']
    )
  end
  @restaurant_array
end

get "/restaurants" do
  restaurant_csv = CSV.readlines('restaurants.csv', headers: true)
  @restaurant_array = []
  restaurant_csv.each do |restaurant|
    @restaurant_array << Restaurant.new(
      restaurant['id'], restaurant['name'], restaurant['address'], restaurant['description'], restaurant['url'], restaurant['image']
    )
  end
  erb :index
end

get "/restaurants/new" do
  erb :new
end

get "/restaurants/:id" do
  id = params[:id]
  restaurant_csv = CSV.readlines('restaurants.csv', headers: true)
  @restaurant_array = []
  restaurant_csv.each do |restaurant|
    @restaurant_array << Restaurant.new(
      restaurant['id'], restaurant['name'], restaurant['address'], restaurant['description'], restaurant['url'], restaurant['image']
    )
  end

  @restaurant_array.each do |restaurant|
    if restaurant.id == id
      @restaurant_object = restaurant
    end
  end

  erb :show
end

post "/restaurants" do
  restaurant_name = params[:name]
  restaurant_address = params[:address]
  restaurant_description = params[:description]
  restaurant_url = params[:url]
  restaurant_image = params[:image]

  last_restaurant_id = retreive_restaurants.last.id.to_i
  new_id = last_restaurant_id + 1

  if restaurant_name == "" || restaurant_address == "" || restaurant_description == "" || restaurant_url == "" || restaurant_image == ""
    redirect "/restaurants/new"
  else
    CSV.open('restaurants.csv', 'a') do |file|
      file << [new_id, restaurant_name, restaurant_address, restaurant_description, restaurant_url, restaurant_image]
    end
  end
  
  redirect "/"
end
