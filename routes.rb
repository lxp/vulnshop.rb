get '/' do
  @page = :productlist
  @query = ''
  @products = Product.all
  erb :template
end

get '/hello' do
  'hello world'
end

get '/search' do
  @page = :productlist
  @query = params[:query]
  @products = Product.where("name LIKE '%#{@query}%'")
  erb :template
end

get '/product' do
  id = params[:id]
  if Product.exists?(id)
    @page = :product
    @product = Product.find(id)
  else
    @page = :product_notfound
  end
  erb :template
end

get '/product/:id' do |id|
  @page = :product
  @product = Product.find(id)
  erb :template
end

get '/register' do
  @page = :auth
  @actiontext = 'Register'
  erb :template
end

get '/login' do
  @page = :auth
  @actiontext = 'Login'
  erb :template
end

post '/register' do
  u = User.create(username: params[:username], password: Argon2::Password.create(params[:password]))
  @page = :authresult
  @authresult = 'successful'
  @actiontext = 'Register'
  erb :template
end

post '/login' do
  @page = :authresult
  u = User.find_by(username: params[:username])
  if not u.nil? and Argon2::Password.verify_password(params[:password], u.password)
    @authresult = 'successful'
  else
    @authresult = 'failed'
  end
  @actiontext = 'Login'
  erb :template
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

  @page = :order_success
  @name = params[:name]
  erb :template
end
