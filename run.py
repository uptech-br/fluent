from fluent import sender
from fluent import event

if __name__ == '__main__':
    sender.setup('mongo', host='127.0.0.1', port=24224)

    event.Event('test', {
    'from': 'userA',
    'to':   'userB'
    })
