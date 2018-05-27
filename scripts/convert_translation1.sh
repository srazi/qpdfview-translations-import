source_dir=$(dirname $0)/../translations-export
dest_dir=$(dirname $0)/../trunk/translations


for locale in $*
do
    source_file=${locale}.po
    dest_file=qpdfview_${locale}.ts

    echo "Converting translation of locale "${locale}
    $LCONVERT_CMD -no-obsolete -i ${source_dir}/${source_file} -o ${dest_dir}/${dest_file}

    python3 $(dirname $0)/fix_translation_context.py ${dest_dir}/${dest_file}
    sed -i "s/<translation>/<translation type=\"unfinished\">/" ${dest_dir}/${dest_file}
done
