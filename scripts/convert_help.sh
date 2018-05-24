source_dir=$(dirname $0)/../translations-export/help
dest_dir=$(dirname $0)/../trunk/help

for file in ${source_dir}/*.po
do
	path=${file%/*} 
	base=${file##*/}
	prefix=${base%.*}
	suffix=${base##.*}

	echo "Converting help for locale "${prefix}
	po4a-translate -k 0 --format xhtml --master-charset utf-8 --localized-charset utf-8 \
		--master ${dest_dir}/help.html \
		--po ${file} --localized ${dest_dir}/help_${prefix}.html
done

