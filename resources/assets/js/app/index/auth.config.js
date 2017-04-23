(function ()
{
    'use strict';

    angular.module('app')
           .config(authConfig)

    authConfig.$inject = ['$authProvider'];

    function authConfig($authProvider)
    {
        $authProvider.configure({
            apiUrl: '/api'
        });
    }
})();
