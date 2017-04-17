(function ()
{
    'use strict';

    angular.module('app.index')
           .factory('api', api);

    api.$inject = ['$http'];

    function api($http)
    {
        return {
            "getVideoInfo": getVideoInfo,
            "getVideoEmbedUrl": getVideoEmbedUrl,
            "downloadVideo": downloadVideo,
            "uploadVideo": uploadVideo,

            // "uploadVideoOnYouTube": uploadVideoOnYouTube,

            "statusJob": statusJob,
            "statusFragment": statusFragment,
            "globalStatusFragment": globalStatusFragment,
            "CloudChecker": CloudChecker,

            // "cloudinary": cloudinary,
            "getUser": getUser,
            "getFragment": getFragment,
            "createFragment": createFragment
        };

        function getVideoInfo(data)
        {
            return $http.post('/api/video/info', data).then(function (response)
            {
                return response.data;
            });
        }

        function statusJob(data)
        {
            return $http.post('/api/status_job', data).then(function (response)
            {
                return response.data;
            });
        }

        function statusFragment()
        {
            return $http.post('/api/fragments/status').then(function (response)
            {
                return response.data;
            });
        }

        function globalStatusFragment()
        {
            return $http.post('/api/fragments/global/status').then(function (response)
            {
                return response.data;
            });
        }

        function CloudChecker(data)
        {
            return $http.post('/api/fragments/cloud_checker', data).then(function (response)
            {
                return response.data;
            });
        }


        function getVideoEmbedUrl(data)
        {
            return $http.post('/api/video/embed_url', data).then(function (response)
            {
                return response.data;
            });
        }

        function downloadVideo(data)
        {
            return $http.post('/api/video/download', data).then(function (response)
            {
                return response.data;
            });
        }

        function uploadVideo()
        {
            return $http.post('/api/fragments/uploaded_on_cloudinary').then(function (response)
            {
                return response.data;
            });
        }

        // function uploadVideoOnYouTube(data)
        // {
        //     return $http.post('/api/fragments/uploaded_on_youtube', data).then(function (response)
        //     {
        //         return response.data;
        //     });
        // }

        // function cloudinary(data)
        // {
        //     return $http.post('/api/uploaded_on_cloudinary', data).then(function (response)
        //     {
        //         return response.data;
        //     });
        // }

        function getUser()
        {
            return $http.get('/api/users/me').then(function (response)
            {
                return response.data;
            });
        }

        function createFragment(data)
        {
            return $http.post('/api/fragments', data).then(function (response)
            {
                return response.data;
            });
        }

        function getFragment()
        {
            return $http.get('/api/fragments').then(function (response)
            {
                return response.data;
            });
        }
    }
})();
