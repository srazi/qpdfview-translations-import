source_dir=$(dirname $0)/../trunk/help
dest_dir=$(dirname $0)/../translations-export/help

po4a-gettextize --format xhtml --master-charset utf-8 --po ${dest_dir}/help.pot \
	--msgid-bugs-address "launchpad-translators@lists.launchpad.net" --copyright-holder "Adam Reichold" \
	--package-name "qpdfview" --package-version "1.0" \
	-m ${source_dir}/help.html

