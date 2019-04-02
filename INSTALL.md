Welcome to my code challenge!  To install on your local system, follow these steps:

1. Clone the repository to your local system
2. At a terminal, in the folder the repository is downloaded to, type
```
bundle install
```
(Note: If you get `bundle: command not found`, you need to `gem install bundler` first.)

3. Once the process is complete, run
```
rails db:create
rails db:migrate
rails server
```
4. You should now be able to make API requests using Postman or Insomnia to `http://localhost:3000`.
5. To run tests, type
```
rspec -fd
```
