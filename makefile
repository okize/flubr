default:

	@echo "use either 'make pass' or 'make fail' to send message to campfire"

debug:

	node-debug target/app.js

pass:

	curl -i -u $(CF_TEST_KEY):X -H 'Content-Type: application/json' -d '{"message":{"body":"Build PASSED"}}' https://$(CF_TEST_SUBDOMAIN).campfirenow.com/room/$(CF_TEST_ROOM)/speak.json

fail:

	curl -i -u $(CF_TEST_KEY):X -H 'Content-Type: application/json' -d '{"message":{"body":"Build FAILED"}}' https://$(CF_TEST_SUBDOMAIN).campfirenow.com/room/$(CF_TEST_ROOM)/speak.json