---
title: "5b. Bitrise에서 빌드한 앱을 슬랙 메시지 버튼으로 받기"
---

별거 아니지만 설정하는데 깨나 시간을 써서 아까워서 기록해놓는다.

```yml
    - script@1:
        inputs:
        - content: |-
            #!/usr/bin/env bash

            LIST=(${BITRISE_PUBLIC_INSTALL_PAGE_URL_MAP//|/ })
            INSTALL_PAGE_0=${LIST[0]//=>/|}
            INSTALL_PAGE_1=${LIST[1]//=>/|}
            INSTALL_PAGE_2=${LIST[2]//=>/|}
            INSTALL_PAGE_3=${LIST[3]//=>/|}

            envman add --key INSTALL_PAGE_BUTTON_0 --value "$INSTALL_PAGE_0"
            envman add --key INSTALL_PAGE_BUTTON_1 --value "$INSTALL_PAGE_1"
            envman add --key INSTALL_PAGE_BUTTON_2 --value "$INSTALL_PAGE_2"
            envman add --key INSTALL_PAGE_BUTTON_3 --value "$INSTALL_PAGE_3"
    - slack@3:
        inputs:
        - channel: "$SLACK_CHANNEL"
        - pretext: "*(staging)App Build Succeeded!* Build Number: $BITRISE_BUILD_NUMBER"
        - buttons: |-
            ${INSTALL_PAGE_BUTTON_0}
            ${INSTALL_PAGE_BUTTON_1}
            ${INSTALL_PAGE_BUTTON_2}
            ${INSTALL_PAGE_BUTTON_3}
            View Build|${BITRISE_BUILD_URL}
            View App|${BITRISE_APP_URL}
        - webhook_url_on_error: "$SLACK_API_TOKEN"
        - api_token: "$SLACK_API_TOKEN"
        is_always_run: false
    - slack@3:
        inputs:
        - channel: "$SLACK_CHANNEL"
        - pretext: "*(staging)App Build Failed!* Build Number: $BITRISE_BUILD_NUMBER"
        - color: "#a63636"
        - api_token: "$SLACK_API_TOKEN"
        is_always_run: true
        run_if: ".IsBuildFailed"
```