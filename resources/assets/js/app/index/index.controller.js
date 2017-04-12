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
        vm.fragments = [];
        vm.test = [];
        vm.postInfo = [];
        vm.cloudinary = [];

        vm.preview = preview;
        vm.create = create;
        vm.postInfo = postInfo;
        vm.cloudinary = cloudinary;
        vm.download = download;
        vm.uploaded = uploaded;

        getUser();
        getFragment();
        // postInfo();

        /*
         |--------------------------------------------------------------------------------------------------------------
         | Fragments Download
         |--------------------------------------------------------------------------------------------------------------
         */

        function download()
        {
            var data = {
                user_id: '28'
            };

            api.download(data).then(function (data)
            {
                //
            });
        }

        function uploaded()
        {
            var data = {
                user_id: '28'
            };

            api.uploaded(data).then(function (data)
            {
                //
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

        function cloudinary()
        {
            var data = {
                user_id: '28'
            };

            api.cloudinary(data).then(function (data)
            {
                vm.cloudinary = data;
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

            vm.fragment.isPreviewing = true;

            api.getEmbedUrl(data).then(function (data)
            {
                vm.fragment.embed_url = $sce.trustAsResourceUrl(data);
            });
        }

        function create()
        {
            var data = {
                url: vm.fragment.url,
                start: vm.fragment.start,
                end: vm.fragment.end,
                title: vm.fragment.title
            };

            vm.fragment.isCreating = true;

            api.createFragment(data).then(function (data)
            {
                vm.fragment = data;

                download();
                cloudinary();
                uploaded();


                // download();
            });
        }

        function getFragment()
        {

            api.getFragment().then(function (data)
            {
                vm.fragments = data;
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
