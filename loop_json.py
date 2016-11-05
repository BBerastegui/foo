import collections

def clean_doc(d):
    for k, v in d.iteritems():
        if isinstance(v, dict):
            clean_doc(v)
        elif isinstance(v, list):
            for element in v:
                clean_doc(element)
        else:
            print "{0} : {1}".format(k, v)

doc = {
    'ip': 'ip',
    'tcp': [{
        'port': 234,
        'content': [{
            'whatevername': 001,
            'whateverothername': [{
                'deepah1': 000002
            }, {
                'deepah2': 00000
            }],
            'script': {
                'ssl-cert': 'ADFSGASDFADSFASD'
            }
        }, {
            'AA': 'BBB'
        }]
    }],
    'udp': [{
        'port': 234,
        'content': [{
            'whateverothername': 002
        }]
    }],
    'created_at': 'ts',
    'tags': []
}

print clean_doc(doc)
