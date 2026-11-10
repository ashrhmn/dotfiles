Set Shell "bash"
Set FontSize 20
Set Width 1400
Set Height 600
Set Padding 16
Set TypingSpeed 35ms
Set Theme "Dracula"
Hide
Type 'tmux -S "$RECORDING_TMUX_SOCKET" attach -t recording'
Enter
Sleep 700ms
Show
Type "timeout 45s python -u -m http.server 18765 --bind 127.0.0.1"
Enter
Wait+Screen /Serving HTTP/
Ctrl+b
Right
Type "curl --max-time 5 -i http://127.0.0.1:18765/"
Enter
Wait+Screen /200 OK/
Sleep 3s
