module.exports = (user)->
  obj =
    json: yes
  if user?.credentials?
    obj.hawk =
      credentials:
        key: user.credentials.secret
        id: user.credentials.user_identifier
        algorithm: 'sha256'
  obj
