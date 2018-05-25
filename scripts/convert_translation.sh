source_dir=$(dirname $0)/../translations-export
dest_dir=$(dirname $0)/../trunk/translations


for locale in $*
do
    source_file=${locale}.po
    dest_file=qpdfview_${locale}.ts

    echo "Converting translation of locale "${locale}
    sed -i "s/^\"X-Generator:..*/\"X-Qt-Contexts: true\\\\n\"/" ${source_dir}/${source_file}
    sed -i s/2012-2016/%1/ ${source_dir}/${source_file}
    sed -i -r  "/^msgctxt \"[^Qq][^:]+\"/ s/^msgctxt \"([^Qq][^:|\"]+)|\"$/msgctxt \"qpdfview::\1/" ${source_dir}/${source_file}
    sed -i "/^#\\s/ d" ${source_dir}/${source_file}
    sed -i "/^#$/ d" ${source_dir}/${source_file}

    $LCONVERT_CMD -no-obsolete -i ${source_dir}/${source_file} -o ${dest_dir}/${dest_file}

    sed -i "/^\\s*<extra-po-header.*/ d" ${dest_dir}/${dest_file}
    sed -i "s/<translation>/<translation type=\"unfinished\">/" ${dest_dir}/${dest_file}
done
