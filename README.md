### Intro

Inflatahook is half a hack-day.  It's a little Sinatra app with Redis persistence to make webhook
endpoints and have a work queue to do stuff with not much effort.

### 1. Set Up Some Hosting Somewhere

This will probably work on Heroku or AWS Micro instances.

### 2. Set Up Redis To Go

It's free and you don't even have to click a confirmation URL.

https://redistogo.com/signup

### 3. Put your Redis To Go redis:// URL in redis.yml

So easy.

### 4. Edit views/index.haml : add form fields

Anything you want.  If you're gonna send the user an email, put an email field.  We'll give these
to you when you catch a webhook later.

### 5. Edit web.rb : push your form fields to Hook.create in post "webhook/create/"

Put the above fields in a hash, this is where we save them.

### 6. Grab what you want from the hook and the fields above in post "/h/hook_id"

The hook is in "request", the endpoint settings from above are in @endpoint.  Cram them in a hash and create a Job.

### 7. Do some fancy asynchronous work in work.rb

Edit Job.perform

### 8. Fire up the web interface

    bundle exec ruby web.rb

### Starting the work queue

    bundle exec resque work -q default -r ./work.rb