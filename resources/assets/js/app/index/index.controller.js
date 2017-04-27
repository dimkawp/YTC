(function ()
{
    'use strict';

    angular.module('app.index')
           .controller('IndexController', IndexController);

    IndexController.$inject = ['$log', '$auth', '$sce', '$interval', 'api'];

    function IndexController($log, $auth, $sce, $interval, api)
    {
        var vm = this;

        vm.video = [];
        vm.user = $auth.user;
        vm.fragment = [];
        // vm.cloud_video_params = [];
        // vm.cloud_video = [];

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
        // vm.resources = resources;

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

            vm.video.isPreviewing = true;

            api.getVideoInfo(data).then(function (data)
            {
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

            vm.video.isPreviewing = true;

            api.getVideoEmbedUrl(data).then(function (data)
            {
                vm.fragment.embed_url = $sce.trustAsResourceUrl(data.embed_url);
            });
        }

        function downloadVideo()
        {
            $log.debug('ACTION - download from youtube');

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
            $log.debug('ACTION - upload on cloudnary');

            api.uploadVideo(vm.fragment.id).then(function (data)
            {
                vm.fragment.status = data.status;
            });

            var status = $interval(function ()
            {
                if (vm.fragment.status == 'upload_on_cloud' || vm.fragment.status == 'video_on_cloud')
                {
                    uploadVideoOnYouTube();

                    vm.fragment.cloudCreated = true;

                    $interval.cancel(status);
                }

                getFragmentStatus();
            }, 5000);
        }

        function uploadVideoOnYouTube()
        {
            $log.debug('ACTION - upload on youtube');

            api.uploadVideoOnYouTube(vm.fragment.id).then(function ()
            {
                deleteVideoFile();
            });

            var status = $interval(function ()
            {
                if (vm.fragment.status == 'uploaded_on_yt')
                {
                    getNewUrl();

                    vm.fragment.ytCreated = true;
                    vm.fragment.isCreated = false;

                    $interval.cancel(status);
                }

                getFragmentStatus();
            }, 5000);
        }

        function deleteVideoFile()
        {
            $log.debug('ACTION - delete file');

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
                vm.fragment.isCreated = true;

                downloadVideo();
            });
        }

        function getFragmentStatus()
        {
            api.getFragmentStatus(vm.fragment.id).then(function (data)
            {
                $log.debug('STATUS - ' + data.status);

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

        // function resources()
        // {
        //     var data = {
        //         user_id: vm.user.id
        //     };
        //
        //     api.resources(data).then(function (data)
        //     {
        //         vm.cloud_video_params = data.params;
        //     });
        // }
    }
})();
