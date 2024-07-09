import re
import socket

lin = "From lucas.pedrocca@mi.unc.edu.ar Sat Jan 5 09:14:16 2022, From lucas.pedrocca@mi.unc.edu.ar Sat Jan 5 09:14:16 2022, From lucas.pedrocca@mi.unc.edu.ar Sat Jan 5 09:14:16 2022"
host = re.findall('@([\S]*)', lin)

print(host)

# Mini Navegador Web

mysock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
mysock.connect(('data.pr4e.org', 80))
cmd = 'GET http://data.pr4e.org/romeo.txt HTTP/1.0\r\n\r\n'.encode()
mysock.send(cmd)

while True:
    data = mysock.recv(512)
    if len(data) < 1:
        break
    print(data.decode(),end='')
mysock.close()

# get the max number from an array

