# cbradeps

Prints and exports the dependencies within component-based Ruby/Rails applications (#cbra)

## Installation

Add this line to your application's Gemfile:

    gem 'cbradeps'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cbradeps

## Usage

    cbradeps [OPTION] [application path]

    Component-based Ruby/Rails dependency grapher.

    Options are...
        -t, --text                       DEFAULT Outputs a textual representation of the dependencies
        -g, --graph                      Outputs graph.png to the current directory
        -d, --dot                        Outputs graph.dot to the current directory

        -h, -H, --help                   Display this help message.

## Example

There are sample #cbra folder structures in `spec/examples`. Here is the graph generated for the letters app structure:

![Letters graph](https://raw.githubusercontent.com/shageman/cbradeps/master/spec/examples/letters.png)

##TODOs

* support windows folders (searching for a couple slashes)
* support windows: don't shell out to find gemspecs and gemfiles
* info if no gem file found for gem
* warn if gem has name different than folder
* warn if same gem name is found with path and without
* error if there are multiple gem specs
* error if there is not gem file in root


## License

Copyright (c) 2014 Stephan Hagemann
http://twitter.com/shageman
stephan.hagemann@gmail.com

Released under the MIT license. See LICENSE file for details.
