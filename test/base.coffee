module.exports = (path)->
  host = process.env.TEMPUS_HOST || '127.0.0.1'
  port = process.env.PORT || 3000
  scheme = process.env.TEMPUS_SCHEME || 'http'
  path = path or '/'
  if path[0] isnt '/'
    path = '/' + path

  "#{scheme}://#{host}:#{port}#{path}"

