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
            return $http.post('/api/video/upload', data).then(function (response)
            {
                return response.data;
            });
        }

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
