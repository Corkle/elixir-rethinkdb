ExUnit.start

Mix.Task.run "ecto.create", ~w(-r RethinkExample.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r RethinkExample.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(RethinkExample.Repo)

