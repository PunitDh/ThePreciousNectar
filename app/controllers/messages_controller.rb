class MessagesController < ApplicationController
    before_action :find_conversation

    def index
        # Set a maximum number of displayed messages on page
        max_messages = 7

        # Select all conversations where either the sender or the recipient is the current user
        @conversations = Conversation.all.where(sender_id: current_user).or(Conversation.all.where(recipient_id: current_user))

        # Select all messages in the conversation
        @messages = @conversation.messages

        # Limit the max number of displayed messages
        if @messages.length > max_messages
            @over_max = true
            @messages = @messages[-max_messages..-1]
        end

        # If user wants to see previous messages, let them
        if params[:m]
            @over_max = false
            @messages = @conversation.messages
        end
        
        # Mark all messages as read
        if @messages.last
            @messages.each { |message| message.update!(read: true) if message.user_id == current_user.id }
        end

        # Create a new message in the chat box
        @message = @conversation.messages.new
    end

    def new
        @message = @conversation.messages.new
    end

    def create
        # Create a new message and then save it
        @message = @conversation.messages.new(message_params)
        if @message.save
            redirect_to conversation_messages_path(@conversation)
        end
    end

    private
        def message_params
            params.require(:message).permit(:body, :user_id)
        end

        def find_conversation
            # I installed a failsafe here so that it will just redirect you to the conversations path if a conversation is not found
            begin
                @conversation = Conversation.find(params[:conversation_id])
            rescue ActiveRecord::RecordNotFound
                redirect_to conversations_path
            end
        end
end
