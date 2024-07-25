BEGIN {
	is_cover_letter=0
	skip_empty=0
}

{
	if ($0 ~ "-----BEGIN COVER LETTER-----") {
		is_cover_letter=1
	} else if ($0 ~ "-----END COVER LETTER-----") {
		is_cover_letter=0
		skip_empty=1
	} else if ($0 ~ "-----BEGIN GOOGLE COVER LETTER-----") {
		is_cover_letter=1
	} else if ($0 ~ "-----END GOOGLE COVER LETTER-----") {
		is_cover_letter=0
		skip_empty=1
	} else {
		if (is_cover_letter != 0) {
			next
		}

		if (skip_empty != 0) {
			skip_empty--
			if ($0 ~ "") {
				next
			}
		}

		if ($0 ~ "Change-Id:") {
			next
		}

		print $0
	}
}
