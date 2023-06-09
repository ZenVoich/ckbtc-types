# ckBTC canisters interface


## ckTESTBTC canister ids (Bitcoin testnet)

ckTESTBTC Minter - `ml52i-qqaaa-aaaar-qaaba-cai`

ckTESTBTC Ledger - `mc6ru-gyaaa-aaaar-qaaaq-cai`

ckTESTBTC Index - `mm444-5iaaa-aaaar-qaabq-cai`

ckTESTBTC Archive - `m62lf-ryaaa-aaaar-qaacq-cai`


## ckBTC canister ids (Bitcoin mainnet)

ckBTC Minter - `mqygn-kiaaa-aaaar-qaadq-cai`

ckBTC Ledger - `mxzaz-hqaaa-aaaar-qaada-cai`

ckBTC Index - `n5wcd-faaaa-aaaar-qaaea-cai`

ckBTC Archive - `nbsys-saaaa-aaaar-qaaga-cai`


## Import

```motoko
import CKBTC "mo:ckbtc-types";

let ckbtcMinter = actor("mqygn-kiaaa-aaaar-qaadq-cai") : CKBTC.Minter.Service;
let ckbtcLedger = actor("mxzaz-hqaaa-aaaar-qaada-cai") : CKBTC.Ledger.Service;
let ckbtcIndex = actor("n5wcd-faaaa-aaaar-qaaea-cai") : CKBTC.Index.Service;
let ckbtcArchive = actor("nbsys-saaaa-aaaar-qaaga-cai") : CKBTC.Archive.Service;
```

### Links
- [What is ckBTC](https://internetcomputer.org/ckbtc/)
- [How to interact with ckBTC Minter](https://github.com/dfinity/ic/tree/master/rs/bitcoin/ckbtc/minter)