class ConversationsController < ApplicationController
    before_action :authenticate_user!

    def index
        conversations_receiver = Conversation.all.where(recipient_id: current_user.id)
        conversations_sender = Conversation.all.where(sender_id: current_user.id)
        conversation = conversations_receiver.first || conversations_sender.first
        unless conversations_receiver.length + conversations_sender.length == 0
            redirect_to conversation_messages_path(conversation.id)
        end
    end

    def create
        unless params[:sender_id] != params[:recipient_id]
            if (Conversation.between(params[:sender_id], params[:recipient_id]).present?)
                @conversation = Conversation.between(params[:sender_id], params[:recipient_id]).first
            else
                @conversation = Conversation.create!(conversation_params)
            end
            redirect_to conversation_messages_path(@conversation)
        end
    end

    private
        def conversation_params
            params.permit(:sender_id, :recipient_id)
        end
end
