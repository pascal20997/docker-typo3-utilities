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
    if ! runuser -u typo3 mkdir -p "${PROJECT_ROOT}"
    then
        echo "Could not create project root ${PROJECT_ROOT}!"
        exit 1
    fi
fi

# start php-fpm
php-fpm