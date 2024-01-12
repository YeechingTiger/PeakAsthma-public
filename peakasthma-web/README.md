## Hello!

Just starting?

- `bundle`
- `bundle binstub guard rspec-core sidekiq foreman puma`
- `bin/rails secrets:setup`
- `bin/rails secrets:edit` - add secrets here for your local database config:
```
shared:
  db_host: localhost
  db_name: DB NAME HERE
  db_username: DB USER HERE
  db_password: DB PASS HERE
```
- `bin/rails db:drop db:create db:migrate`
- `bin/rspec` - this should produce 100% coverage

Before deployment:

- Add a secret key base for both staging and production environments.
You can generate a secret by running `bin/rails secret`. Use a different secret for each environment!
Add the secret to your secrets file (`bin/rails secrets:edit`).
You'll also want to add your database information for your staging and production databases:

```
staging:
  db_host: ...
  db_username: apps
  db_password: ...
  secret_key_base: ...

production:
  db_host: ...
  db_username: apps
  db_password: ...
  secret_key_base: ...
```

-
