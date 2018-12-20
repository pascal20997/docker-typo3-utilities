#/bin/bash

# start openssh-server
if [ "${START_SSH_SERVER}" = "true" ]; then
    service ssh start
fi

# run web based stuff as user typo3
su typo3

# check if document root exists
PROJECT_ROOT="$(echo "${DOCUMENT_ROOT}" | rev | cut -d'/' -f2- | rev)"
if [ ! -d "${PROJECT_ROOT}" ]; then
    echo "Create project root..."
    if ! mkdir -p "${PROJECT_ROOT}"
    then
        echo "Could not create project root ${PROJECT_ROOT}!"
        exit 1
    fi
fi

# install TYPO3 if INSTALL_TYPO3 = true
if [ "${INSTALL_TYPO3}" = "true" ]; then
    echo "Check if composer.json exists..."
    if [ -f "${DOCUMENT_ROOT}/../composer.json" ]; then
        echo "The file composer.json exists! Skip TYPO3 installation..."
    else
        echo "The file composer.json does not exists! Install TYPO3 ${TYPO3_VERSION}..."
        echo "Run create-project..."
        if ! composer ${COMPOSER_ADDITIONAL_ARGUMENTS} create-project typo3/cms-base-distribution ${PROJECT_ROOT} ${TYPO3_VERSION}
        then
            echo "Something went wrong while installing TYPO3 :( Please check the composer output above!"
            exit 1
        fi
    fi
else
    echo "Installation of TYPO3 will be skipped because INSTALL_TYPO3 does not equal true..."
fi

tail -f /var/log/cronjob