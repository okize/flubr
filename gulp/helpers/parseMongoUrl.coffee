# parse mongodb connection url

module.exports = (url) ->
  prefix = 'mongodb://'
  unless url.indexOf(prefix) is 0
    throw Error('Invalid mongodb URL')
  url = url.replace(prefix, '')
  parsed = {}

  # get database
  split = url.split('/')
  url = split[0]
  parsed.database = split[1]

  # get username & password
  split = url.split('@')
  if split.length > 1
    url = split[1]
    split = split[0].split(':')
    parsed.username = split[0]
    parsed.password = split[1]

  # get host & port
  split = url.split(':')
  parsed.host = split[0]
  parsed.port = split[1]

  # return parsed mongodb url
  parsed
