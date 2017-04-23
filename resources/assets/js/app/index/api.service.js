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
            "deleteVideoFile": deleteVideoFile,
            "uploadVideoOnYouTube": uploadVideoOnYouTube,
            "statusJob": statusJob,
            "statusFragment": statusFragment,
            "globalStatusFragment": globalStatusFragment,
            "resources": resources,
            "getNewUrl": getNewUrl,
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

        function statusFragment(data)
        {
            return $http.post('/api/fragments/status', data).then(function (response)
            {
                return response.data;
            });
        }

        function globalStatusFragment(data)
        {
            return $http.post('/api/fragments/global/status', data).then(function (response)
            {
                return response.data;
            });
        }

        function resources(data)
        {
            return $http.post('/api/fragments/resources', data).then(function (response)
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

        function uploadVideo(data)
        {
            return $http.post('/api/fragments/uploaded_on_cloudinary', data).then(function (response)
            {
                return response.data;
            });
        }

        function deleteVideoFile(data)
        {
            return $http.post('/api/fragments/delete_video_file', data).then(function (response)
            {
                return response.data;
            });
        }

        function uploadVideoOnYouTube(data)
        {
            return $http.post('/api/fragments/uploaded_video_on_youtube', data).then(function (response)
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

        function getNewUrl(data)
        {
            return $http.post('/api/new_url', data).then(function (response)
            {
                return response.data;
            });
        }
    }
})();
