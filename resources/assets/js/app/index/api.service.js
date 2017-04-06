(function ()
{
    'use strict';

    angular.module('app.index')
           .factory('api', api);

    api.$inject = ['$http'];

    function api($http)
    {
        return {
            "getEmbedUrl": getEmbedUrl,
            "getUser": getUser,
            "postFragmentCreate": postFragmentCreate,
            "postInfo": postInfo
        };

        function postInfo(data)
        {
            return $http.post('/api/fragments/info/358', data).then(function (response)
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

        function postFragmentCreate(data)  {
            return $http.post('/api/fragments/create', data).then(function (response)
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
    }
})();
