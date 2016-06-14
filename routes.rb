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
  product = Product.find(params[:id])
  price = product[:price]

  # Send requests to the gateway's test servers
  ActiveMerchant::Billing::Base.mode = :test

  # Create a new credit card object
  credit_card = ActiveMerchant::Billing::CreditCard.new(
    :number     => params[:cc],
    :month      => params[:month],
    :year       => params[:year],
    :name       => params[:name],
    :verification_value  => params[:cvv]
  )

  if credit_card.valid?
    # Create a gateway object to the Bogus service
    gateway = ActiveMerchant::Billing::BogusGateway.new

    # Authorize for product price
    response = gateway.authorize(price, credit_card)

    if response.success?
      # Capture the money
      gateway.capture(price, response.authorization)
    else
      raise StandardError, response.message
    end
  else
    raise StandardError, 'invalid credit card'
  end

  @name = params[:name]
  erb :order_success
end
