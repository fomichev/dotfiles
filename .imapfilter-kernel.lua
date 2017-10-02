options.timeout = 120
options.subscribe = true
options.create = true
-- options.expunge = true

status, password = pipe_from('cat ~/local/.msmtp_password')

k = IMAP {
    server = 'imap.gmail.com',
    ssl = 'tlsl',
    username = 'kernel@fomichev.me',
    password = password
}

k.INBOX:check_status()

messages = k["INBOX"]:contain_field("List-Id", "driverdev-devel") - k["INBOX"]:contain_to("kernel@fomichev.me")
messages:move_messages(k["driverdev-devel"])

messages = k["INBOX"]:contain_field("List-Id", "platform-drive-x86") - k["INBOX"]:contain_to("kernel@fomichev.me")
messages:move_messages(k["platform-drive-x86"])

messages = k["INBOX"]:contain_field("List-Id", "linux-kernel") - k["INBOX"]:contain_to("kernel@fomichev.me")
messages:move_messages(k["linux-kernel"])

messages = k["INBOX"]:contain_field("List-Id", "arch-general") - k["INBOX"]:contain_to("kernel@fomichev.me")
messages:move_messages(k["arch-general"])
