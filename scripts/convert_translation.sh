source_dir=$(dirname $0)/../translations-export
dest_dir=$(dirname $0)/../trunk/translations

for locale in $*
do
	source_file=${locale}.po
	dest_file=qpdfview_${locale}.ts

	echo "Converting translation of locale "${locale}
	lconvert -i ${source_dir}/${source_file} -o ${dest_dir}/${dest_file}
done

