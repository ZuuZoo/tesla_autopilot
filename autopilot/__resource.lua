resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'Tesla Autopilot'

author 'ZuuZoo'

client_script {
    "client.lua",
    'config.lua'
}

ui_page "html/index.html"

files {
    'html/*'
}