### Please describe found weak places below.

#### Security issues

1. `TransactionsController#create`: should not use `permit!` to avoid accepting unwanted params from client

2. No authentication/authorization found, anyone can create and view all transactions.

#### Performance issues

1. `TransactionsController#index` : if we have huge of transactions, it will kill the memory. We should paginate transaction before showing the list.

2. `TransactionsController#new` : `@manager = Manager.all.sample` => This line will load all managers in database onto memory then pick a sample. It's very bad if we have huge of managers in database.

3. N+1 problem in `views/transactions/index.html.erb`. When display a each transaction, there is a SQL query required to get manager.

#### Code issues

1. Redundant code

    - We don't need action `TransactionsController#new_large` and `TransactionsController#new_extra_large`

    - We don't need the line `@manager = Manager.order("RANDOM()").first` in `TransactionsController#create` because manager is already a param submitted with the form

2. Duplicate code

    - In templates creating transaction. We can use one template for 3 transaction types.

    - Duplicate code for `Manager.all.sample`. Create a method to reuse.

3. In model `Manager`, `has_many` should define option `dependent`. I think we should `nullify` transactions if `manager` is destroyed

4. In model `Transaction`, if validations have same rule we can group them into one line.

```
validates :first_name, presence: true, if: :large?
validates :last_name, presence: true, if: :large?

=> validates :last_name, :last_name, presence: true, if: :large?
```

5. If we need an UUID for transaction, we should use Postgres UUID instead of generating ourselves. It also ensure `uid` is unique.

6. In `TransactionsController#create` we always find manager, we should only find manager if transaction can't not be saved

7. Method `full_name` and `client_full_name` can be put into a Decorator to simplify the model.

#### Others

1. When user creates a extra transaction, he/she should be able select manager intead of a random manager assigned by the system.

2. No client side validation.

3. No errors shown when user create small transaction with amount > 100 USD.

4. From address in `application_mailer.rb` should use ENV varibale
