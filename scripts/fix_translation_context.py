import sys
from collections import defaultdict
import xml.etree.ElementTree as etree

file_path = sys.argv[1]
document = etree.parse(file_path)

msg_by_ctx = defaultdict(list)

ts = document.getroot()

for context in ts.findall('context'):
    ts.remove(context)

    for message in context.findall('message'):
        context.remove(message)

        comment = message.find('comment')
        message.remove(comment)

        ctx = comment.text[:-1]
        msg_by_ctx[ctx].append(message)

for ctx, msg in msg_by_ctx.items():
    if '::' not in ctx and ctx[0] != 'Q':
        ctx = 'qpdfview::' + ctx

    context = etree.SubElement(ts, 'context')

    name = etree.SubElement(context, 'name')
    name.text = ctx

    context.extend(msg)

document.write(file_path, 'utf-8')
