all: build docs

clean:
	swift package clean; \
	rm -rf docs; \
	rm -rf Validator.xcodeproj;

build:
	swift build;

# Courtesy of
# https://github.com/realm/jazzy/issues/487
docs: build
	sourcekitten doc --spm-module Validator > validator.json; \
	sourcekitten doc --spm-module Scenarios > scenarios.json; \
	sourcekitten doc --spm-module RequestEngine > requestengine.json; \
	sourcekitten doc --spm-module Infrastructure > infrastructure.json; \
	jq -s '.[0] + .[1] + .[2] + .[3]' validator.json scenarios.json requestengine.json infrastructure.json > jazzy.json; \
	jazzy; \
	rm *.json;

run: build
	.build/debug/Validator http://localhost

xcode:
	swift package generate-xcodeproj

