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

## #cbra extension to Gemfile

The :path option used for #cbras is typically a relative path. Because of that all gems and apps transitively including a
gem need to state the relative path to every gem with a path relatuive to their root. For an app, this is the reason why it is
unclear which gems it really directly depends on. That's why all dependencies of apps are omitted from the output graph.

To include direct dependencies of an application, add an additional option to the `gem` line from the Gemfile like so:

    gem "B", path: "../B", direct: true
    gem "C", path: "../C"
    gem "D", path: "../D"
    gem "E1", path: "../E1"
    gem "E2", path: "../E2"
    gem "F", path: "../F"

This is the (Gemfile of app A)[https://github.com/shageman/cbradeps/blob/master/spec/examples/letters/A/Gemfile]
from the letters example of which you see the graph above.

##TODOs

* support windows folders (searching for a couple slashes)
* support windows: don't shell out to find gemspecs and gemfiles
* info if no gem file found for gem
* warn if gem has name different than folder
* warn if same gem name is found with path and without
* error if there are multiple gem specs
* error if there is not gem file in root


## License

Copyright (c) 2014 Stephan Hagemann, stephan.hagemann@gmail.com, [@shageman](http://twitter.com/shageman)

Released under the MIT license. See LICENSE file for details.
