cordova.define('cordova/plugin_list', function(require, exports, module) {
module.exports = [
    {
        "file": "plugins/org.apache.cordova.console/www/console-via-logger.js",
        "id": "org.apache.cordova.console.console",
        "clobbers": [
            "console"
        ]
    },
    {
        "file": "plugins/org.apache.cordova.console/www/logger.js",
        "id": "org.apache.cordova.console.logger",
        "clobbers": [
            "cordova.logger"
        ]
    },
    {
        "file": "plugins/com.phonegap.plugins.CDVPluginSmartBeacon/www/PluginSmartBeacon.js",
        "id": "com.phonegap.plugins.CDVPluginSmartBeacon.PluginSmartBeacon",
        "clobbers": [
            "window.PluginSmartBeacon"
        ]
    }
];
module.exports.metadata = 
// TOP OF METADATA
{
    "org.apache.cordova.console": "0.2.7",
    "com.phonegap.plugins.CDVPluginSmartBeacon": "0.0.1"
}
// BOTTOM OF METADATA
});