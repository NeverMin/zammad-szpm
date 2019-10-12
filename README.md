# Zammad::SZPM

This gem provides a class to parse, manipulate and store SZPM files and create ZPM strings from them.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'zammad-szpm'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install zammad-szpm

## Usage

First create an instance via passing the location to the .szpm file.

```ruby
require 'zammad/szpm'

szpm = Zammad::SZPM.new 'path/to/Zammad-Package.szpm'
```

### Create version

A new version can be created via passing the wanted version number and a change_log:

```ruby
szpm_hash_structure = szpm.version('1.0.1', 'Created first bug fix.')
```

### Add build information

It's recommended to add the build host and build date to the ZPM file. Give the build host as a parameter with to add the build information via:

```ruby
szpm_hash_structure = szpm.add_build_information('http://build.host.tld')
```

### Add file

To add additional files to the "FileList" structure of the (S)ZPM file call this method with the path and an optional permission integer (default is 644):

```ruby
szpm_hash_structure = szpm.add_file('path/to/file.rb')

# equals

szpm_hash_structure = szpm.add_file('path/to/file.rb', 664)
```

### Store changes

In case you want to store the changes you have made to the original SZPM file call this method:

```ruby
szpm_hash_structure = szpm.store
```

### Parse SZPM file

In limited cases it might necessary to re-parse the SZPM file again. Do this with:

```ruby
szpm_hash_structure = szpm.parse
```

### Get ZPM string

After all changes are made you might want to create a ZPM file. To receive the ZPM XML string with Base64 encoded files call this method:

```ruby
zpm_xml_string = szpm.zpm
```

## Planned and wanted features

Feel free to implement one of those or any other:

* Accept filehandle as constructor parameter.
* Accept SZPM content string as constructor parameter.
* Write ZPM file instead of only returning the string.
* Manipulate all the other attributes.
* Create SZPM file from a Hash structure.

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Tests

The tests are currently in an external project since there is business logic in them. In future releases this tests will be added to this gem repository as it should be.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/znuny/zammad-szpm. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
