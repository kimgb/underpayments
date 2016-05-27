class IncomingMessagesController < ApplicationController
  skip_before_action :verify_authenticity_token
  # POST /emailin
  def create
    notifier = Slack::Notifier.new ENV["slack_webhook_url"], 
      channel: '#development'
    
    bad_keys = ["rack", "action_", "puma", "SERVER", "GATEWAY", "ROUTES", "SCRIPT", "warden"]
    keys = request.env.keys.reject { |key| key.start_with?(*bad_keys) }
    response = request.env.slice(*keys)
    
    notifier.ping "#{response}"
    
    render json: response
  end
end
