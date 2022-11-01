class TransactionsController < ApplicationController

  def index
    ### FIX ME
    ### Use pagination here
    @transactions = Transaction.includes(:manager)
  end

  def show
    @transaction = Transaction.find(params[:id])
  end

  def new
    @transaction_type = params[:type] || 'small'
    @transaction = Transaction.new
    get_manager

    render "new_#{@transaction_type}"
  end

  def create
    @transaction = Transaction.new(transaction_params)

    if @transaction.save
      redirect_to @transaction
    else
      get_manager if params[:type] == 'extra'
      render "new_#{params[:type]}"
    end
  end

  private
  def transaction_params
    params.require(:transaction).permit(
      :manager_id,
      :first_name,
      :last_name,
      :from_amount,
      :from_currency,
      :to_currency
    )
  end

  def get_manager
    @manager = Manager.order("RANDOM()").first
  end
end
