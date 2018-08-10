options.timeout = 120
options.subscribe = true
options.create = true
-- options.expunge = true

status, password = pipe_from('/home/sdf/src/dotfiles/mail/password sdf_fomichev_me')

k = IMAP {
    server = 'imap.gmail.com',
    ssl = 'tls1',
    username = 'sdf@fomichev.me',
    password = password
}

k.INBOX:check_status()

-- move syzkaller bugs into it's own directory
k:create_mailbox('syzkaller')
syzbot = (k.INBOX:contain_from('syzbot') + k.INBOX:contain_cc('syzkaller-bugs')) - k.INBOX:contain_to("sdf@fomichev.me")
syzbot:move_messages(k['syzkaller'])

-- per mailing list directories
lists = {
	"netdev",
	"driverdev-devel",
	"platform-drive-x86",
	"linux-crypto",
	"linux-kernel",
	"arch-general",
	"bitcoin-dev",
}

for i, name in ipairs(lists) do
	k:create_mailbox(name)
	messages = k.INBOX:contain_field("List-Id", name) - k.INBOX:contain_to("sdf@fomichev.me")
	messages:move_messages(k[name])
end

-- lkml filters
ignore = {
	"ALSA:",
	"android:",
	"ARM:",
	"arm64:",
	"ath10k:",
	"Bluetooth:",
	"can:",
	"coccinelle:",
	"drivers:",
	"drm",
	"dt-bindings:",
	"f2fs:",
	"fpga:",
	"[GIT PULL]",
	"gpio:",
	"HID:",
	"i2c:",
	"iio:",
	"Input:",
	"iommu:",
	"irqchip:",
	"KVM",
	"linux-next",
	"MAINTAINERS:",
	"media:",
	"MIPS:",
	"misc:",
	"mmc:",
	"mtd:",
	"PCI:",
	"phy:",
	"pinctrl:",
	"power:",
	"pwm:",
	"rtc:",
	"rtlwifi:",
	"scsi:",
	"serial:",
	"sound:",
	"spark:",
	"spi:",
	"staging:",
	"tip:",
	"usb:",
	"video:",
	"watchdog:",
	"xen:",
	"XEN",
}

lkml_new = k["linux-kernel"]:is_unseen()
for i, subj in ipairs(ignore) do
	lkml_new:contain_subject(subj):mark_seen()
end
