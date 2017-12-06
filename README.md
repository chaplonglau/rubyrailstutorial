# Following Hartl's Ruby on Rails Tutorial

## Chapter 3 
### Setup
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









