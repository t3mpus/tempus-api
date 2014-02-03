module.exports = (user)->
  obj =
    json: yes
  if user?.credentials?
    obj.hawk =
      credentials:
        key: user.credentials.secret
        id: user.credentials.userid
        algorithm: 'sha256'
  obj
