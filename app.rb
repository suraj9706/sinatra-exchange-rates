require "sinatra"
require "sinatra/reloader"
require "open-uri"
require "json"
require "http"

all_symbols_url = "https://api.exchangerate.host/symbols"

symbols_data = URI.open(all_symbols_url).read

parse_symbols_data = JSON.parse(symbols_data)

filtered_symbols_data = parse_symbols_data.fetch("symbols")

allSymbols = filtered_symbols_data.keys

allSymbols.delete("BOB")

get("/") do
  @keys = allSymbols

  erb(:homepage)
end

get("/:symbol") do 
  @symbol = params.fetch("symbol").upcase
  @keys = allSymbols

  erb(:symbol)
end 


get("/:convertFrom/:convertTo") do 
  @convertFrom = params.fetch("convertFrom")
  @convertTo = params.fetch("convertTo")

  exchange_url = "https://api.exchangerate.host/convert?from=#{@convertFrom}&to=#{@convertTo}"
  
  exchange_data = URI.open(exchange_url).read

  exchange_data_json = JSON.parse(exchange_data)

  @exchangeResult = exchange_data_json.fetch("result")

  erb(:exchange)

end 
