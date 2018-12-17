#/bin/bash

# Execute TYPO3 scheduler every 5 minutes via cronjob!
# Feel free to override this file :)

if [ -d "/usr/local/apache2/htdocs/typo3/sysext/core/bin/typo3" ]; then
    /usr/local/apache2/htdocs/typo3/sysext/core/bin/typo3 scheduler:run
fi

if [ -d "/usr/local/apache2/htdocs/web/typo3/sysext/core/bin/typo3" ]; then
    /usr/local/apache2/htdocs/web/typo3/sysext/core/bin/typo3 scheduler:run
fi

if [ -d "/usr/local/apache2/htdocs/public/typo3/sysext/core/bin/typo3" ]; then
    /usr/local/apache2/htdocs/public/typo3/sysext/core/bin/typo3 scheduler:run
fi
