import CKBTC "../src";

let ckbtcMinter = actor("mqygn-kiaaa-aaaar-qaadq-cai") : CKBTC.Minter.Service;
let ckbtcLedger = actor("r7inp-6aaaa-aaaaa-aaabq-cai") : CKBTC.Ledger.Service;
let ckbtcIndex = actor("n5wcd-faaaa-aaaar-qaaea-cai") : CKBTC.Index.Service;
let ckbtcArchive = actor("nbsys-saaaa-aaaar-qaaga-cai") : CKBTC.Archive.Service;