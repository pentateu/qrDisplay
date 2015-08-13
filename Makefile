AUTH_HOST=https://accounts.$(ENV).com
ENV_API_HOST=https://env-api.$(ENV).com
OAUTH_TOKEN_PATH=$(HOME)/.appgyver/$(ENV).token.json
MODULE_API_HOST=https://modules-api.$(ENV).com
DEPLOYMENT_JSON_PATH=config/deployment.$(ENV).json

all: clean install testgyver login init connect

clean:
	rm -rf node_modules
	rm -rf bower_components
	rm -rf mobile/node_modules
	rm -rf mobile/bower_components

install:
	npm install
	bower install
	(cd mobile && npm install)
	(cd mobile && bower install)

connect:
	(cd mobile && \
		steroids connect \
			--watch=../src \
			--no-qrcode \
			--livereload \
			--simulate)

devgyver:
	$(eval ENV=devgyver)
	ENV=devgyver

testgyver:
	$(eval ENV=testgyver)
	ENV=testgyver

appgyver:
	$(eval ENV=appgyver)
	ENV=appgyver

env-required:
	$(warning ENV required. Use one of appgyver, testgyver, devgyver before this target.)

init: testgyver
	steroids module init \
	  --app-id=14280 \
	  --api-key=636ab743e5cc6900463704fc91e62cee6fd6225b406d99d317f2f1200fa3244e \
	  --auth-token=327df32db355bc03d0a5f77c0aafba9e \
	  --user-id=27952 \
	  --envApiHost=$(ENV_API_HOST) \
	  --oauthTokenPath=$(OAUTH_TOKEN_PATH)

refresh: testgyver
	steroids module refresh \
		--envApiHost=$(ENV_API_HOST) \
		--oauthTokenPath=$(OAUTH_TOKEN_PATH)

login: testgyver
	steroids logout \
		--oauthTokenPath=$(OAUTH_TOKEN_PATH)
	steroids login \
		--authURL=$(AUTH_HOST) \
		--oauthTokenPath=$(OAUTH_TOKEN_PATH)

deploy: testgyver
	steroids module deploy \
	  --moduleApiHost=$(MODULE_API_HOST) \
	  --deploymentJsonPath=$(DEPLOYMENT_JSON_PATH) \
	  --oauthTokenPath=$(OAUTH_TOKEN_PATH)
