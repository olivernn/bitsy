# Bitsy

A simple bitmask in ruby.

## Installation

Add this line to your application's Gemfile:

    gem 'bitsy'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bitsy

## Usage

Create a bit mask class:

    class UserRoles < Bitsy
      flags :admin, :moderator, :author, :banned
    end

Then use this class to track which flags are set.

    user_roles = UserRoles.new
    user_roles.has_admin? # false
    user_roles << :admin
    user_roles.has_admin? # true

### Checking for flags

You can check for roles with the generated methods, e.g.

    user_roles.has_admin_and_moderator_and_author
    user_roles.has_admin_or_author

You can also use the underlying methods `every` and `some`:

    user_roles.every(:admin, :moderator, :author)
    user_roles.some(:admin, :author)

### Manipulating flags

Flags can be set, unset and toggled:

    user_roles.set(:admin)
    user_roles.unset(:author)
    user_roles.toggle(:moderator)

    user_roles << :banned

### Masks

Masks are automatically created for the flags you specify:

    UserRoles::ADMIN
    UserRoles::MODERATOR
    UserRoles::AUTHOR
    UserRoles::BANNED

Each of these is a `Bitsy::Mask`. These can be used to manipulate the flags directly, e.g. to set the `:banned` flag we can do:

    user_roles |= UserRoles::BANNED

Masks can be combined to form composite masks:

    UserRoles::ADMIN_AND_AUTHOR = UserRoles::ADMIN | UserRoles::AUTHOR

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
