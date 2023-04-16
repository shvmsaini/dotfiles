#! /bin/sh

hc(){
	herbstclient "$@"
}

hc chain . rule class="Logseq" tag=study once . spawn com.logseq.Logseq 
hc chain . rule class="firefoxdeveloperedition" tag=www once . spawn firefox-developer-edition 
hc chain . rule class="code-oss" tag=code once . spawn code

