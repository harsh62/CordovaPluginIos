var app = {
    // Application Constructor
    initialize: function() {
        document.addEventListener('deviceready', this.onDeviceReady, false);
    },

    onDeviceReady: function() {
        console.log('onDeviceReady');
        SMClient.getLastLoginInfo(loadLoginInfo);
    }
};

app.initialize();

function loadLoginInfo(info) {
    if (info.username != null) {
        document.getElementById('username').value = info.username;
    }
    if (info.serverURL != null) {
        var server = info.serverURL.substring(info.serverURL.indexOf("//") + 2);
        document.getElementById('server').value = server;
        document.getElementById('useSsl').checked = info.serverURL.indexOf("https") == 0 ? true : false;
    }

};
function onLoginFail(response)
{
    if (response.requires2factor) {
        challenge(true);
    } else {
        alert("Login failed: " + response.message);
        challenge(false);
    }
};
function onLoginSuccess()
{
    SMAppManager.getAllApps(onAppManagerSuccess);
};
function onAppManagerSuccess(response)
{
    if (response.apps.length == 1) {
        SMClient.startApp(response.apps[0].appkey);
    } else{
        SMClient.startApp(""); // clear the start page  for iPad
        SMClient.showPortal();
    }
}
function doLogin()
{
    var username = document.getElementById('username').value
    var password = document.getElementById('password').value
    var server = document.getElementById('server').value
    var passcode = document.getElementById('passcode').value
    var useSSl = document.getElementById('useSsl').checked
    var serverURL;
    if (useSSl) {
        serverURL="https://"+server;
    } else {
        serverURL="http://"+server;
    }
//    setVisibility('mainContent', 'none');
//    setVisibility('loadingScreen', 'block');
    SMClient.login({username:username,password:password, passcode:passcode, serverURL:serverURL}, onLoginSuccess, onLoginFail);
};

function challenge(showCode) {
    if (showCode) {
        setVisibility('username', 'none');
        setVisibility('password', 'none');
        setVisibility('server', 'none');
        setVisibility('passcode', 'block');
    } else {
        document.getElementById('passcode').value =""
        setVisibility('username', 'block');
        setVisibility('password', 'block');
        setVisibility('server', 'block');
        setVisibility('passcode', 'none');
    }
};
function setVisibility(id, visibility) {
    document.getElementById(id).style.display = visibility;
};