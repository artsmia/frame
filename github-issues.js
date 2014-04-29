var GitHubApi = require("github");
var github = new GitHubApi({
  version: "3.0.0",
  debug: false
})
github.authenticate({
  type: "oauth",
  token: process.env.GH_TOKEN
});

function baseMsg() {
  return {
    user: process.env.GH_REPO.split('/')[0],
    repo: process.env.GH_REPO.split('/')[1],
    state: 'open'
  }
}

function issueByTitle(title, create, callback) {
  github.issues.repoIssues(baseMsg(), function(err, data) {
    var matches = data.filter(function(issue) { return issue.title == title })

    if(callback == undefined) return console.log(matches)
    if(matches.length > 0) {
      callback(null, matches[0])
    } else {
      var msg = baseMsg()
      msg.title = title
      msg.labels = []
      create && github.issues.create(msg, function(err, data) {
        callback(null, data)
      })
    }
  })
}

function commentWithBatteryStatus(title, battery, createIssue, callback) {
  var createIssue = typeof(createIssue) == 'boolean' ? createIssue : true
  issueByTitle(title, createIssue, function(err, issue) {
    if(baseMsg().state == 'all' && issue.state == 'closed') { editState(issue.number, 'open') }

    commentMsg = baseMsg()
    commentMsg.number = issue.number
    commentMsg.body = "`" + JSON.stringify(battery) + "`"
    github.issues.createComment(commentMsg, function(err, data) {
      callback && callback(err, issue, data)
    })
  })
}

function close(number) {
  editState(number, 'closed')
}

function editState(number, state) {
  var msg = baseMsg()
  msg.number = number
  msg.state = state
  github.issues.edit(msg, function(err, data) {})
}

module.exports = {
  github: github,
  commentWithBatteryStatus: commentWithBatteryStatus,
  close: close
}
