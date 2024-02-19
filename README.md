# Elmex

## Configure Elmex

Add Elmex configuration to your project.

The default configuration is:

```
config :elmex,
  # This is where the elm.json is located
  base_dir: "assets/elm",

  # This is where the elm apps are being bundled
  output_dir: "../../priv/static/assets",

  # The keys are the bundle names, the glob is the app
  # module dependencies. In this case an elmex.js is
  # generated and it will contains all the elm files.
  apps: [
    elmex: "src/*.elm"
  ]

  # The elm compiler options, you want to use --optimize
  # in production builds
  compiler_options: "--debug"
```

## Add a watcher

You can start Elmex in watch mode and add it to the
Phoenix endpoint watchers, to have your elm files
compiled on save.

```
    watchers: [
      esbuild: ...
      tailwind: ...
      elmex: {Elmex, :start, [:watch]}
    ]
```

## Add the Elmex hook to the Live Socket

Generate the Elmex phx-hook into `assets/vendor` with:

```
mix elmex.vendorize
```

Then import the hook and inject it into the live socket with:

```
...
import Elmex from "../vendor/elmex_hook"
...
let liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: {_csrf_token: csrfToken},
  hooks: {Elmex}
})
...
```

## Add the bundle to your layout

Add the compiled bundle into your pages as you wish.

For example, to add the `elmex.js` bundle to the root layout:

```
<script phx-track-static type="text/javascript" src={~p"/assets/elmex.js"}></script>
```

## Configure Tailwind (optional)

Put elm content into the project Tailwind configuration.

For example:

```
module.exports = {
  content: [
    "./js/**/*.js",
    "../lib/demo_web.ex",
    "../lib/demo_web/**/*.*ex",
    "./elm/**/*.elm" // Add this line...
  ],
  ...
```

## Quirks

- Flags are always strings
