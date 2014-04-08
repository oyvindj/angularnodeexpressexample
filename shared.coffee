app = angular.module 'roles', []

app.factory('roles', ->
    roles = {}
  
    userRoles = {
        public: 1, # 001
        user:   2, # 010
        admin:  4  # 100
    }

    roles.userRoles = userRoles;
    roles.accessLevels = {
        public: userRoles.public | # 111
                userRoles.user   | 
                userRoles.admin,   
        anon:   userRoles.public,  # 001
        user:   userRoles.user |   # 110
                userRoles.admin,                    
        admin:  userRoles.admin    # 100
    }
    
    return roles
)
