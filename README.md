# Frame

For 'kiosk' devices.

This is a simple `UIWebView` wrapper app that loads a URL then does a few extra things. It

* Hides the iOS menu bar
* Prevents rubber-band scrolling in the web view
* Reloads the original page after 2 minutes with no interaction
* Reports battery life to a monitoring server

The monitoring server listens for pings from the app and logs them. So far only battery tracking is implemented. If github authentication is provided, it can open github issues when the charge drops below a threshold.  

`[GH_TOKEN=<oauth token> GH_REPO=<user/repository>  ] node[-supervisor] server.js`

## TODO

* Don't hardcode configuration: monitoring url, timeout interval
* Expand device tracking: attempts to disable Guided Access, app exit, ?
* Dim the screen during off hours
