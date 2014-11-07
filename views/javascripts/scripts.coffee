# add fastclick to remove click delay on touch devices
attachFastClick = require('fastclick')
attachFastClick(document.body)

# load homepage and main app scripts
homepage = require('./homepage')()
app = require('./application')()
