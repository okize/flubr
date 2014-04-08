default:

	@echo "use either 'make pass' or 'make fail'"

pass:

	curl -i -u $(CF_TEST_KEY):X -H 'Content-Type: application/json' -d '{"message":{"body":"Build PASSED"}}' https://plm.campfirenow.com/room/$(CF_TEST_ROOM)/speak.json

fail:

	curl -i -u $(CF_TEST_KEY):X -H 'Content-Type: application/json' -d '{"message":{"body":"Build FAILED"}}' https://plm.campfirenow.com/room/$(CF_TEST_ROOM)/speak.json