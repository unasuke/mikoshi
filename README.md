# Mikoshi
[![Build Status](https://travis-ci.org/unasuke/mikoshi.svg?branch=master)](https://travis-ci.org/unasuke/mikoshi)

This gem is tool to deploy ECS task definition and service with described by yaml documents.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mikoshi'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mikoshi

## Usage
First, describe task definition to yaml.

```yaml
# task_definitions/ping2googledns.yml.erb
family: "ping2googledns"
network_mode: "bridge"
container_definitions:
  - name: "ping"
    image: "unasuke/ping2googledns:latest"
    cpu: 128
    memory: 128
```

... and service too.

```yaml
# services/ping2googledns.yml.erb
cluster: "default"
service: "ping2googledns"
task_definition: <%= "ping2googledns:#{ENV['TASK_REVISION']}" %>
desired_count: 1
```

Then, invoke those commands.

```shell
# update task_definition
$ mikoshi update_task ping2googledns --region ap-northeast-1
Update task definition: ping2googledns
Done update task definition: ping2googledns revison: 6

# update service
$ TASK_REVISION=3 mikoshi update_service ping2googledns
Update service : ping2googledns
Waiting for 10 sec...
Update service success

# update task_definition and service
$ mikoshi deploy -t ping2googledns -s ping2googledns
Update task definition: ping2googledns
Done update task definition: ping2googledns revison: 7
Update service : ping2googledns
Waiting for 10 sec...
Waiting for 10 sec...
Waiting for 10 sec...
Update service success

# show help
$ mikoshi help
Commands:
  mikoshi deploy                       # Deploy task definition and service
  mikoshi help [COMMAND]               # Describe available commands or one specific command
  mikoshi update_service SERVICE_NAME  # Update service
  mikoshi update_task TASK_NAME        # Update task definition

Options:
  [--region=REGION]  # aws region

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/unasuke/mikoshi.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

