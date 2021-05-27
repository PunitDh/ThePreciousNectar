class ConversationsController < ApplicationController
    before_action :authenticate_user!

    def index
        # Create a list of all conversations where the current user is the sender or the receiver
        conversations_receiver = Conversation.where(recipient_id: current_user.id)
        conversations_sender = Conversation.where(sender_id: current_user.id)
        conversation = conversations_receiver.first || conversations_sender.first

        # If conversations exist, redirect to the messages index, or else display "No messages"
        unless conversations_receiver.length + conversations_sender.length == 0
            redirect_to conversation_messages_path(conversation.id)
        end
    end

    def create
        # A safety check to makes sure that a user is not sending messages to themselves
        unless params[:sender_id] == params[:recipient_id]

            # If a conversation already exists, go to the conversation. Else create a new conversation.
            @conversation = (Conversation.between(params[:sender_id], params[:recipient_id]).present?) ? Conversation.between(params[:sender_id], params[:recipient_id]).first : Conversation.create!(conversation_params)

            redirect_to conversation_messages_path(@conversation)
        end
    end

    private
        def conversation_params
            params.permit(:sender_id, :recipient_id)
        end
end
