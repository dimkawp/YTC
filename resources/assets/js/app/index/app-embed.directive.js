(function()
{
    'use strict';

    angular.module('app.index')
           .directive('appEmbed', appEmbed);

    function appEmbed()
    {
        return {
            restrict: 'A',
            link: link
        };

        function link(scope, element, attributes)
        {
            $(element).embed();
        }
    }
})();
