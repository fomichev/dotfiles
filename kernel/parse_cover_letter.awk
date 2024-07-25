BEGIN {
	is_cover_letter=0
	cover_letter=""
}

{
	if ($0 ~ "-----BEGIN COVER LETTER-----") {
		is_cover_letter=1
	} else if ($0 ~ "-----END COVER LETTER-----") {
		is_cover_letter=0
	} else {
		if (is_cover_letter == 1) {
			gsub(/^    /, "", $0) # trim 4 leading whitespaces
			cover_letter = cover_letter $0 "\n"
		}
	}
}

END {
	print cover_letter
}
