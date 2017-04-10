(function ()
{
    'use strict';

    angular.module('app.index')
           .controller('IndexController', IndexController);

    IndexController.$inject = ['api', '$sce'];



    function IndexController(api, $sce)
    {
        var vm = this;

        vm.user = [];
        vm.fragment = [];
        vm.test = [];
        vm.postInfo = [];

        vm.preview = preview;
        vm.create = create;
        // vm.postInfo = postInfo;

        getUser();
        postInfo();
        /*
         |--------------------------------------------------------------------------------------------------------------
         | Fragments Create
         |--------------------------------------------------------------------------------------------------------------
         */

        function postInfo()
        {
            var data = {
                url: vm.fragment.url
            };

            api.postInfo(data).then(function (data)
            {
                vm.postInfo = data;
            });
        }

        function create()
        {
            var data = {
                url: vm.fragment.url,
                user_id: 28,
                start: vm.fragment.start,
                end: vm.fragment.end
            };

            api.postFragmentCreate(data).then(function (data)
            {
                vm.fragment = data;
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
                url: vm.fragment.url,
                start: vm.fragment.start,
                end: vm.fragment.end
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

        function getUser()
        {
            api.getUser().then(function (data)
            {
                vm.user = data;
            });
        }
    }
})();
