# Bank Account System

- Simple Ruby on Rails Bank Account System
- Rails 6 API

## Installation

```bash
git clone https://github.com/arnautova-a/bank_accounting_system.git
cd bank_accounting_system
bundle
rails db:create db:migrate
rails s
```

## API

### create user
to create a user need to fill in name, id number and tags

```bash
curl -H 'Content-Type: application/json' -X POST localhost:3000/users -d '{"full_name": "Test User", "id": 3, "tag": "new tag"}'
```

### open a new account
to open a new account need to fill in the currency and user id (`:user_id`)

```bash
curl -H 'Content-Type: application/json' -X POST localhost:3000/users/:user_id/accounts -d '{"currency": "EUR"}'
```

### deposit into account
need to fill in `:user_id`, `:currency` and amount

if the user doesn't have an account in provided currency, it will be created automatically and transaction will be completed

```bash
curl -H 'Content-Type: application/json' -X POST localhost:3000/users/:user_id/accounts/:currency/deposit -d '{"amount": 150}'
```

### transfer from one account to another
transfer between accounts by sender `:user id`, `:currency` and recipient id

if the recipient user doesn't have an account in provided currency, it will be created automatically and transaction will be completed

```bash
curl -H 'Content-Type: application/json' -X POST localhost:3000/users/:user_id/accounts/USD/transfer -d '{"amount": 150, "recipient_id": 3}'
```

## Generating CSV Statements

CSV statements can be found in `tmp` directory

### Deposit statement
deposit amount for the period of time filtered by currency and users

`start_date` and `end_date` params provide in ISO format (YYYY-MM-DD)

```bash
curl -H 'Content-Type: application/json' -X GET localhost:3000/accounts/deposit_statement -d '{"currency": "USD", "user_id": 2, "start_date": "2021-11-10", "end_date": "2021-11-16"}'
```
### Minimum, maximum and average transfer amount
with the ability to filter by user's tags and a period of time

```bash
curl -H 'Content-Type: application/json' -X GET localhost:3000/accounts/min_avg_max_statement -d '{"tag": "tag", "start_date": "2021-11-10", "end_date": "2021-11-16"}'
```