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
rails generate- auto creates a sepearate css file for each controller
we tend to make a single custom file though
asset pipeline- anything in app/assets/stylesheets will auto included as part of the application.css file included in the site layout. 

### Bootstrap
    @import "bootstrap-sprockets";
    @import "bootstrap"
Those two lines inside custom.scss for bootstrap magic 
# for id, . for class 

### Partials
partials - tuck away logic to its own place 
looks like this
      <%= render 'layouts/shim' %> 
rails will look for a file called app/views/layouts/_shim.html.erb, evaluates its contents, and insert the results into the view 






