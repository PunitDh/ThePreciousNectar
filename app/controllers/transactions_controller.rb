class TransactionsController < ApplicationController
    def success
        raise params[:format][:id][0].inspect
        
    end

    def cancel
    end
end
