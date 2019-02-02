options.timeout = 120
options.subscribe = true
options.create = true
-- options.expunge = true

me_at = "sdf@" -- both sdf@fomichev.me and sdf@google.com
status, password = pipe_from('/home/sdf/src/dotfiles/mail/password sdf_fomichev_me')

k = IMAP {
    server = 'imap.gmail.com',
    ssl = 'tls1',
    username = 'sdf@fomichev.me',
    password = password
}

k.INBOX:check_status()

-- everything from me should be marked as read
k.INBOX:is_unseen():contain_from(me_at):mark_seen()

-- syzkaller bugs have it's own directory
k:create_mailbox('syzkaller')
syzbot = (k.INBOX:contain_from('syzbot') + k.INBOX:contain_cc('syzkaller-bugs')) - k.INBOX:contain_to(me_at)
syzbot:move_messages(k['syzkaller'])

-- mailing lists have their own directories
lists = {
	"netdev",
	"driverdev-devel",
	"platform-drive-x86",
	"linux-crypto",
	"arch-general",
	"bitcoin-dev",
	"iovisor-dev",
}

for i, name in ipairs(lists) do
	k:create_mailbox(name)
	messages = k.INBOX:contain_field("List-Id", name)
	messages:move_messages(k[name])
end

-- something that is addressed to me and is on the cc of a known mailing
-- list should be moved to the appropriate mailbox (and flagged later)
for i, name in ipairs(lists) do
	messages = k.INBOX:contain_to(me_at) + k.INBOX:contain_cc(name .. "@")
	messages:move_messages(k[name])
end

-- flag to:me on the mailing lists
for i, name in ipairs(lists) do
	unseen = k[name]:is_unseen()
	messages = unseen:contain_to(me_at)
	messages:mark_flagged()
end
