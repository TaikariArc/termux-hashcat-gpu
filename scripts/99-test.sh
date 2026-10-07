#!/data/data/com.termux/files/usr/bin/bash
# 快速验证 MD5/SHA1
H=$HOME
P=$PREFIX
cd $H/deps/hashcat
echo "=== MD5 (836 MH/s 预期) ==="
./hashcat -a 3 -m 0 -d 1 -w 1 -O --runtime 10 --potfile-disable \
    example0.hash '?l?l?l?l?l?l' 2>&1 | grep -E "Status:|Speed"
echo ""
echo "=== SHA1 ==="
echo 'b89eaac7e61417341b710b727768294d0e6a277b' > $P/tmp/t100.hash
./hashcat -a 3 -m 100 -d 1 -w 1 -O --self-test-disable --potfile-disable \
    -1 h -2 a -3 s -4 h -5 c -6 a -7 t \
    $P/tmp/t100.hash '?1?2?3?4?5?6?7' 2>&1 | grep -E "Status:|Recovered:|Speed"
