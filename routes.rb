get '/' do
  @query = ''
  @products = Product.all
  erb :productlist
end

get '/search' do
  @query = params[:query]
  @products = Product.where("name LIKE '%#{@query}%'")
  erb :productlist
end

get '/product' do
  id = params[:id]
  if Product.exists?(id)
    @product = Product.find(id)
    erb :product
  else
    erb :product_notfound
  end
end

get '/product/:id' do |id|
  @product = Product.find(id)
  erb :product
end

post '/order' do
  @name = params[:name]
  raise 'PaymentProcessingError'
  erb :order_success
end
