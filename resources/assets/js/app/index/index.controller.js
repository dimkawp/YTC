(function ()
{
    'use strict';

    angular.module('app.index')
           .controller('IndexController', IndexController);

    IndexController.$inject = ['$auth', '$sce', '$interval', 'api'];

    function IndexController($auth, $sce, $interval, api)
    {
        var vm = this;

        vm.user     = $auth.user;
        vm.video    = [];
        vm.fragment = [];

        vm.login             = login;
        vm.logout            = logout;
        vm.getUserFragments  = getUserFragments;
        vm.createVideo       = createVideo;
        vm.downloadVideo     = downloadVideo;
        vm.uploadVideo       = uploadVideo;
        vm.getVideoEmbedUrl  = getVideoEmbedUrl;
        vm.getVideoStatus    = getVideoStatus;
        vm.createFragment    = createFragment;
        vm.deleteFragment    = deleteFragment;
        vm.uploadFragment    = uploadFragment;
        vm.getFragmentStatus = getFragmentStatus;
        vm.getFragmentUrl    = getFragmentUrl;
        vm.reloadPage        = reloadPage;

        /*
         |--------------------------------------------------------------------------------------------------------------
         | Auth
         |--------------------------------------------------------------------------------------------------------------
         */

        function login()
        {
            $auth.authenticate('google');
        }

        function logout()
        {
            $auth.signOut();
        }

        /*
         |--------------------------------------------------------------------------------------------------------------
         | Users
         |--------------------------------------------------------------------------------------------------------------
         */

        function getUserFragments()
        {
            var data = {
                id: vm.user.id
            };

            api.getUserFragments(data).then(function (data)
            {
                vm.user.fragments = data;
            });
        }

        /*
         |--------------------------------------------------------------------------------------------------------------
         | Videos
         |--------------------------------------------------------------------------------------------------------------
         */

        function createVideo()
        {
            var data = {
                url: vm.video.url
            };

            api.createVideo(data).then(function (data)
            {
                vm.video = data;
                vm.video.isPreviewing = true;

                vm.fragment.start_from  = 0;
                vm.fragment.end_from    = vm.video.duration;
                vm.fragment.title       = vm.video.title;
                vm.fragment.description = vm.video.description;

                getVideoEmbedUrl();
            });
        }

        function downloadVideo()
        {
            var data = {
                id: vm.video.id
            };

            api.downloadVideo(data).then(function (data)
            {
                vm.video.status = data.status;
            });

            var status = $interval(function ()
            {
                if (vm.video.status == 'downloaded' || vm.video.status == 'uploaded')
                {
                    if (vm.video.status == 'downloaded')
                    {
                        uploadVideo();
                    }

                    if (vm.video.status == 'uploaded')
                    {
                        uploadFragment();
                    }

                    $interval.cancel(status);
                }

                getVideoStatus();
            }, 5000);
        }

        function uploadVideo()
        {
            var data = {
                id: vm.video.id
            };

            api.uploadVideo(data).then(function (data)
            {
                vm.video.status = data.status;
            });

            var status = $interval(function ()
            {
                if (vm.video.status == 'uploaded')
                {
                    uploadFragment();

                    $interval.cancel(status);
                }

                getVideoStatus();
            }, 5000);
        }

        function getVideoEmbedUrl()
        {
            var data = {
                id: vm.video.id,
                start_from: vm.fragment.start_from,
                end_from: vm.fragment.end_from
            };

            api.getVideoEmbedUrl(data).then(function (data)
            {
                vm.video.embed_url = $sce.trustAsResourceUrl(data.embed_url);
            });
        }

        function getVideoStatus()
        {
            var data = {
                id: vm.video.id
            };

            api.getVideoStatus(data).then(function (data)
            {
                vm.video.status = data.status;
            });
        }

        function deleteFragment(fragment)
        {
            var data = {
                id: fragment.id
            };

            api.deleteFragment(data).then(function ()
            {
                getUserFragments();
            });
        }

        /*
         |--------------------------------------------------------------------------------------------------------------
         | Fragments
         |--------------------------------------------------------------------------------------------------------------
         */

        function createFragment()
        {
            var data = {
                user_id: vm.user.id,
                video_id: vm.video.id,
                start_from: vm.fragment.start_from,
                end_from: vm.fragment.end_from,
                title: vm.fragment.title,
                description: vm.fragment.description
            };

            api.createFragment(data).then(function (data)
            {
                vm.fragment = data;
                vm.fragment.isCreating = true;

                downloadVideo();
            });
        }

        function uploadFragment()
        {
            var data = {
                id: vm.fragment.id
            };

            api.uploadFragment(data).then(function ()
            {

            });

            var status = $interval(function ()
            {
                if (vm.fragment.status == 'uploaded')
                {
                    getFragmentUrl();

                    vm.fragment.isCreating = false;
                    vm.fragment.isCreated = true;

                    $interval.cancel(status);
                }

                getFragmentStatus();
            }, 5000);
        }

        function getFragmentStatus()
        {
            var data = {
                id: vm.fragment.id
            };

            api.getFragmentStatus(data).then(function (data)
            {
                vm.fragment.status = data.status;
            });
        }

        function getFragmentUrl()
        {
            var data = {
                id: vm.fragment.id
            };

            api.getFragmentUrl(data).then(function (data)
            {
                vm.fragment.url = data.url;
            });
        }

        /*
         |--------------------------------------------------------------------------------------------------------------
         | Other
         |--------------------------------------------------------------------------------------------------------------
         */
        function reloadPage()
        {
            location.reload();
        }
    }
})();
