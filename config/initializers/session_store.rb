# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_crowley_session',
  :secret      => '58e9011a98cb584b01114dc2f66c2b5b78be874c2c2b06b2990a70bfa26e0bdef6fed0fdbbc20daaf8820e5d71201968bffc0fe1f062d2fc6cfae522350aca1f'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
