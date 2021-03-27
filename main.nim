import fcgi_app

let listen: string = "0.0.0.0:9000"

if 0 != fcgiapp_start(listen, 10):
    echo "Smth went wrong..."
else:
    echo "FCGI app quit."