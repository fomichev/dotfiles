options.timeout = 120
options.subscribe = true
options.create = true
-- options.expunge = true

me_at = "sdf@" -- both sdf@fomichev.me and sdf@google.com
status, password = pipe_from('/home/sdf/bin/secret sdf_fomichev_me')

k = IMAP {
    server = 'imap.gmail.com',
    ssl = 'tls1',
    username = 'sdf@fomichev.me',
    password = password
}

k.INBOX:check_status()

-- everything from me should be marked as read
k.INBOX:is_unseen():contain_from(me_at):mark_seen()

-- mailing lists have their own directories
--
-- if the email targeted to multiple lists, we will put in the
-- first match
lists = {
	"bpf@vger.kernel.org",
	"netdev@vger.kernel.org",
	"linux-crypto@vger.kernel.org",
	"arch-general@archlinux.org",
	"bitcoin-dev@lists.linuxfoundation.org",
	"iovisor-dev@lists.iovisor.org",
	"linux-kernel@vger.kernel.org",
}

for i, email in ipairs(lists) do
	name = string.gsub(email, "@.+$", "")
	k:create_mailbox(name)
	messages = k.INBOX:contain_to(name) + k.INBOX:contain_cc(name)
	messages:move_messages(k[name])
end

-- mark everything on lkml as read except from those
lkml_ignore_except = {
	'torvalds@linux-foundation.org',
}

lkml_new = k["linux-kernel"]:is_unseen()
lkml_new:mark_seen()
for i, from in ipairs(lkml_ignore_except) do
       lkml_new:contain_from(from):unmark_seen()
end

-- something that is addressed to me and is on the cc of a known mailing
-- list should be moved to the appropriate mailbox (and flagged later)
for i, email in ipairs(lists) do
	name = string.gsub(email, "@.+$", "")
	messages = k.INBOX:contain_to(me_at) + k.INBOX:contain_cc(name .. "@")
	messages:move_messages(k[name])
end

-- flag to:me on the mailing lists
for i, email in ipairs(lists) do
	name = string.gsub(email, "@.+$", "")
	unseen = k[name]:is_unseen()
	messages = unseen:contain_to(me_at)
	messages:mark_flagged()
end
