class MessagesController < ApplicationController
    before_action :find_conversation

    def index
        max_messages = 7
        @conversations = Conversation.all.where(sender_id: current_user).or(Conversation.all.where(recipient_id: current_user))

        @messages = @conversation.messages
        if @messages.length > max_messages
            @over_max = true
            @messages = @messages[-max_messages..-1]
        end

        if params[:m]
            @over_max = false
            @messages = @conversation.messages
        end
        
        if @messages.last
            @messages.each { |message| message.update!(read: true) if message.user_id == current_user.id }
        end

        @message = @conversation.messages.new
    end

    def new
        @message = @conversation.messages.new
    end

    def create
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
            @conversation = Conversation.find(params[:conversation_id])
        end
end
