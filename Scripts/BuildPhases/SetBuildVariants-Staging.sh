#!/bin/bash
set -ex

API_HOST=${API_HOST}
STAGING_API_HOST_ENV_PATH="${SRCROOT}/staging-api-host.env"
if [ -f "${STAGING_API_HOST_ENV_PATH}" ]; then
  API_HOST_ENV=`cat ${STAGING_API_HOST_ENV_PATH}`
  if [ -n "$API_HOST_ENV" ]; then
    API_HOST="$API_HOST_ENV"
  fi
else
cat << EOT > "${STAGING_API_HOST_ENV_PATH}"
${API_HOST}
EOT
fi

BUNDLE_IDENTIFIER=com.folio-sec.folio-app-qa
BUILD_VARIANTS_PROJECT=_BuildVariants-Project.xcconfig
BUILD_VARIANTS_APP=_BuildVariants-Folio.xcconfig

cat << EOT > "${SRCROOT}/Configurations/${BUILD_VARIANTS_PROJECT}"
CONTAINING_APP_BUNDLE_IDENTIFIER = ${BUNDLE_IDENTIFIER}
GOOGLESERVICE_INFO_PLIST_DIR = ${PROJECT_DIR}/${TARGET_NAME}/FirebaseOptions/Debug

API_HOST = ${API_HOST}
WEB_HOST = ${WEB_HOST}
EOT

cat << 'EOT' >> "${SRCROOT}/Configurations/${BUILD_VARIANTS_PROJECT}"
API_BASE_PATH = https:$()/$()/$(API_HOST)
WEB_BASE_PATH = https:$()/$()/$(WEB_HOST)
EOT

cat << EOT > "${SRCROOT}/Configurations/${BUILD_VARIANTS_APP}"
PRODUCT_BUNDLE_IDENTIFIER = ${BUNDLE_IDENTIFIER}
ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon-staging
EOT
