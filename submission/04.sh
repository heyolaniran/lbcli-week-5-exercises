# Create a CLTV script with a timestamp of 1495584032 and public key below:
publicKey=02e3af28965693b9ce1228f9d468149b831d6a0540b25e8a9900f71372c11fb277

# Get the equivalent LE HEx of timestamp

hex=$(printf '%08x\n' 1495584032 | sed 's/^\(00\)*//'); 




LEHEX=$(echo $hex | tac -rs .. | echo "$(tr -d '\n')");


# calculate the public key hash
# - Convert to binary | sha256 | ripemd160

PUBKEY_HASH=$(echo $publicKey | xxd -r -p | openssl sha256 -binary | openssl rmd160 | cut -d' ' -f2)

#  OP_PUSHDATA 4bytes <TIMESTAMP> OP_CHECKLOCKTIMEVERIFY OP_DROP OP_DUP OP_HASH160 OP_PUSHDATA 20 BYTES <PUBLIC_KEYHASH> OP_EQUALVERIFY OP_CHECKSIG

SERIALIZED_SCRIPT="04"$LEHEX"b17576a914"$PUBKEY_HASH"88ac"

echo $SERIALIZED_SCRIPT