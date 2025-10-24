SHELL := /bin/bash
.PHONY: ci-tests

PROJECT_BUILD_NUMBER=51

gen-code:
	fvm dart run build_runner build --delete-conflicting-outputs
	make format-files

ci-tests:
	fvm dart format --set-exit-if-changed . -l 120
	fvm dart analyze
	fvm flutter test -r expanded --coverage
	sh filter_lcov.sh
	fvm dart run covadge ./coverage/lcov.info ./

format-files:
	fvm dart format . -l 120

filter-lcov:
	/bin/zsh ./filter_lcov.sh
	fvm dart run covadge ./coverage/lcov.info ./

show-test-coverage:
	genhtml coverage/lcov.info -o coverage/html
	open coverage/html/index.html

cache-repair:
	fvm flutter pub cache repair
	make clean

pub-get:
	fvm flutter pub get

clean:
	fvm flutter clean
	fvm flutter pub get

adb-restart:
	adb kill-server
	adb start-server

build-ipa-stg:
	fvm flutter build ipa --release --flavor stg -t lib/main_stg.dart --build-number=${PROJECT_BUILD_NUMBER} --export-options-plist=./ios/export_options_stg.plist --no-tree-shake-icons

build-apk-stg:
	fvm flutter build apk --release --flavor stg -t lib/main_stg.dart --build-number=${PROJECT_BUILD_NUMBER} --no-tree-shake-icons

build-ipa-prod:
	fvm flutter build ipa --release --flavor prod -t lib/main_prod.dart --build-number=${PROJECT_BUILD_NUMBER} --export-options-plist=./ios/export_options_prod.pliss --no-tree-shake-icons

build-aab-prod:
	fvm flutter build aab --release --flavor prod -t lib/main_prod.dart --build-number=${PROJECT_BUILD_NUMBER} --no-tree-shake-icons

########################################
########## LESS USED COMMANDS ##########
########################################

# Generate flavorizr native configurations.
# This will override app.dart, flavors.dart and all main_X.dart.
# Only run if you know what you are doing.
# After running, the cited files need to be reset to their previous state.
gen-flavors:
	fvm dart run flutter_flavorizr

# Generate launcher icons
gen-launcher-icons:
	fvm dart run flutter_launcher_icons

# Generate native splash screens for each flavor
gen-native-splash:
	fvm dart run flutter_native_splash:create --flavor stg
	fvm dart run flutter_native_splash:create --flavor prod

apply-lint:
	fvm dart fix --apply

ANDROID_APP_ID=com.app.mybackyardusa1
IOS_APP_ID=com.celect.mybackyardapp
FIREBASE_ID=my-backyard-usa

FIREBASE_OPTIONS_PATH=./lib/core/firebase_options/firebase_options

# Generate firebase configurations for each environment
gen-firebase-configs-stg:
	fvm dart pub global activate flutterfire_cli
	fvm exec flutterfire config -y -p ${FIREBASE_ID} -o ${FIREBASE_OPTIONS_PATH}_stg.dart -i ${IOS_APP_ID}.stg -a ${ANDROID_APP_ID}.stg
	mv ios/Runner/GoogleService-Info.plist .firebase/stg && mv android/app/google-services.json .firebase/stg

gen-firebase-configs-prod:
	fvm dart pub global activate flutterfire_cli
	fvm exec flutterfire config -y -p ${FIREBASE_ID} -o ${FIREBASE_OPTIONS_PATH}_prod.dart -i ${IOS_APP_ID} -a ${ANDROID_APP_ID}1
	mv ios/Runner/GoogleService-Info.plist .firebase/prod && mv android/app/google-services.json .firebase/prod
