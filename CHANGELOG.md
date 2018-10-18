## 0.3.4 (2018-10-18)

Features:

  - `dci_context!` RSpec helper.

## 0.3.2 (2018-06-01)

Features:

  - `include_context_event` RSpec matcher.


## 0.3.1 (2018-05-25)

Features:

  - Cleaned up gemspec to only include needed files.
  - Applied some more rubocop rules.

## 0.3.0 (2018-05-24)

Features:

  - Renamed `DCI::Configuration` accessors. `event_routes` is now `routes`, `route_methods` is now `router`, `raise_in_event_router` is now `raise_in_router`.
  - `events` is not an instance variable defined in the context anymore, but has the same access style like the `context` itself. In the role don't push events to `context.events`, but to `context_events`.

## 0.2.0 (2018-05-19)

Features:

  - `DCI::Configuration` now takes a `on_exception_in_router` handler, instead of requiring a `logger` instance.

Bugfixes:

  - Added specs
  - Added `README.md`
  - Added `CHANGELOG.md`

## 0.1.0 (2018-05-18)

Features:

  - `DCI::Context` with basic functionality
  - `DCI::Role` with basic functionality
