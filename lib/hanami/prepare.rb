require 'dotenv'
Dotenv.load('.env.development.local', '.env.development', '.env')
require './system/import'
require './config/environment'
