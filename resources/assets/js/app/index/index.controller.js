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
        vm.cloudinary = [];
        vm.download = [];

        vm.preview = preview;
        vm.create = create;
        vm.postInfo = postInfo;
        vm.cloudinary = cloudinary;
        vm.download = download;

        getUser();
        postInfo();
        /*
         |--------------------------------------------------------------------------------------------------------------
         | Fragments Create
         |--------------------------------------------------------------------------------------------------------------
         */
        // postInfo = function() {
        //     vm.info = !vm.info;
        // };

        /*
         |--------------------------------------------------------------------------------------------------------------
         | Fragments Download
         |--------------------------------------------------------------------------------------------------------------
         */

        function download() {

            var data = {
                user_id: '28'
            };

            api.download(data).then(function (data) {
                vm.download = data;

            });

        }

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

        /*
         |--------------------------------------------------------------------------------------------------------------
         | Fragments Claudinary
         |--------------------------------------------------------------------------------------------------------------
         */

        function cloudinary() {

            var data = {
                user_id: '28'
            };

            api.cloudinary(data).then(function (data) {
                vm.cloudinary = data;

            });

        }



        /*
         |--------------------------------------------------------------------------------------------------------------
         | Fragments Create
         |--------------------------------------------------------------------------------------------------------------
         */

        function create()
        {
            var data = {
                url: vm.fragment.url,
                user_id: 28,
                start: vm.fragment.start,
                end: vm.fragment.end
            };

            vm.fragment.isCreating = true;

            api.postFragmentCreate(data).then(function (data)
            {
                vm.fragment = data;
                // vm.fragment.isCreated = true;
                download();
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
