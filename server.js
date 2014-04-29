var app = require('express')()
var Dat = require('dat')
var issues = require('./github-issues')

var dat = new Dat('.', function(err) {
  app.route('/battery/:state/:level')
    .all(function(req, res, next) {
      var hash = req.params
      hash.ip = req.connection.remoteAddress
      hash.time = new Date
      console.log(hash)
      dat.put(hash, {primary: 'ip'}, function(err) {
        res.send('.')
      })

      if(process.env.GH_TOKEN != undefined) {
        notifyGithubIssues(hash)
      }
    })
})

function notifyGithubIssues(hash) {
  // states: {0: unknown, 1: not charging, 2: charging, 3: charged}
  var threshold = 95
  if(hash.level <= threshold) {
    issues.commentWithBatteryStatus(hash.ip, {state: hash.state, level: hash.level})
  } else {
    issues.commentWithBatteryStatus(hash.ip, {state: hash.state, level: hash.level}, false, function(err, issue, comment) {
      issues.close(issue.number)
    })
  }
}

app.listen(2345)
