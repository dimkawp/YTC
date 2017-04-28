(function ()
{
    'use strict';

    angular.module('app.index')
           .controller('IndexController', IndexController);

    IndexController.$inject = ['$auth', '$sce', '$interval', 'api'];

    function IndexController($auth, $sce, $interval, api)
    {
        var vm = this;

        vm.video = [];
        vm.user = $auth.user;
        vm.fragment = [];

        vm.login = login;
        vm.logout = logout;
        vm.getVideoInfo = getVideoInfo;
        vm.getVideoEmbedUrl = getVideoEmbedUrl;
        vm.downloadVideo = downloadVideo;
        vm.uploadVideo = uploadVideo;
        vm.deleteVideoFile = deleteVideoFile;
        vm.uploadVideoOnYouTube = uploadVideoOnYouTube;
        vm.getNewUrl = getNewUrl;
        vm.createFragment = createFragment;
        vm.getFragmentStatus = getFragmentStatus;

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
         | Video
         |--------------------------------------------------------------------------------------------------------------
         */

        function getVideoInfo()
        {
            var data = {
                url: vm.fragment.url
            };

            vm.video.preview = true;

            api.getVideoInfo(data).then(function (data)
            {
                vm.video.end = data.end;

                vm.fragment.video_id = data.video_id;
                vm.fragment.start = 1;
                vm.fragment.end = data.end;
                vm.fragment.title = data.title;
                vm.fragment.description = data.description;
            });
        }

        function getVideoEmbedUrl()
        {
            var data = {
                url: vm.fragment.url,
                start: vm.fragment.start,
                end: vm.fragment.end
            };

            vm.video.preview = true;

            api.getVideoEmbedUrl(data).then(function (data)
            {
                vm.fragment.embed_url = $sce.trustAsResourceUrl(data.embed_url);
            });
        }

        function downloadVideo()
        {
            api.downloadVideo(vm.fragment.id).then(function (data)
            {
                vm.fragment.status = data.status;
            });

            var status = $interval(function ()
            {
                if (vm.fragment.status == 'downloaded')
                {
                    uploadVideo();
                }

                if (vm.fragment.status == 'video_on_cloud')
                {
                    uploadVideoOnYouTube();
                }

                if (vm.fragment.status == 'downloaded' || vm.fragment.status == 'video_on_cloud')
                {
                    $interval.cancel(status);
                }

                getFragmentStatus();
            }, 5000);
        }

        function uploadVideo()
        {
            api.uploadVideo(vm.fragment.id).then(function (data)
            {
                vm.fragment.status = data.status;
            });

            var status = $interval(function ()
            {
                if (vm.fragment.status == 'upload_on_cloud' || vm.fragment.status == 'video_on_cloud')
                {
                    uploadVideoOnYouTube();

                    $interval.cancel(status);
                }

                getFragmentStatus();
            }, 5000);
        }

        function uploadVideoOnYouTube()
        {
            api.uploadVideoOnYouTube(vm.fragment.id).then(function ()
            {
                deleteVideoFile();
            });

            var status = $interval(function ()
            {
                if (vm.fragment.status == 'uploaded_on_yt')
                {
                    getNewUrl();

                    vm.fragment.isCreating = false;
                    vm.fragment.isCreated = true;

                    $interval.cancel(status);
                }

                getFragmentStatus();
            }, 5000);
        }

        function deleteVideoFile()
        {
            api.deleteVideoFile(vm.fragment.id).then(function ()
            {
                //
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
                url: vm.fragment.url,
                start: vm.fragment.start,
                end: vm.fragment.end,
                title: vm.fragment.title,
                description: vm.fragment.description,
                video_id: vm.fragment.video_id
            };

            api.createFragment(data).then(function (data)
            {
                vm.fragment = data;
                vm.fragment.isCreating = true;

                downloadVideo();
            });
        }

        function getFragmentStatus()
        {
            api.getFragmentStatus(vm.fragment.id).then(function (data)
            {
                vm.fragment.status = data.status;
            });
        }

        function getNewUrl()
        {
            var data = {
                id: vm.fragment.id
            };

            api.getNewUrl(data).then(function (data)
            {
                vm.new_url = data.url;
            });
        }
    }
})();
