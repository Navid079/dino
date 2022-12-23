flex ./dinolex.lex
gcc lex.yy.c -o dinolex.bin
chmod +x dinolex.bin
echo =========================
echo Testing Hello World:
cat codes/helloworld.dino | ./dinolex.bin
echo ==========================
echo Testing fibonacci:
cat codes/fibonacci.dino | ./dinolex.bin
echo ===========================
echo Testing math.dino:
cat codes/math.dino | ./dinolex.bin
echo ===========================
