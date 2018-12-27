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
            3, /* we need a maximum of 3 runtime slices */
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
        } else 
        
        if(UniqueJobIdentifier == WOLFRAMALPHA_JOB) {
            // OK. It worked and we got a result
            emit ResultLog(concat("WolframAlphaExample returned the following result: <", Result, ">", "", ""));
            // set the dummy flag, so that the event log gets raised
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

