(function()
{
    'use strict';

    angular.module('app.index')
        .directive('appModal', appModal);

    function appModal()
    {
        return {
            restrict: 'A',
            link: link
        };

        function link(scope, element, attributes)
        {
            $(element).on('click', function()
            {
                var modal = $(attributes.modalId);

                modal.modal
                ({
                    onHide: function()
                    {
                        modal.find('iframe').attr('src', modal.find('iframe').attr('src'));
                    },
                    selector: {
                        close : '.close'
                    }
                }).modal('show');
            })
        }
    }
})();
