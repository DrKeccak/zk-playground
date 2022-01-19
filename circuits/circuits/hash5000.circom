pragma circom 2.0.0;

include "../../node_modules/circomlib/circuits/sha256/sha256.circom";
include "../../node_modules/circomlib/circuits/bitify.circom";

/*This circuit template checks that c is the multiplication of a and b.*/  

template Hash5000 () {  

    // Declaration of signals.  
    signal input in;
    signal output out;

    // Constraints.
    component bitified = Num2Bits(256);
    bitified.in <== in;

    component hashes[5000];
    hashes[0] = Sha256(256);
    for (var i=0; i<256; i++) {
        hashes[0].in[i] <== bitified.out[i];
    }
    for (var i=1; i<5000; i++) {
        hashes[i] = Sha256(256);
        for (var j=0; j<256; j++) {
            hashes[i].in[j] <== hashes[i - 1].out[j];
        }
    }
}

component main = Hash5000();