var gulp = require('gulp'),
    elixir = require('laravel-elixir');

// Assets
elixir(function (mix) {
    // CSS
    mix.less([
        'styles.less'
    ], 'public/assets/css/app.min.css');

    // JS
    mix.scripts([
        'app/app.module.js',
        'app/index/index.module.js',
        'app/index/index.controller.js',
        'app/index/auth.config.js',
        'app/index/api.service.js',
        'app/index/app-tab.directive.js'
    ],  'public/assets/js/app.min.js');
});

// Packages
elixir(function (mix) {
    // Angular Token Auth
    mix.copy('node_modules/ng-token-auth/dist/ng-token-auth.min.js', 'public/packages/angular-token-auth/js/token-auth.min.js');

    // Angular Socialshare
    mix.copy('node_modules/angular-socialshare/dist/angular-socialshare.min.js', 'public/packages/angular-socialshare/js/socialshare.min.js');

    // Angular Clipboard
    mix.copy('node_modules/ngclipboard/dist/ngclipboard.min.js', 'public/packages/angular-clipboard/js/clipboard.min.js');

    // Angular Range
    mix.copy('node_modules/angular-rangeslider/angular.rangeSlider.css', 'public/packages/angular-rangeslider/css/rangeslider.css');
    mix.copy('node_modules/angular-rangeslider/angular.rangeSlider.js', 'public/packages/angular-rangeslider/js/rangeslider.js');
});
