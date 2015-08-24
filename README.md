# Rbots
Collection of Ruby bots.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rbots'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rbots

## Usage

**For development use:**

- Take note that this is a public repository. If that later seems to be a
mistake, we can reevaluate. This warning is meant to help prevent you from
committing hubot's password to a public repo as I did recently. Whoopsie daisy.
- Speaking of hubot's password, you will need retrieve it from where it lives
in Core `config/rubber/rubber-hubot.yml`. If you don't know what that means,
this branch is not intended for you, go away.
- After you have hubot's password, add it to your bash environment. The
following means should allow for making the password accessible to the Robut bin
while also not storing it in your .bash_history.
```bash
$ read HUBOT_PASSWORD <enter>
<paste password> <enter>
$ echo $HUBOT_PASSWORD <enter>
<You should see the password you pasted>
```
- I've tried to make this repo bot agnostic so we could potentially run
multiple bots of the same repo, so please strive for this same goal. Part of
supporting this behavior means that many of the bot specific vars are currently
pulled from the environment. We should make that better later, but it's fine for
now. I think. Anyway, to run hubot you'll need to run something that looks like
this:

```bash
# These three vars are constant and required for hubot
export RBOT_JID="24338_808833@chat.hipchat.com/bot"
export RBOT_PASSWORD="$HUBOT_PASSWORD"
export RBOT_NICK=hubot

# These vars you can play with
export RBOT_AUX_MENTION=rbot
export RBOT_ROOM="24338_light_labs@conf.hipchat.com"
bundle exec robut Chatfile
```

Similarly, for Zero:

```bash
# These three vars are constant(ish) and required for zero:
export RBOT_JID="24338_2252410@chat.hipchat.com/bot"
export RBOT_PASSWORD="$ZERO_PASSWORD"
export RBOT_NICK=zero

# These vars you can play with
export RBOT_AUX_MENTION=zbot
export RBOT_ROOM="24338_light_labs@conf.hipchat.com"
bundle exec robut Chatfile
```

- After all that, you should have an XMPP bot running on your local machine
connected to whatever room you specified. By default, this branch includes the
`Rbots::Plugin::Pry` plugin that will cause the bot to drop into Pry anytime it
receives an @mention to the `RBOT_AUX_MENTION` name. You will not see another
instance of hubot or zero running, instead there are multiple bots serving that
same username. Because of this, while there's still a JS hubot running, it's
best to address the bot you're working on by it's `RBOT_AUX_MENTION` name.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release` to create a git tag for the version, push git commits
and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/backupify/rbots/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
