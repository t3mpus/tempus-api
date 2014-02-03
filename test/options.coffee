module.exports = (user)->
  obj =
    json: yes
  if user?.credentials?
    obj.hawk =
      credentials:
        secret: user.credentials.secret
        id: user.credentials.userid
  obj
