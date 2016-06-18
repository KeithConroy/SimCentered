# SimCentered
An online management system used for scheduling events and tracking inventory

## Overview
Organinzations will create an account which will be accessible by a unique subdomain.  The account can be populated with users, rooms and inventory.  Events can be scheduled and reserve users, rooms and inventory for that given time.  Users will be able to receive email and in app notifications about their schedules.  Inventory tracking will be able to alert when supplies are low and produce usage reports for any given item/equipment.

#### Ruby Version

2.0.0

#### Rails Version

4.2.6

#### Instructions to execute project

After cloning or unzipping, navigate to the SimCentered directory.

Run `bundle install` to install the necessary gems.

Run the rails server with `bin/rails s`.

Set up the database using `bin/rake db:create db:migrate db:seed`.

Run the test suite with `bundle exec rspec`

Navigate to [http://localhost:3000/](http://localhost:3000/) and view the application.
