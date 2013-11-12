module.exports = (path)->
  host = process.env.TEMPUS_HOST || '127.0.0.1'
  port = process.env.PORT || 3000
  scheme = process.env.TEMPUS_SCHEME || 'http'
  "#{scheme}://#{host}:#{port}"

