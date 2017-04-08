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
        };

        function getEmbedUrl(data)
        {
            return $http.post('/api/fragments/embed_url', data).then(function (response)
            {
                return response.data;
            });
        }
    }
})();
