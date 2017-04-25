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
            // "getFragment": getFragment,
            "createFragment": createFragment,
            "getFragmentStatus": getFragmentStatus,
            "getNewUrl": getNewUrl,

            // "resources": resources,
        };

        function getVideoInfo(data)
        {
            return $http.post('/api/video/info', data).then(function (response)
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

        function downloadVideo(id)
        {
            return $http.get('/api/fragments/' + id + '/download').then(function (response)
            {
                return response.data;
            });
        }

        function uploadVideo(id)
        {
            return $http.get('/api/fragments/' + id + '/uploaded_on_cloudinary').then(function (response)
            {
                return response.data;
            });
        }

        function deleteVideoFile(id)
        {
            return $http.get('/api/fragments/' + id + '/delete_video_file').then(function (response)
            {
                return response.data;
            });
        }

        function uploadVideoOnYouTube(id)
        {
            return $http.get('/api/fragments/' + id + '/upload_video_on_youtube').then(function (response)
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

        function getFragmentStatus(id)
        {
            return $http.get('/api/fragments/' + id + '/status').then(function (response)
            {
                return response.data;
            });
        }

        // function getFragment()
        // {
        //     return $http.get('/api/fragments').then(function (response)
        //     {
        //         return response.data;
        //     });
        // }

        function getNewUrl(data)
        {
            return $http.post('/api/new_url', data).then(function (response)
            {
                return response.data;
            });
        }

        // function resources(data)
        // {
        //     return $http.post('/api/fragments/resources', data).then(function (response)
        //     {
        //         return response.data;
        //     });
        // }
    }
})();
