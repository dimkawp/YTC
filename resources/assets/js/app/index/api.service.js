(function ()
{
    'use strict';

    angular.module('app.index')
           .factory('api', api);

    api.$inject = ['$http'];

    function api($http)
    {
        return {
            "postInfo": postInfo,
            "cloudinary": cloudinary,
            "download": download,
            "uploaded": uploaded,
            "getEmbedUrl": getEmbedUrl,
            "getUser": getUser,
            "getFragment": getFragment,
            "createFragment": createFragment
        };

        function postInfo(data)
        {
            return $http.post('/api/fragments/video/info', data).then(function (response)
            {
                return response.data;
            });
        }

        function cloudinary(data)
        {
            return $http.post('/api/uploaded_on_cloudinary', data).then(function (response)
            {
                return response.data;
            });
        }

        function download(data)
        {
            return $http.post('/api/fragments/download', data).then(function (response)
            {
                return response.data;
            });
        }

        function uploaded(data)
        {
            return $http.post('/api/fragments/uploaded_on_youtube', data).then(function (response)
            {
                return response.data;
            });
        }

        function getEmbedUrl(data)
        {
            return $http.post('/api/fragments/embed_url', data).then(function (response)
            {
                return response.data;
            });
        }

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
