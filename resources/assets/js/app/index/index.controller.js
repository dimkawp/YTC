(function ()
{
    'use strict';

    angular.module('app.index')
           .controller('IndexController', IndexController);

    IndexController.$inject = ['users'];

    function IndexController(users)
    {
        var vm = this;

        vm.user = [];

        getUser();

        /*
         |--------------------------------------------------------------------------------------------------------------
         | Users
         |--------------------------------------------------------------------------------------------------------------
         */

        function getUser()
        {
            users.getUser().then(function (data)
            {
                vm.user = data;
            });
        }
    }
})();
