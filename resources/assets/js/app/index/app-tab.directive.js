(function()
{
    'use strict';

    angular.module('app.index')
           .directive('appTab', appTab);

    function appTab()
    {
        return {
            restrict: 'A',
            link: link
        };

        function link(scope, element, attributes)
        {
            $(element).tab();
        }
    }
})();
