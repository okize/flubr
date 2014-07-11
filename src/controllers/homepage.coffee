module.exports =

  # homepage
  index: (req, res) ->
    res.render 'homepage',
      env: process.env.NODE_ENV
      title: 'Log in'
      css: 'body { background-color: red; }'
      js: "console.log('hello');"