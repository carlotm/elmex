# Elmex

## Configure Elmex

TODO

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

# TODO

- Write instructions to install the hook (in vendor for now)
- Write instructions to add elm files to tailwind config
- Write instructions to add the elm built files
- Find a way to build only one asset
