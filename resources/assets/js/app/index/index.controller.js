(function ()
{
    'use strict';

    angular.module('app.index')
           .controller('IndexController', IndexController);

    IndexController.$inject = ['$auth', '$sce', '$interval', '$timeout', 'api'];

    function IndexController($auth, $sce, $interval, $timeout, api)
    {
        var vm = this;

        vm.error           = '';
        vm.user            = $auth.user;
        vm.video           = [];
        vm.fragment        = [];
        vm.active_fragment = [];
        vm.results         = [];

        vm.login               = login;
        vm.logout              = logout;
        vm.getUserFragments    = getUserFragments;
        vm.createVideo         = createVideo;
        vm.downloadVideo       = downloadVideo;
        vm.uploadVideo         = uploadVideo;
        vm.getVideoStatus      = getVideoStatus;
        vm.getVideoError       = getVideoError;
        vm.getVideoEmbedUrl    = getVideoEmbedUrl;
        vm.newFragment         = newFragment;
        vm.setActiveFragment   = setActiveFragment;
        vm.createFragment      = createFragment;
        // vm.previewFragment     = previewFragment;
        vm.deleteFragment      = deleteFragment;
        vm.uploadFragment      = uploadFragment;
        vm.getFragmentStatus   = getFragmentStatus;
        vm.getFragmentError    = getFragmentError;
        vm.getFragmentUrl      = getFragmentUrl;
        vm.getFragmentEmbedUrl = getFragmentEmbedUrl;

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
                vm.video.isCreated = true;

                vm.fragment.start_from  = 0;
                vm.fragment.end_from    = vm.video.duration;
                vm.fragment.title       = vm.video.title;
                vm.fragment.description = vm.video.description;

                getVideoEmbedUrl();
            });
        }

        function setActiveFragment(fragment)
        {
            vm.active_fragment = fragment;

            var data = {
                id: vm.active_fragment.id
            };

            api.getFragmentEmbedUrl(data).then(function (data)
            {
                vm.active_fragment.embed_url = $sce.trustAsResourceUrl(data.embed_url);
            });
        }

        function deleteFragment()
        {
            var data = {
                id: vm.active_fragment.id
            };

            api.deleteFragment(data).then(function ()
            {
                getUserFragments();
            });
        }

        function downloadVideo()
        {
            var data = {
                id: vm.video.id
            };

            api.downloadVideo(data).then(function (data)
            {
                vm.video.job_id = data.job_id;

                var status = $interval(function ()
                {
                    if (vm.video.status == 'error')
                    {
                        getVideoError();
                        newFragment();

                        $interval.cancel(status);
                    }

                    if (vm.video.status == 'downloaded')
                    {
                        uploadVideo();

                        $interval.cancel(status);
                    }

                    if (vm.video.status == 'uploaded')
                    {
                        uploadFragment();

                        $interval.cancel(status);
                    }

                    getVideoStatus();
                }, 5000);
            });
        }

        function uploadVideo()
        {
            var data = {
                id: vm.video.id
            };

            api.uploadVideo(data).then(function (data)
            {
                vm.video.job_id = data.job_id;

                var status = $interval(function ()
                {
                    if (vm.video.status == 'error')
                    {
                        getVideoError();
                        newFragment();

                        $interval.cancel(status);
                    }

                    if (vm.video.status == 'uploaded')
                    {
                        uploadFragment();

                        $interval.cancel(status);
                    }

                    getVideoStatus();
                }, 5000);
            });
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
                id: vm.video.id,
                job_id: vm.video.job_id
            };

            api.getVideoStatus(data).then(function (data)
            {
                vm.video.status = data.status;
            });
        }

        function getVideoError()
        {
            var data = {
                id: vm.video.id
            };

            api.getVideoError(data).then(function (data)
            {
                vm.error = data.error;
            });
        }

        /*
         |--------------------------------------------------------------------------------------------------------------
         | Fragments
         |--------------------------------------------------------------------------------------------------------------
         */

        function newFragment()
        {
            vm.error    = '';
            vm.video    = [];
            vm.fragment = [];
        }

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

            api.uploadFragment(data).then(function (data)
            {
                vm.fragment.job_id = data.job_id;

                var status = $interval(function ()
                {
                    if (vm.fragment.status == 'error')
                    {
                        getFragmentError();
                        newFragment();

                        $interval.cancel(status);
                    }

                    if (vm.fragment.status == 'uploaded')
                    {
                        getFragmentUrl();

                        $timeout(function ()
                        {
                            vm.video.isCreated = false;
                            vm.fragment.isCreating = false;
                            vm.fragment.isCreated = true;
                        }, 5000);

                        $interval.cancel(status);
                    }

                    getFragmentStatus();
                }, 5000);
            });
        }

        function getFragmentStatus()
        {
            var data = {
                id: vm.fragment.id,
                job_id: vm.fragment.job_id
            };

            api.getFragmentStatus(data).then(function (data)
            {
                vm.fragment.status = data.status;
            });
        }

        function getFragmentError()
        {
            var data = {
                id: vm.fragment.id
            };

            api.getFragmentError(data).then(function (data)
            {
                vm.error = data.error;
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

                getFragmentEmbedUrl();
            });
        }

        function getFragmentEmbedUrl()
        {
            var data = {
                id: vm.fragment.id
            };

            api.getFragmentEmbedUrl(data).then(function (data)
            {
                vm.fragment.embed_url = $sce.trustAsResourceUrl(data.embed_url);
            });
        }
    }
})();
