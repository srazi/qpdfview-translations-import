source_dir=$(dirname $0)/../trunk/translations
dest_dir=$(dirname $0)/../translations-export

source_file=qpdfview_ast.ts
dest_file=qpdfview.pot

lconvert -i ${source_dir}/${source_file} -o ${dest_dir}/${dest_file} -of pot
sed -i "s/^msgctxt \"qpdfview::/msgctxt \"/" ${dest_dir}/${dest_file}

