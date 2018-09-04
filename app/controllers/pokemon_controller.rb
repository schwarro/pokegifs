class PokemonController < ApplicationController

  def show

    res = HTTParty.get("http://pokeapi.co/api/v2/pokemon/#{params[:id]}/")
    body = JSON.parse(res.body)
    name = body["name"]
    id = body["id"]
    type = find_types(body)

    gif_res = HTTParty.get("https://api.giphy.com/v1/gifs/search?api_key=#{ENV["GIPHY_KEY"]}&q=#{params[:id]}")
    gif_body = JSON.parse(gif_res.body)
    gif_url = generate_gif(gif_body).sample

    render json: { name: name, id: id, types: type, gif: gif_url}

  end

  def find_types(body)
   type_arr = []
   body["types"].map do |t|
     t["type"]["name"]
   end
  end

  def generate_gif(body)
    body["data"].map do |g|
      g["url"]
    end
  end

end
