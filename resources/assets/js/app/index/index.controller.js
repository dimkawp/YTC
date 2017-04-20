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
        vm.status_fragment = [];
        vm.global_status = [];

        vm.login = login;
        vm.logout = logout;
        vm.cloud_id = [];

        vm.interval_status_job = [];
        vm.interval_status_fragment = [];
        vm.interval_cloud_video = [];

        vm.cloud_video_params = [];
        vm.cloud_video = [];

        vm.upload_job_id = [];
        vm.download_job_id = [];
        vm.upload_yt_job_id = [];
        vm.status = [];

        vm.getVideoInfo = getVideoInfo;
        vm.getVideoEmbedUrl = getVideoEmbedUrl;
        vm.downloadVideo = downloadVideo;
        vm.uploadVideo = uploadVideo;
        vm.deleteVideoFile = deleteVideoFile;
        vm.uploadVideoOnYouTube = uploadVideoOnYouTube;
        vm.statusJob = statusJob;
        vm.statusFragment = statusFragment;
        vm.globalStatusFragment = globalStatusFragment;
        vm.resources = resources;

        vm.createFragment = createFragment;

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
                vm.fragment.embed_url = $sce.trustAsResourceUrl(data);
            });
        }

        function statusJob()
        {
            var data = {
                id: vm.fragment.id
            };

            api.statusJob(data).then(function (data)
            {
                vm.status = data;
            });
        }

        function statusFragment()
        {
            api.statusFragment().then(function (data)
            {
                vm.status_fragment = data;
            });
        }

        function globalStatusFragment()
        {
            api.globalStatusFragment().then(function (data)
            {
                vm.global_status = data;
            });
        }

        function downloadVideo()
        {
            var data = {
                id: vm.fragment.id
            };

            api.downloadVideo(data).then(function (data)
            {
                vm.download_job_id = data;

            });
        }

        function uploadVideo()
        {
            api.uploadVideo().then(function (data)
            {
                vm.upload_job_id = data;
            });
        }

        function deleteVideoFile()
        {
            api.deleteVideoFile().then(function (data)
            {

            });
        }

        function uploadVideoOnYouTube()
        {
            api.uploadVideoOnYouTube().then(function (data)
            {
                vm.upload_yt_job_id = data;
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
                vm.cloud_id = vm.fragment.video_id;

                downloadVideo();

                vm.status = "new";

                var status_job = $interval(function ()
                {
                    statusJob();

                    if (vm.status === 'complete')
                    {
                        $interval.cancel(status_job);
                    }
                }, 500);

                var uploader = $interval(function ()
                {
                    statusFragment();

                    if (vm.status_fragment === 'downloaded')
                    {
                        uploadVideo();

                        $interval.cancel(uploader);
                    }

                    if (vm.status_fragment === 'video_on_cloud')
                    {
                        $interval.cancel(uploader);

                        vm.fragment.isCreated = false;
                        vm.fragment.cloudCreated = true;
                    }

                }, 500);

                var cloud_video = $interval(function ()
                {
                    resources();

                    if (vm.cloud_video_params['public_id'] === vm.fragment.video_id)
                    {
                        deleteVideoFile();
                        uploadVideoOnYouTube();

                        $interval.cancel(cloud_video);

                        vm.fragment.isCreated = false;
                        vm.fragment.cloudCreated = true;
                    }
                }, 2500);
            });
        }

        function resources()
        {
            api.resources().then(function (data)
            {
                vm.cloud_video_params = data;
            });
        }
    }
})();
