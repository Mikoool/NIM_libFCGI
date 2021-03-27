{.deadCodeElim: on.}
when defined(windows):
  const
    fcgiapp* = "libfcgi.dll"
elif defined(macosx):
  const
    fcgiapp* = "libfcgi.dylib"
else:
  const
    fcgiapp* = "libfcgi.so"
  
  type
    FCGX_Stream* {.bycopy.} = object
        rdNext*: ptr cuchar
        wrNext*: ptr cuchar
        stop*: ptr cuchar
        stopUnget*: ptr cuchar
        isReader*: cint
        isClosed*: cint
        wasFCloseCalled*: cint
        FCGI_errno*: cint
        fillBuffProc*: proc (stream: ptr FCGX_Stream) {.cdecl.}
        emptyBuffProc*: proc (stream: ptr FCGX_Stream; doClose: cint) {.cdecl.}
        data*: pointer
    FCGX_ParamArray* = cstringArray
    FCGX_Request* {.bycopy.} = object
        requestId*: cint
        role*: cint
        `in`*: ptr FCGX_Stream
        `out`*: ptr FCGX_Stream
        err*: ptr FCGX_Stream
        envp*: cstringArray
type va_list* {.importc: "va_list", header: "<stdarg.h>".} = object

proc FCGX_Init*(): int {.header: "fcgiapp.h", varargs.}
proc FCGX_InitRequest*(): int {.header: "fcgiapp.h", varargs.}
proc FCGX_IsCGI*(): cint {.header: "fcgiapp.h", varargs.}
proc FCGX_OpenSocket*(path: cstring; backlog: cint): cint {.header: "fcgiapp.h", varargs.}
proc FCGX_InitRequest*(request: ptr FCGX_Request; sock: cint; flags: cint): cint {.header: "fcgiapp.h", varargs.}
proc FCGX_Accept_r*(request: ptr FCGX_Request): cint {.header: "fcgiapp.h", varargs.}
proc FCGX_Finish_r*(request: ptr FCGX_Request) {.header: "fcgiapp.h", varargs.}
proc FCGX_Free*(request: ptr FCGX_Request; close: cint) {.header: "fcgiapp.h", varargs.}
proc FCGX_Accept*(`in`: ptr ptr FCGX_Stream; `out`: ptr ptr FCGX_Stream;
                 err: ptr ptr FCGX_Stream; envp: ptr FCGX_ParamArray): cint {.header: "fcgiapp.h", varargs.}
proc FCGX_Finish*() {.header: "fcgiapp.h", varargs.}
proc FCGX_StartFilterData*(stream: ptr FCGX_Stream): cint {.header: "fcgiapp.h", varargs.}
proc FCGX_SetExitStatus*(status: cint; stream: ptr FCGX_Stream) {.header: "fcgiapp.h", varargs.}
proc FCGX_GetParam*(name: cstring; envp: FCGX_ParamArray): cstring {.header: "fcgiapp.h", varargs.}
proc FCGX_GetChar*(stream: ptr FCGX_Stream): cint {.header: "fcgiapp.h", varargs.}
proc FCGX_UnGetChar*(c: cint; stream: ptr FCGX_Stream): cint {.header: "fcgiapp.h", varargs.}
proc FCGX_GetStr*(str: cstring; n: cint; stream: ptr FCGX_Stream): cint {.header: "fcgiapp.h", varargs.}
proc FCGX_GetLine*(str: cstring; n: cint; stream: ptr FCGX_Stream): cstring {.header: "fcgiapp.h", varargs.}
proc FCGX_HasSeenEOF*(stream: ptr FCGX_Stream): cint {.header: "fcgiapp.h", varargs.}
proc FCGX_PutChar*(c: cint; stream: ptr FCGX_Stream): cint {.header: "fcgiapp.h", varargs.}
proc FCGX_PutStr*(str: cstring; n: cint; stream: ptr FCGX_Stream): cint {.header: "fcgiapp.h", varargs.}
proc FCGX_PutS*(str: cstring; stream: ptr FCGX_Stream): cint {.header: "fcgiapp.h", varargs.}
proc FCGX_FPrintF*(stream: ptr FCGX_Stream; format: cstring): cint {.header: "fcgiapp.h", varargs.}
proc FCGX_VFPrintF*(stream: ptr FCGX_Stream; format: cstring; arg: va_list): cint {.header: "fcgiapp.h", varargs.}
proc FCGX_FFlush*(stream: ptr FCGX_Stream): cint {.header: "fcgiapp.h", varargs.}
proc FCGX_FClose*(stream: ptr FCGX_Stream): cint {.header: "fcgiapp.h", varargs.}
proc FCGX_GetError*(stream: ptr FCGX_Stream): cint {.header: "fcgiapp.h", varargs.}
proc FCGX_ClearError*(stream: ptr FCGX_Stream) {.header: "fcgiapp.h", varargs.}
proc FCGX_CreateWriter*(socket: cint; requestId: cint; bufflen: cint; streamType: cint): ptr FCGX_Stream {.header: "fcgiapp.h", varargs.}
proc FCGX_FreeStream*(stream: ptr ptr FCGX_Stream) {.header: "fcgiapp.h", varargs.}
proc FCGX_ShutdownPending*() {.header: "fcgiapp.h", varargs.}
