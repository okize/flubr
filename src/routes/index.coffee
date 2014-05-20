path = require 'path'
express = require 'express'
images = require path.join('..', 'controllers', 'images')
router = express.Router()

router.get '/', (req, res) ->
  res.render 'index',
    title: 'Blundercats!'

require path.join('..', 'models', 'image')

# # 404s
# router.use (req, res, next) ->
#   err = new Error('Not Found')
#   err.status = 404
#   next(err)

router.post    '/images',     images.create
router.get     '/images',     images.retrieve
router.get     '/images/:type', images.retrieve
# router.put     '/images/:id', images.update
# router.delete  '/images/:id', images.delete

module.exports = router