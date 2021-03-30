{
    "_comment": "DO NOT EDIT: FILE GENERATED AUTOMATICALLY BY PTERODACTYL PANEL - PTERODACTYL.IO",
    "meta": {
        "version": "PTDL_v1",
        "update_url": null
    },
    "exported_at": "2021-03-30T05:41:15+03:00",
    "name": "discord.lua generic",
    "author": "parker@parkervcp.com",
    "description": "a generic discord js bot egg\r\n\r\nThis will clone a git repo for a bot. it defaults to master if no branch is specified.\r\n\r\nInstalls the node_modules on install. If you set user_upload then I assume you know what you are doing.",
    "features": null,
    "images": [
        "quay.io\/parkervcp\/pterodactyl-images:base_debian"
    ],
    "file_denylist": [],
    "startup": "if [[ -d .git ]] && [[ {{AUTO_UPDATE}} == \"1\" ]]; then git pull; fi; if [[ ! -z ${LUVIT_PACKAGES} ]]; then .\/lit install ${LUVIT_PACKAGES}; fi; .\/luvit {{BOT_LUA_FILE}}",
    "config": {
        "files": "{}",
        "startup": "{\r\n    \"done\": \"change this part\"\r\n}",
        "logs": "{}",
        "stop": "^c"
    },
    "scripts": {
        "installation": {
            "script": "#!\/bin\/bash\r\n# Lua Bot Installation Script\r\n#\r\n# Server Files: \/mnt\/server\r\napt update\r\napt install -y git curl jq file unzip\r\n\r\nmkdir -p \/mnt\/server\r\ncd \/mnt\/server\r\n\r\nif [ \"${USER_UPLOAD}\" == \"true\" ] || [ \"${USER_UPLOAD}\" == \"1\" ]; then\r\n    echo -e \"User uploaded files selected - assuming user knows what they are doing. Have a good day.\"\r\n    exit 0\r\nfi\r\n\r\n## add git ending if it's not on the address\r\nif [[ ${GIT_ADDRESS} != *.git ]]; then\r\n    GIT_ADDRESS=${GIT_ADDRESS}.git\r\nfi\r\n\r\nif [ -z \"${USERNAME}\" ] && [ -z \"${ACCESS_TOKEN}\" ]; then\r\n    echo -e \"using anon api call\"\r\nelse\r\n    GIT_ADDRESS=\"https:\/\/${USERNAME}:${ACCESS_TOKEN}@$(echo -e ${GIT_ADDRESS} | cut -d\/ -f3-)\"\r\nfi\r\n\r\n\r\n## pull git bot repo\r\nif [ \"$(ls -A \/mnt\/server)\" ]; then\r\n    echo -e \"\/mnt\/server directory is not empty.\"\r\n    if [ -d .git ]; then\r\n        echo -e \".git directory exists\"\r\n        if [ -f .git\/config ]; then\r\n            echo -e \"loading info from git config\"\r\n            ORIGIN=$(git config --get remote.origin.url)\r\n        else\r\n            echo -e \"files found with no git config\"\r\n            echo -e \"closing out without touching things to not break anything\"\r\n            exit 10\r\n        fi\r\n    fi\r\n\r\n    if [ \"${ORIGIN}\" == \"${GIT_ADDRESS}\" ]; then\r\n        echo \"pulling latest from github\"\r\n        git pull\r\n    fi\r\nelse\r\n    echo -e \"\/mnt\/server is empty.\\ncloning files into repo\"\r\n    if [ -z ${BRANCH} ]; then\r\n        echo -e \"cloning default branch\"\r\n        git clone ${GIT_ADDRESS} .\r\n    else\r\n        echo -e \"cloning ${BRANCH}'\"\r\n        git clone --single-branch --branch ${BRANCH} ${GIT_ADDRESS} .\r\n    fi\r\n\r\nfi\r\n\r\n\r\n## install luvit for install time\r\ncurl -L https:\/\/github.com\/luvit\/lit\/raw\/master\/get-lit.sh | sh\r\n\r\n## Install luvit packages\r\n.\/lit install ${LIT_PACKAGES}\r\n\r\necho -e \"install complete\"\r\nexit 0",
            "container": "debian:buster-slim",
            "entrypoint": "bash"
        }
    },
    "variables": [
        {
            "name": "Git Username",
            "description": "Username to auth with git.",
            "env_variable": "USERNAME",
            "default_value": "",
            "user_viewable": true,
            "user_editable": true,
            "rules": "nullable|string"
        },
        {
            "name": "User Uploaded Files",
            "description": "Skip all the install stuff if you are letting a user upload files.\r\n\r\n0 = false (default)\r\n1 = true",
            "env_variable": "USER_UPLOAD",
            "default_value": "0",
            "user_viewable": true,
            "user_editable": true,
            "rules": "required|bool"
        },
        {
            "name": "Auto Update",
            "description": "Pull the latest files on startup when using a GitHub repo.",
            "env_variable": "AUTO_UPDATE",
            "default_value": "0",
            "user_viewable": true,
            "user_editable": true,
            "rules": "required|boolean"
        },
        {
            "name": "Lua Bot File",
            "description": "The file that to be used for the bot.",
            "env_variable": "BOT_LUA_FILE",
            "default_value": "bot.lua",
            "user_viewable": true,
            "user_editable": true,
            "rules": "required|string"
        },
        {
            "name": "Luvit Packages to Install",
            "description": "Install additional Luvit packages such as SinisterRectus\/discordia\r\n\r\nUse spaces to separate each package.",
            "env_variable": "LUVIT_PACKAGES",
            "default_value": "",
            "user_viewable": true,
            "user_editable": true,
            "rules": "nullable|string"
        },
        {
            "name": "Git Repo Address",
            "description": "GitHub Repo to clone\r\n\r\nI.E. https:\/\/github.com\/parkervcp\/repo_name",
            "env_variable": "GIT_ADDRESS",
            "default_value": "",
            "user_viewable": true,
            "user_editable": true,
            "rules": "nullable|string"
        },
        {
            "name": "Install Branch",
            "description": "The branch of the bot to install.",
            "env_variable": "BRANCH",
            "default_value": "",
            "user_viewable": true,
            "user_editable": true,
            "rules": "nullable|string"
        },
        {
            "name": "Git Access Token",
            "description": "Password to use with git.\r\n\r\nIt's best practice to use a Personal Access Token.\r\nhttps:\/\/github.com\/settings\/tokens\r\nhttps:\/\/gitlab.com\/-\/profile\/personal_access_tokens",
            "env_variable": "ACCESS_TOKEN",
            "default_value": "",
            "user_viewable": true,
            "user_editable": true,
            "rules": "nullable|string"
        }
    ]
}
