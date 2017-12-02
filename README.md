Following Hartl's Ruby on Rails 
Tutorial

Chapter 3 
Setup
$ git remote add origin git@bitbucket.org:<username>/sample_app.git
$ git push -u origin --all # pushes up the repo and its refs for the first time

Deploy to Heroku with test page via hello action on app controller and as the root route 

$ heroku create
$ git push heroku master

StaticPages 
$ rails generate controller StaticPages home help

(note camelcase for controllers)
(destroy will cancel out generate)
(rails db:rollback will undo a single migration)

Tests
1. protect against regressions ( functioning features stop working for some reason)
2. allow code to be refactored ( change form w/o changing function)
3. act as a client for app code 

TDD- write fail test, write pass code, refactor

get 'static_pages/about' @ routes auto creates helper called static_pages_about_url

assert_select "title", "Home | Ruby on Rails Tutorial Sample App"
In particular, the code above checks for the presence of a <title> tag containing the string “Home | Ruby on Rails Tutorial Sample App”. 

def setup @setup file is auto run before every test 

<% provide(:title, "Home") %>dicates using <% ... %> that Rails should call the provide function and associate the string "Home" with the label :title.15 Then, in the title, we use the closely related notation <%= ... %> to insert the title into the template using Ruby’s yield function:
<title><%= yield(:title) %> | Ruby on Rails Tutorial Sample App</title>


