# Following Hartl's Ruby on Rails Tutorial

## Chapter 3 
### Setup

    rails new sample_app
    
Go make a static_pages controller, and set the home page

    $ git remote add origin git@bitbucket.org:<username>/sample_app.git
    $ git push -u origin --all # pushes up the repo and its refs for the first time

Deploy to Heroku with test page via hello action on app controller and as the root route 
    
    $ heroku create
    $ git push heroku master

### StaticPages 
    $ rails generate controller StaticPages home help

(note camelcase for controllers)
(destroy will cancel out generate)
(rails db:rollback will undo a single migration)

### Tests
1. protect against regressions ( functioning features stop working for some reason)
2. allow code to be refactored ( change form w/o changing function)
3. act as a client for app code 

TDD- write fail test, write pass code, refactor (red,yellow,green)

def setup @setup file is auto run before every test 

    assert_select "title", "Home | Ruby on Rails Tutorial Sample App"
The code above checks for the presence of a <title> tag containing the string “Home | Ruby on Rails Tutorial Sample App”. 

### Routes 
get 'static_pages/about' @ routes auto creates helper called static_pages_about_url
Adding the root route leads to the creation of a Rails helper called root_url (in analogy with helpers like static_pages_home_url).

### Layout and Refactoring
<% provide(:title, "Home") %>dicates using <% ... %> that Rails should call the provide function and associate the string "Home" with the label :title.Then, in the title, we use the closely related notation <%= ... %> to insert the title into the template using Ruby’s yield function:
    <title><%= yield(:title) %> | Ruby on Rails Tutorial Sample App</title>

Layout files remove duplicaiton 

### Extra Gems
minitest - makes tests pretty
guard - automated tests 

## Chapter 4 
custom helper- new user-specified functions for use in views 

###Ruby
Parentheses on function calls are optional. 
Curly braces on final hash arguments are optional.
The Two are Equivalent
      stylesheet_link_tag('application', {media: 'all',
                                         'data-turbolinks-track': 'reload'})
      stylesheet_link_tag 'application', media: 'all',
                                         'data-turbolinks-track': 'reload'
above code calls the stylesheet_link_tag function with two arguments: a string, indicating the path to the stylesheet, and a hash with two elements, indicating the media type and telling Rails to use the turbolinks feature added in Rails 4.0.

###Classes
    class StaticPagesController < ApplicationController
means StaticPagesController is a class that inherits from ApplicationController

## Chapter 5
HTML5shim - HTML5 workaround, include for older browsers

link_to - first argument is link text, second is URL , third is options hash

image_tag - first argument path to an image, second optional hash

rails generate will auto creates a sepearate css file for each controller
we tend to make a single custom file though
asset pipeline- anything in app/assets/stylesheets will auto included as part of the application.css file included in the site layout. 

### Bootstrap
    @import "bootstrap-sprockets";
    @import "bootstrap"
Those two lines inside custom.scss for bootstrap magic 

### Partials
partials - tuck away logic to its own place 
looks like this

    <%= render 'layouts/shim' %> 

rails will look for a file called app/views/layouts/_shim.html.erb, evaluates its contents, and insert the results into the view 


### Asset Pipeline 
Rails pipeline has 3 standard directories for static assets 
* app/assets (assets for present app)
* lib/assets (assets for libraries)
* vendor/assets (assets from 3rd party)
Each dir has images, js, css 

Manifest file- tells rails how to combine assets into single files 
After asset assemblation, rails pushes them through preprocessing engines, and uses manifest files to combine them for delivery to the browser 

TLDR: asset pipeline combines all app stylesheets into one applicaiton.css, and all js into application.js 

### SASS
sass is a strict superset of css, meaning all css can be scss. 
allows nesting and variables 

### Layout LInks
Don't hard code, use named routes. 

### Rails Routes
defining a root route ie: root 'application#hello', arranges for the root path / to be routed to controller/action, and also creates a named route ie, root_path and root_url 

    root_path -> '/'
    root_url  -> 'http://www.example.com/'

Use paths for everything except redirects. Use URL for redirects 

### Integration tests

## Chapter 6 
database- rails way of data persistence

activerecord- the default library for interacting with the database 

migrations- feature that allow data definitions to be written in pure ruby, instead of learning a SQL data definition langauge. they alter the structure of the database incremnetally

the above features means you don't have to learn databases 

    rails generate model User name:string email:string 
models names are singular, controllers are plural. name and email are attributes. 

### Running a migration or migrating up
    rails db:migrate 
* first time it's run, it creats a file called db/development.sqlite3, which is a SQLite database
* see schema.rb for structure of database

### Rolling back a migration
    rails db:rollback
* implicitly executes drop_table to reverse the create_table from the migration 

### Sandbox
    rails console --sandbox
* any mods you make will be rolled back on exit 

### Creating User Objects 
* user.valid? (only checks if the object is valid)
* user = User.new (only creates an object in mmeory)
* user.save (after saved (assuming it succeeds) object will persist in database)
* user.create (user.new + user.save)

### Object attributes accessible via .
    user.name
    user.updated_at 

### Destroying User objects 
    user.destroy
* destroyed object still exists in memory
* destroyed objects can't be find() though 

### Finding user objects 
    User.find(1)
    User.find_by(name:"bob")
    User.first
    User.all

### Updating user objects 
    user.email="blah@blah.com"
    user.email="foo@blah.com"
    user.reload.email 
    // "blah@blah.com"
    user.save 

### Console command 
    User.create(name: "Michael Hartl", email: "michael@example.com", password: "foobar", password_confirmation: "foobar")

Reload reloads the object based on the database information 
Object will not save if validations don't pass 

    user.update_attributes(name:"bob", email: "bob@bob.com")
    user.update_attribute(:name, "El Duderino")
update_attributes accepts a hash of attritubutes and on success, updates and saves. returns true or false 

### Use TDD for model validations 

### validations 
* presence - if a given attribute is present 
  * validates(:name, presence: true)
* length - if a given attribute is within a range 
* format
* uniqueness 
* confirmation 
    assert @user.valid? 
    To see full message errors we can do user.errors.full_messages 

### Saving Passwords
logic 
* take a submitted password
* hash it 
* compare result to the hashed value in database 
has_secure_password onto user.rb 
* ability to save password_digest attribute 
* password/ passowrd confirmation attributes
* authenticate method, (returns true if password is correct)
* needs corresponding model to have attribute claled password_digest 
     rails generate migration add_password_digest_to_users password_digest:string

## Chapter 7 
### Environments 
rails has 3 envrionments
* test 
* development (default)
* production
To find out, type Rails.env in rails console 
To change env, pass in environment in rails console like as in
     rails console test 

### REST
REpresentational State Transfer, its a architectural style 
* represent data as resources that can be CRUD 

### CRUD 
* created
* read
* updated 
* deleted

### Resources 
    resource :users in config/routes.rb will create all RESTful routes 
* index via GET on /users
* show via GET on /users/1 
* new via GET on /users/new 
* create via POST on /users
* edit via GET on /users/1/edit 
* update via POST on /users/1
* destroy via DELETE on /users/1 

### Making the (individual) User Page (users/1)
Have a show action, with @user defined by User.find(parmas[:id])
Have a show view 

### Debugger 
     debugger 
add in that line anywhere, and you can go debug

### Gravatar 
* service that provides a globally recognized avatar 
* gravatar URLs are based on an MD5 hash of the user's email address
* different avatars for different emails 
* by default, methods defined in any helper file are automatically available in any view, but put gavatar_for method in the users_helper because we use these avatars for users

### Making the sign up page (users/new) 
form_for 

### Displaying Error Messages on SignUp 
Create a shared folder in views if you're going to use helpers that are available throughout the application

### Integration Tests
* suitable to test for invalid submission
    rails generate integration_test users_signup
* to test to makes no new user is created with invalid submissions, we make the sure the # of users is equivalent before and after attempting to create an user 

### On finish SignUp Form 
* on successful creation of a user, we want to redirect to the newly created user's profile 
    if @user.save
        redirect_to @user 
    else 
        render 'new'
    end
* rails automatically infers form redirect_to @user that we want to redirect to user_url(@user)

### Flash
* a rails method to quickly display a temporary message 
    flash[:success]="Welcome to the Sample App!"
    flash[:danger]= "It failed." 
* bootstrap css supports styling for success, info, warning, danger 

### Reset database 
    rails db:migrate:reset 

### assert_no_difference 
    assert_no_difference 'User.count' do
      post users_path, ...
    end
* first argument is string 'User.count'
* makes a comparison between User.count before and after the contents of the assert_difference 
* second optional argument specifies the size of the difference 

## Production Grade Server
### enable SSL 
     config.force_ssl= true @ config/environments/production.rb
### switch from WEBrick (heroku default) to Puma 
* change config file
* define procfile 

## Chapter 8 

### HTTP 
* a stateless protocol 
* means each request is an independent transaction that is unable to use information form any previous requests 
* tldr: HTTP can't remember a user's identity page to page 

### Session
* a semi-permanent connection between two computers 
* web apps requiring user login uses these 
* model sessions as a resource 
* login page -> new session
* act of logging in -> create session
* log out -> destory session 

### Cookies 
* Small pieces of text placed on the user's browser 
* persist from one page to another page 
* we use cookies to store information 
* sessions will use cookies 

### Session Routes 
* we need only new, create, and destroy actions
* GET on '/login' is new 
* POST on '/login' is create
* DELETE on 'logout' is destroy
* there is no session model (sessions are not a Active Record model )
* but there is a session controller with corresponding actions

### Form for w/o a model 
     form_for(:session, url: login_path)

### Flash
* Contents of the flash persist for one request
* Rendering/re-rendering a template doesn't count as a request
* So if you flash a message with a render, that message will persist and be displayed when you say click 'home' (which is a request)

### Integration Test to test correct flashing
* visit login path
* assert sessions/new renders 
* post to sessions path with invalid params
* verify that sessions/new re-renders 
* vist another page
* verify flash doesn't appear 

### Flash.now 
* flashes will dissapear as soon as there is an additional request 
     flash.now[:danger] = 'Invalid email/password combination'
 
### SessionsHelper
* include SessionsHelper @ applicaiton_controller.rb 
* when user logins in, we place user's id using session[:user_id] which are encrypted and redirect_to the user's profile page 

### ||=
* or equals
* similar to x=x+1 -> x+=1
* @foo = @foo || "bar" -> @foo||="bar"
* if @foo is false, then assign bar to @foo
* if @foo is true, then nothing 

### Fixtures
* way of organizing data to be loaded into the test database 

## Chapter 9 

### Advanced Login 
* Permanent cookies 
* "remember me" features, that remember me checkbox 
* that means users will auto stay logged in until they explicitly log out 
* persistent cookies are vulnerable to session hijacking 

### Persistant Sessions 
* create a random string of digits for use as a token
* place token in the browser cookies with expiration date way off
* save hash digest of the token to the database
* place an encrypted version of the user's id in the browsers cookies
* when presented with a cookie matching user id, find the user in the databse using the given id, verfiy that the token cookie matches the associated hash digest 
* PSA: digest - output of the cypt hash 

### SecureRandom.urlsafe_base64 
* its a method, andd we can use on console 
* returns a random string of length 22, each character has 64 possibilities

### Turn on Maintenance mode for Heroku
     heroku maintenance:on @ terminal 
     heroku maintenance:off 
# dispalying a standard error page while while site is down 

## Chapter 10 
### Updating Users (edit them)
### authentication - allows us to identify users of our site 
### authorization - lets us to control what they can do 

Logic : 
* if you're not logged in and you try to go to your edit page, you'll be forwarded to the login page with a helpful message
* if you're not logged in and you try to go a page they'll never be authorized for, they will be forwarded to the root URL 
* we use a before filter to implement this 
    before_action :logged_in_user, only: [:edit, :update] 

    def logged_in_user
         unless logged_in?
           store_location
           flash[:danger] ="Please log in."
           redirect_to login_url
          end
    end 

* before filter uses before action to arrange for a method to be called before the given actions 
* ie: before the edit/ update action,  we will call on the logged_in_user method 
* by default, before filters apply to every action in a controller 

### Sample Users (Faker GEM)
* include gem 'faker' inside gemfile 
* create! is like create but raises an exception for an invalid user rather than returning false 
* do your faker stuff in the seeds.rb file 
    rails db:migrate:reset
    rails db:seed

### Pagination 
* will paginate method placed inside a users view, looks for an @users object, and displays pagination links to access other pages 
* instead of User.all @ index method, use 
     @users = User.paginate(page: params[:page])

### Refactor 
When you call render not on a string with the name of a partial, but rather on a user variable of class User, Rails will llook for a partial called _user.html.erb 

When you call render on @users ( a list of User objects) rails auto iterates through them and renders each one with _user.html.erb 

so much magic :( 

### Deleting Users 
* admin is a boolean attribute on User model 
* 






