module TransactionsHelper
  def transaction_form_header(transaction_type)
    amount = case transaction_type
        when 'small'
          '0-100'
        when 'large'
          '100-1000'
        when 'extra'
          '>1000'
      end

    "Create #{amount} USD Transaction"
  end
end
