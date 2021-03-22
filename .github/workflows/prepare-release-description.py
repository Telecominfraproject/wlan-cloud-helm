import sys

import keepachangelog

CATEGORIES = ['added', 'changed', 'deprecated', 'removed', 'fixed', 'security']

version = sys.argv[1]

try:
    changes = keepachangelog.to_dict("CHANGELOG.md")[version]
except KeyError:
    print(f'No changelog entry for version {version}', file=sys.stderr)
    exit(1)


print('## Changelog')
for category in CATEGORIES:
    entries = changes.get(category, [])

    if entries:
        print(f'### {category.capitalize()}') 

    for entry in entries:
        print(f'- {entry}') 
