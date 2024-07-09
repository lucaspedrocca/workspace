import xml.etree.ElementTree as ET
import json


data = '''<person>
    <name>Lucas</name>
    <phone type="intl">
        +54 351 152 000 000
    </phone>
    <email hide="yes"/>
</person>'''

tree = ET.fromstring(data)
print('Name:', tree.find('name').text)
print('Attr:', tree.find('email').get('hide'))

#import json

data = '''{
    "name": "Lucas",
    "phone": {
        "type": "intl",
        "number": "+54 351 152 000 000"
    },
    "email": {
        "hide": "yes"
    }
}'''

info = json.loads(data)
print('Name:', info["name"])
print('Hide:', info["email"]["hide"])


