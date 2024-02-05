# Seeds.ex
{:ok, user} =
  PicChat.Accounts.register_user(%{
    email: "test@test.test",
    password: "testtesttest"
  })

for n <- 1..100 do
  PicChat.Messages.create_message(%{user_id: user.id, content: "message #{n}"})
end
