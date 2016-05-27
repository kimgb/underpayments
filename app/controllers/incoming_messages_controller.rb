class IncomingMessagesController < ApplicationController
  # POST /emailin
  def create
    notifier = Slack::Notifier.new ENV["slack_webhook_url"], 
      channel: '#development'
    
    bad_keys = ["rack", "action_", "puma", "SERVER", "GATEWAY", "ROUTES", "SCRIPT", "warden"]
    keys = request.env.keys.reject { |key| key.start_with?(*bad_keys) }
    
    notifier.ping "#{request.env.slice(*keys)}"
    # respond_to do |format|
    #   format.json do
    #     bad_keys = ["rack", "action_", "puma", "SERVER", "GATEWAY", "ROUTES", "SCRIPT", "warden"]
    #     keys = request.env.keys.reject { |key| key.start_with?(*bad_keys) }
    #     
    #     render json: request.env.slice(*keys)
    #   end
    # end
  end
end
