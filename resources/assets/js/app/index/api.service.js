(function ()
{
    'use strict';

    angular.module('app.index')
           .factory('api', api);

    api.$inject = ['$http'];

    function api($http)
    {
        return {
            "userProfile": userProfile,
            "createVideo": createVideo,
            "downloadVideo": downloadVideo,
            "uploadVideo": uploadVideo,
            "getVideoEmbedUrl": getVideoEmbedUrl,
            "getVideoStatus": getVideoStatus,
            "createFragment": createFragment,
            "deleteFragment": deleteFragment,
            "uploadFragment": uploadFragment,
            "getFragmentUrl": getFragmentUrl,
            "getFragmentStatus": getFragmentStatus,
        };

        /*
         |--------------------------------------------------------------------------------------------------------------
         | Users
         |--------------------------------------------------------------------------------------------------------------
         */

        function userProfile(data)
        {
            return $http.post('/api/users/profile', data).then(function (response)
            {
                return response.data;
            });
        }

        /*
         |--------------------------------------------------------------------------------------------------------------
         | Videos
         |--------------------------------------------------------------------------------------------------------------
         */

        function createVideo(data)
        {
            return $http.post('/api/videos', data).then(function (response)
            {
                return response.data;
            });
        }

        function downloadVideo(data)
        {
            return $http.get('/api/videos/' + data.id + '/download').then(function (response)
            {
                return response.data;
            });
        }

        function uploadVideo(data)
        {
            return $http.get('/api/videos/' + data.id + '/upload').then(function (response)
            {
                return response.data;
            });
        }

        function getVideoEmbedUrl(data)
        {
            return $http.post('/api/videos/' + data.id + '/embed_url', data).then(function (response)
            {
                return response.data;
            });
        }

        function getVideoStatus(data)
        {
            return $http.get('/api/videos/' + data.id + '/status').then(function (response)
            {
                return response.data;
            });
        }

        /*
         |--------------------------------------------------------------------------------------------------------------
         | Fragments
         |--------------------------------------------------------------------------------------------------------------
         */

        function createFragment(data)
        {
            return $http.post('/api/fragments', data).then(function (response)
            {
                return response.data;
            });
        }

        function deleteFragment(data)
        {
            return $http.delete('/api/fragments/' + data.id).then(function (response)
            {
                return response.data;
            });
        }

        function uploadFragment(data)
        {
            return $http.get('/api/fragments/' + data.id + '/upload').then(function (response)
            {
                return response.data;
            });
        }

        function getFragmentUrl(data)
        {
            return $http.get('/api/fragments/' + data.id + '/url').then(function (response)
            {
                return response.data;
            });
        }

        function getFragmentStatus(data)
        {
            return $http.get('/api/fragments/' + data.id + '/status').then(function (response)
            {
                return response.data;
            });
        }
    }
})();
