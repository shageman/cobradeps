# cbradeps

Prints and exports the dependencies within component-based Ruby/Rails applications

## Installation

Add this line to your application's Gemfile:

    gem 'cbradeps'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cbradeps

## Usage

    cbradeps [application path]
    
    Component-based Ruby/Rails dependency grapher.
    
    Options are...
        -h, -H, --help                   Display this help message.

##TODOs

* optionally output dotfile for all deps
* support windows folders (searching for a couple slashes)
* support windows: don't shell out to find gemspecs and gemfiles
* info if no gem file found for gem
* warn if gem has name different than folder
* warn if same gem name is found with path and without
* error if there are multiple gem specs
* error if there is not gem file in root


## License

    Copyright (c) 2014 Stephan Hagemann
    twitter.com/shageman
    stephan.hagemann@gmail.com

    Released under the MIT license. See LICENSE file for details.
