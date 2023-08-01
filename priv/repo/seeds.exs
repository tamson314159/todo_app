alias TodoApp.Repo
alias TodoApp.Accounts.Account
alias TodoApp.Tasks.Task

accounts = [
  {"user01@sample.com", "user01999"},
  {"user02@sample.com", "user02999"}
]

[a01, a02] =
  Enum.map(accounts, fn {email, password} ->
    Repo.insert!(
      %Account{
        email: email,
        hashed_password: Pbkdf2.hash_pwd_salt(password),
        confirmed_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)
      }
    )
  end)

tasks = [
  {"掃除", Date.utc_today(), true, a01},
  {"洗濯", Date.utc_today(), false, a01},
  {"炊事", Date.utc_today(), false, a02}
]

Enum.map(tasks, fn {title, date, completed, account} ->
  Repo.insert!(
    %Task{
      title: title,
      date: date,
      completed: completed,
      account_id: account.id
    }
  )
end)
