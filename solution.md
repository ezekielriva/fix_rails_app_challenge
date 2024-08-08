# Solution

This document tracks the steps I did (high level) to solve the problem.

1. Install ruby version `rvm install ruby-2.5.1`
1. Run `bundle install` (30 min)
    1. Fix gem mimemagic (0.3.3) due to it no longer exists. Updated rails to 5.2.5 closest version that support a new mimemagic version (~1.0)
1. Run `rake db:create; rake db:migrate; rake db:seed` (15 min)
    1. Fix `NameError: uninitialized constant Product::Fedex` by importing lib files to Rails and replacing `Fedex::STATUS` by `Fedex::Shipment::STATUS`
1. Fix Test Environment (30min) by set factory_bot_rails version compatible with `ruby 2.5.1`
1. Order Form (45min)
1. Admin Order Search (1h)
    1. Add an User authentication method using devise gem. (10 min)
    1. Block order search page / dashboard under an authentication method. (5 min)
    1. Add some filters. (30min)
    1. Alternatives: Implement ActiveAdmin for pt. 2 and 3, however I discarded it to no overload this rails app.
1. Add Automatic Shipping Status Updates Job (1.30h)
1. Improvements (30min)
