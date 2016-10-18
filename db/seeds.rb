admin_user = User.create!(
  name: "Admin",
  email: "admin@example.org",
  password: "hunter2"
)

client_app = ClientApplication.create!(
  name: "In-house Web App",
  user: admin_user,
  in_house_app: true
)

token = AccessToken.for_client(client_app)
token.user = admin_user
token.save