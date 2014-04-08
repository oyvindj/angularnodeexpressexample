shared = {}

userRoles = {
    public: 1
    user:   2
    admin:  4
}
accessLevels = {
    public: (userRoles.public | userRoles.user | userRoles.admin) 
    anon:   userRoles.public
    user:   (userRoles.user | userRoles.admin)                    
    admin:  userRoles.admin
}

shared.userRoles = userRoles

shared.accessLevels = accessLevels

module.exports = shared
