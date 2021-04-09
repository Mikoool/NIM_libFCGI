import fcgi_lib, locks

var 
    thr: array[20, Thread[void]]
    L: Lock
    socketId: int
    req_id: int = 1


proc fcgiapp_start*(ip_and_port: string, threads: int): int=

    if FCGX_Init() == 0:
        echo "FCGI initialized"
    else:
        echo "Unable to init FCGI"
        return 1

    socketId = FCGX_OpenSocket(ip_and_port, cast[cint](threads))

    if socketId == -1:
        echo "Error, FCGX_OpenSocket failed"
        return 2


    proc worker(): void {.thread, nimcall.} =

        var 
            lock {.threadvar.}: Lock
            request {.threadvar.}: FCGX_Request 
            socket {.threadvar.}: int
        
        while true:
            deepCopy(socket, socketId)
            if FCGX_InitRequest(addr request, socket, 0) != 0:
                acquire(lock)
                echo "Unable to init request"
                release(lock)
                break
        
            acquire(lock)
        
            if FCGX_Accept_r(request.addr) != 0:
                echo "Unable to accept request"
                break
            
            let 
                server_name = $(FCGX_GetParam("SERVER_NAME", request.envp))
                client_ip = $FCGX_GetParam("REMOTE_ADDR", request.envp)
                client_port = $FCGX_GetParam("REMOTE_PORT", request.envp)
                content_length = $FCGX_GetParam("CONTENT_LENGTH", request.envp)
                content_type = $FCGX_GetParam("CONTENT_TYPE", request.envp)
                request_method = $FCGX_GetParam("REQUEST_METHOD", request.envp)
                query_string = $FCGX_GetParam("QUERY_STRING", request.envp)
                script_name = $FCGX_GetParam("SCRIPT_NAME", request.envp)
                request_uri = $FCGX_GetParam("REQUEST_URI", request.envp)
                document_root = $FCGX_GetParam("DOCUMENT_ROOT", request.envp)
                server_protocol = $FCGX_GetParam("SERVER_PROTOCOL", request.envp)
                request_scheme = $FCGX_GetParam("REQUEST_SCHEME", request.envp)
                https = $FCGX_GetParam("HTTPS", request.envp)
                gateway_interface = $FCGX_GetParam("GATEWAY_INTERFACE", request.envp)
                server_addr = $FCGX_GetParam("SERVER_ADDR", request.envp)
                server_port = $FCGX_GetParam("SERVER_PORT", request.envp)
                server_software = $FCGX_GetParam("SERVER_SOFTWARE", request.envp)
            
            echo "Request id:" & $req_id & " " & client_ip & ":" & client_port & " " & request_method

            release(lock)

            discard FCGX_PutS("Content-type: text/html\r\n", request.out)
            discard FCGX_PutS("\r\n", request.out)
            discard FCGX_PutS("NIM+libFCGI, request id:", request.out)
            discard FCGX_PutS($req_id & "<br>" & $server_name & "<br>" & $client_ip & "<br>" & $client_port & "<br>" & $content_type, request.out)
            FCGX_Finish_r(request.addr)
            req_id += 1

    echo "Creating Threads"

    initLock(L)
    for i in 0..high(thr):
        echo "Thread: ", i
        createThread(thr[i] , worker)
    joinThreads(thr)
    deinitLock(L)

    return 0
    
