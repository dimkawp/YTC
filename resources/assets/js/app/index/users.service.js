(function ()
{
    'use strict';

    angular.module('app.index')
           .factory('users', users);

    users.$inject = ['$http'];

    function users($http)
    {
        return {
            "getUser": getUser
        };

        function getUser()
        {
            return $http.get('/api/users/me').then(function (response)
            {
                return response.data;
            });
        }
    }
})();
