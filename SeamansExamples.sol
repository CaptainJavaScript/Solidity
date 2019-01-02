pragma solidity ^0.4.25;

import "./usingCaptainJS.sol";

contract IsOwnableAndDestructable {
    address Owner;
    constructor () internal {
        Owner = msg.sender;
    }

    function Destruct() public onlyOwner {
        selfdestruct(Owner);
    }

    function Payout(uint Amount) public onlyOwner {
        address(Owner).transfer(Amount);
    }

    modifier onlyOwner {
        require(
            msg.sender == Owner,
            "..."
        );
        _;
    }
}

contract SeamansExamples is usingCaptainJS, IsOwnableAndDestructable {

    uint constant CENTIMETER_JOB = 1;
    uint constant WOLFRAMALPHA_JOB = 2;
    uint constant SHIPS_BELL_RING = 3;
    uint constant JSON_QUERY_EXAMPLE = 4;
    uint constant HTML_QUERY_EXAMPLE = 5;
    uint constant ENCRYPTED_MAIL_SEND_EXAMPLE = 6;

    constructor () public {
    }

    function UseVoucher() public {
        ActivateVoucher("MobyDick");
    }

    function CallbackExample() public {
        RingShipsBell(
            SHIPS_BELL_RING, /* give the job a unique ID */
            20, /* minutes from now */ 
            DEFAULT_GAS_UNITS, /* use default gas */
            DEFAULT_GAS_PRICE /* use default gas price */
        );    
    }

    function WolframAlphaExample(string Country) public {
        Run(
            WOLFRAMALPHA_JOB, /* give the job a unique ID */            
            concat ( /* JavaScript code I want to execute: */
                "module.exports = async function(CaptainJSIn) { ",
                "   const axios = require('axios'); ",
                "   const WAlpha = await axios.get('http://www.wolframalpha.com/queryrecognizer/query.jsp?appid=DEMO&mode=Default&i=' + CaptainJSIn + '&output=json'); ",          
                "   return JSON.stringify(WAlpha.data); ",
                "}"
            ),
            Country, /* Input parameter which will result in CaptainJSIn (see above) */
            "axios, mathjs", /* Nodejs libraries we need */
            3, /* we need a maximum of 3 runtime slices */
            200000, /* use 200,000 gas units */
            DEFAULT_GAS_PRICE /* use default gas price */
        );    
    }

    function CentimeterToInchExample(string Centimeter) public {
        Run(
            CENTIMETER_JOB,  /* give the job a unique ID */
            /* JavaScript code I want to execute: */
            "module.exports = function(CaptainJSIn) { var math = require('mathjs'); return math.eval(CaptainJSIn + ' cm to inch'); }", 
            Centimeter, /* Input parameter which will result in CaptainJSIn (see above) */
            "mathjs",  /* Nodejs libraries we need */
            /* we need a maximum of 2 runtime slices */
            3, /* we need a maximum of 3 runtime slices */
            DEFAULT_GAS_UNITS, /* use default gas units */ 
            DEFAULT_GAS_PRICE /* we will transfer the default gas price for return */
        );    
    }

    function HTMLqueryExample() public {
        Run(
            HTML_QUERY_EXAMPLE,  /* give the job a unique ID */
            /* url needs to start with html: */
            "html:http://www.amazon.co.uk/gp/product/1118531647",
            /* Input parameter is the JQuery. Result will be stored in QUERY_RESULT variable */ 
            "$('span.inlineBlock-display span.a-color-price').each(function(i, element) {var el = $(this); QUERY_RESULT = el.text(); })", 
            "",  /* no modules required */
            1, /* queries are fast */
            DEFAULT_GAS_UNITS, /* use default gas units */ 
            DEFAULT_GAS_PRICE /* we will transfer the default gas price for return */
        );    
    }
    
    function EncryptedMailExample() public {
        Run(
            ENCRYPTED_MAIL_SEND_EXAMPLE,
            "crypt:8366268bd167a9f8318f99c71d0f489d0372b545735c2e10303c47bad2507e933171f72fd81e86b26445fda134ed11de3ba11deafe7cc98fabbc98b829186a079d17179a568649a7a56b231c8809fa5fd80c297bafce0a603baf2d183646f6b1b0600efb2ce95b0e250de530d278cef696603b229114653a2986a4ab63b8b28df5db1f1fd94124fea9baf8ab8a0c998e677e7ed57f405c8479aeaf9be200cda27a7d0e62749f63f72f8ab5d549946980363831dab80dcefa3906ed8a37e7a8c2cd78e7ec05167eb0e716cf7d73c205ad7700f9c450a56d60175716bb090a8cb9488315407ed15a78d2f50aa0cbd26bb0e012a1a64b769e6d74ee309a19981ba15a8fc82d039e511f8a76d960a8fafb5a395bbad7610be71ca57b290d59c7dc59149f67f25fa76c08211e4e96be1be06ceea9785fdf8049791a3b6d058fad9d1848064aaabff385240f4c23212510cf2cb66877a91d95b031b96541048b2ed285d655d0b1a07dcc45ba1e55e5a3e7e091c8655a82000f83d939821876cb7b50c3f6cc474bef9b173cea19afa17f7e8398a98b5014d734c85759aa5e9be6c2fe197ab07c2db0efac05cce6dbd6c3a0a45eb6bce65c15fa1147785ef39a31d6c93479111be6a74f0e9eb07ef77bd8422b9ccdb6c32621ab5d0b33bddfbd7ad418cb49ee0e3d285be5c2ce1203d6148e7de213bf673f4206d93ccb5afe250a7776bc6f1b20a00d698eebae8c77e623764fbc1c86d900e320f3a73e33c5340da45e56092fac7f0a074c173eec8dec747d35a1c15764affc296ad5e0b2218d62fbc6c540c1fbe35f124d0265743759444a559ecfc9fb74288b9c5d9dd1801cf4ffb2e1172e0f4078b4d2befaed4e8b13f9f2e96f47888263c8f2a3be115cdd7776c79993ee1892180c7e145d2392bf4615794223c9762ccd3202f356f3afd988ee07267dd1eb777862bd9926a3ad628e100bf77f588ce655be437191f8d3ecc26b68c579ffe0bcdab543752ff65f66a49b6cde418f5806b83530f84b512bb6ab7ba5763edfec97602f2d659e9b8b8ba18dcc847c6d2f41be2cabc083fc991b5621f404ad3e62563b5f6416acd1b949ddf09335f44519119b66631206044b28bad784df8f46b924d1cd7dede10916529f2e7031b4d44df979d994df103ead0960d20dd72b8871a2857f61328fd4ecdfda7df2d6057497011bc5eeb663ba0f80b1d9bad0c1",
            "",
            "",
            1,
            DEFAULT_GAS_UNITS, /* use default gas units */ 
            DEFAULT_GAS_PRICE /* we will transfer the default gas price for return */
        );
    }
    
    function JSONqueryExample() public {
        Run(
            JSON_QUERY_EXAMPLE,  /* give the job a unique ID */
            /* url needs to start with json: */
            "json:https://api.kraken.com/0/public/Ticker?pair=ETHUSD",
            /* Input parameter is the JSON path */ 
            "result.XETHZUSD.a[0]", 
            "",  /* no modules required */
            1, /* queries are fast */
            DEFAULT_GAS_UNITS, /* use default gas units */ 
            DEFAULT_GAS_PRICE /* we will transfer the default gas price for return */
        );    
    }

    function CaptainsResult(uint UniqueJobIdentifier, string Result) external onlyCaptainsOrdersAllowed {
        // analyse the return results
        if(UniqueJobIdentifier == CENTIMETER_JOB) {
            // OK. It worked and we got a result
            emit ResultLog(concat("CentimeterToInchExample returned the following result: <", Result, ">", "", ""));
            // set the dummy flag, so that the event log gets raised
            DummyFlagToForceEventSubmission = true;
        } 
        else         
            if(UniqueJobIdentifier == WOLFRAMALPHA_JOB) {
                emit ResultLog(concat("WolframAlphaExample returned the following result: <", Result, ">", "", ""));
                DummyFlagToForceEventSubmission = true;
            }
            else
                if(UniqueJobIdentifier == JSON_QUERY_EXAMPLE) {
                    emit ResultLog(concat("JSON request returned the following result: <", Result, ">", "", ""));
                    DummyFlagToForceEventSubmission = true;
                }
                else
                    if(UniqueJobIdentifier == HTML_QUERY_EXAMPLE) {
                        emit ResultLog(concat("HTML request returned the following result: <", Result, ">", "", ""));
                        DummyFlagToForceEventSubmission = true;
                    }
    }
    
    function CaptainsError(uint UniqueJobIdentifier, string Error) external onlyCaptainsOrdersAllowed {
        // analyse the return results
        if(UniqueJobIdentifier == CENTIMETER_JOB) {
            // OK. It didn't work :-/
            emit ResultLog(concat("CentimeterToInchExample did not work. Returned error is: <", Error, ">", "", ""));
            // set the dummy flag, so that the event log gets raised
            DummyFlagToForceEventSubmission = true;
        }
        else 
        
        if(UniqueJobIdentifier == WOLFRAMALPHA_JOB) {
            // OK. It worked and we got a result
            emit ResultLog(concat("WolframAlphaExample did not work. Returned error is: <", Error, ">", "", ""));
            // set the dummy flag, so that the event log gets raised
            DummyFlagToForceEventSubmission = true;
        }
    }

    function RingRing(uint UniqueIdentifier) external onlyCaptainsOrdersAllowed {
        // OK. It worked and we got a result
        emit ResultLog(concat("Ring Ring Seaman! Calling ship's bell worked! JobId = ", uintToString(UniqueIdentifier)));
        // set the dummy flag, so that the event log gets raised
        DummyFlagToForceEventSubmission = true;
    }


    event ResultLog(string Text);

    function () public payable {
        // accept some cash
    }
    
    bool DummyFlagToForceEventSubmission = false;

    // --------------------> helpers
    
    function uintToString(uint v) internal pure returns (string str) {
        uint maxlength = 100;
        bytes memory reversed = new bytes(maxlength);
        uint i = 0;
        while (v != 0) {
            uint remainder = v % 10;
            v = v / 10;
            reversed[i++] = byte(48 + remainder);
        }
        bytes memory s = new bytes(i);
        for (uint j = 0; j < i; j++) {
            s[j] = reversed[i - 1 - j];
        }
        str = string(s);
    }

    function concat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string){
        bytes memory _ba = bytes(_a);
        bytes memory _bb = bytes(_b);
        bytes memory _bc = bytes(_c);
        bytes memory _bd = bytes(_d);
        bytes memory _be = bytes(_e);
        string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
        bytes memory babcde = bytes(abcde);
        uint k = 0;
        for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
        for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
        for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
        for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
        for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
        return string(babcde);
    }

    function concat(string _a, string _b) internal pure returns (string) {
        return concat(_a, _b, "", "", "");
    }


}


