# Create a CSV script that would lock funds until one hundred and fifty blocks had passed
publicKey=02e3af28965693b9ce1228f9d468149b831d6a0540b25e8a9900f71372c11fb277

# Relative one 
BLOCKHEIGHT=150

HEX=$(printf '%08x\n' $BLOCKHEIGHT | sed 's/^\(00\)*//'); 

HEXFIRST=$(echo $HEX| cut -c1)

[[ 0x$HEXFIRST -gt 0x7 ]] && HEX="00"$HEX

LEHEX=$(echo $HEX | tac -rs .. | echo "$(tr -d '\n')");


SIZE=$(echo -n $LEHEX | wc -c | awk '{print $1/2}') # two digits

PUBKEY_HASH=$(echo $publicKey | xxd -r -p | openssl sha256 -binary | openssl rmd160 | cut -d' ' -f2)



#  OP_PUSHDATA <BLOCKHEIGHT_LE_LENGTH> <BLOCKHEIGHT> OP_CHECKSEQUENCEVERIFY  OP_DROP - Relative timelock script  
#   OP_DUP OP_HASH160 OP_PUSHDATA 20bytes <PUBKEY_HASH> OP_EQUALVERIFY OP_CHECKSIG - P2PKH script 

CSV_SCRIPT="0$SIZE"$LEHEX"b27576a914"$PUBKEY_HASH"88ac"

echo $CSV_SCRIPT

