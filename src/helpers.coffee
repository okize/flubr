module.exports =

  checkForUser: (req, res) ->
    if req.user?
      true
    else
      false