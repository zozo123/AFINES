make clean
make -j network
mdkir -f out
./bin/afines -c design_principles_paper/config/network.cfg --restart true --dir out

