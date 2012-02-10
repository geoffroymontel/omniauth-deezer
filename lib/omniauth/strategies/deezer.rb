# encoding: utf-8
require 'omniauth'
require 'faraday'
require 'cgi'
require 'multi_json'

module OmniAuth
  module Strategies
    class Deezer 
      include OmniAuth::Strategy

      DEFAULT_PERMS = "basic_access"

      option :name, "deezer"

      # request phase
      
      args [:app_id,:app_secret]

      option :client_options, {
        :authorize_url => 'https://connect.deezer.com/oauth/auth.php',
        :token_url => 'https://connect.deezer.com/oauth/access_token.php',
        :me_url => 'http://api.deezer.com/2.0/user/me'
      }

      option :authorize_options, [:perms]

      def request_phase
        options.perms ||= DEFAULT_PERMS
        redirecting_to = options.client_options.authorize_url+'?app_id='+options.app_id+'&redirect_uri='+CGI::escape(callback_url)+'&perms='+options.perms
        redirect redirecting_to
      end

      # callback phase

      def callback_phase
        begin
          if request.params['error_reason'] then 
            raise CredentialsError, request.params['error_reason'] 
          end

          # get token from Deezer
          token_url = options.client_options.token_url
          token_url = options.client_options.token_url+'?app_id='+options.app_id+'&secret='+options.app_secret+'&code='+request.params['code']
          connection = nil
          if options.client_options.ssl.ca_path then 
            connection = Faraday::Connection.new token_url, :ssl => {:ca_path => options.client_options.ssl.ca_path }
          else
            connection = Faraday::Connection.new token_url
          end
          response = connection.get token_url

          response_hash = CGI::parse(response.body.chomp)
          @access_token = response_hash['access_token'][0]
          @token_expires_at = response_hash['expires'][0].to_i

          # get info from current user
          me_path = options.client_options.me_url+'?access_token='+@access_token
          response = Faraday.get me_path
          @raw_info = MultiJson.decode(response.body.chomp)

          super

        rescue ::MultiJson::DecodeError => e
          fail!(:invalid_response, e)
        rescue ::Timeout::Error, ::Errno::ETIMEDOUT => e
          fail!(:timeout, e)
        rescue ::SocketError => e
          fail!(:failed_to_connect, e)
        rescue TypeError => e
          fail!(:invalid_response, e)
        rescue CredentialsError => e                      
          fail!(:invalid_credentials, e)
        end
      end

      uid { @raw_info['id'] }

      info do
        h = 
        {
          :name => @raw_info['firstname']+' '+@raw_info['lastname'],
          :nickname => @raw_info['name'],
          :last_name => @raw_info['firstname'],
          :first_name => @raw_info['lastname'],
          :location => @raw_info['country'],
          :image => @raw_info['picture'],
          :urls => { :Deezer => @raw_info['link'] }
        }
        # add email if returned by deezer
        if @raw_info['email'] then h[:email] = @raw_info['email'] end
        h
      end

      credentials do
        {
          :token => @access_token,
          :expires => @token_expires_at > 0 ? 'true' : 'false',
          :expires_at => @token_expires_at
        }
      end

      extra do
        {
          :raw_info => @raw_info
        }
      end

      protected

      class CredentialsError < StandardError
        attr_accessor :error

        def initialize(error)
          self.error = error
        end
      end

    end
  end
end