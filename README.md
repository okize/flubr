# Flubr

Flubr is an app that collects and returns pass or fail images for chatrooms, curated by your team members.

## Installation

This app is configured to be deployed to Heroku. It should be possible to deploy Flubr anywhere you can host a NodeJS app, but the following instructions only cover Heroku deployment.

### Requirements

Before getting started you will need the following:

* A [Heroku](https://id.heroku.com/signup) account
* A running [Hubot](https://github.com/github/hubot) instance:
  * Flubr is meant to be paired with Hubot, which is accomplished with the [hubot-flubr](https://github.com/okize/hubot-flubr) plugin.
* [Twitter App](https://apps.twitter.com/app/new) keys:
  * ``Consumer Key (API Key)``
  * ``Consumer Secret (API Secret)``
  * ```Access Token```
  * ```Access Token Secret```
* [Imgur app](https://api.imgur.com/oauth2/addclient) key:
  * ```Client ID```

### Deploy to Heroku

After clicking the button below you will be asked to input your application keys:

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy?template=https://github.com/okize/flubr)

## Notes

Flubr was wholly inspired by [Blundercats](https://github.com/semanticart/blundercats)
