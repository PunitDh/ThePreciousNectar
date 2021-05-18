class TransactionsController < ApplicationController
    def create
        session = Stripe::Checkout::Session.create({
            payment_method_types: ['card'],
            line_items: 
            [
                {
                    price_data:
                    {
                        unit_amount: 2000,
                        currency: 'aud',
                        product_data: { name: 'Stubborn Attachments', },
                    },
                    quantity: 1,
                }
            ],
            mode: 'payment',
            success_url: checkout_success_url,
            cancel_url:  checkout_cancel_url,
        })

        render json: {  id: session.id  }.to_json
    end

    def success
    end

    def cancel
    end
end
