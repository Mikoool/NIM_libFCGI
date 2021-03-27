# NIM + libFCGI example

This > fcgiapp_start("ip:port", number_of_threads)

# Dependencies:
libFGGI: https://github.com/FastCGI-Archives/fcgi2

# Compilation:
cd NIM_libFCGI &&
nim compile --verbosity:3 --passL:-lfcgi --threads:on --hints:off main.nim

# Running:
./main
