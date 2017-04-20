(function ()
{
    'use strict';

    angular.module('app.index')
           .controller('IndexController', IndexController);

    IndexController.$inject = ['$auth', '$sce', 'api'];

    function IndexController($auth, $sce, api)
    {
        var vm = this;

        vm.user = $auth.user;
        vm.fragment = [];

        vm.login = login;
        vm.logout = logout;
        vm.preview = preview;

        /*
         |--------------------------------------------------------------------------------------------------------------
         | Auth
         |--------------------------------------------------------------------------------------------------------------
         */

        function login()
        {
            $auth.authenticate('google').then(function (response)
            {
                //
            });
        }

        function logout()
        {
            $auth.signOut().then(function (response)
            {
                //
            });
        }

        /*
         |--------------------------------------------------------------------------------------------------------------
         | Fragments
         |--------------------------------------------------------------------------------------------------------------
         */

        function preview()
        {
            var data = {
                url: vm.fragment.url
            };

            api.getEmbedUrl(data).then(function (data)
            {
                vm.fragment.embed_url = $sce.trustAsResourceUrl(data);
            });
        }

        /*
         |--------------------------------------------------------------------------------------------------------------
         | Users
         |--------------------------------------------------------------------------------------------------------------
         */
    }
})();
