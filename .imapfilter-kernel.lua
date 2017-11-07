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

messages = k.INBOX:contain_field("List-Id", "driverdev-devel") - k["INBOX"]:contain_to("kernel@fomichev.me")
messages:move_messages(k["driverdev-devel"])

messages = k.INBOX:contain_field("List-Id", "platform-drive-x86") - k["INBOX"]:contain_to("kernel@fomichev.me")
messages:move_messages(k["platform-drive-x86"])

messages = k.INBOX:contain_field("List-Id", "linux-kernel") - k["INBOX"]:contain_to("kernel@fomichev.me")
messages:move_messages(k["linux-kernel"])

messages = k.INBOX:contain_field("List-Id", "arch-general") - k["INBOX"]:contain_to("kernel@fomichev.me")
messages:move_messages(k["arch-general"])

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
	"net:",
	"netfilter:",
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
